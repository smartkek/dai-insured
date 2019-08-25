pragma solidity ^0.5.10;

import "./IDSProxy.sol";
import "./IERC20.sol";
import "./IExchange.sol";
import "./Kovan.sol";


interface ITub {
    function ink(bytes32) external view returns (uint);
    function tab(bytes32) external view returns (uint);
    function tag() external view returns (uint);
    function per() external view returns (uint);
}

interface IVox {
    function par() external view returns (uint);
}


contract Insured is Kovan {
    uint constant LIQUIDATION = 150;
    uint constant ACTIVE = 175;
    uint constant TARGET = 200;
    
    uint constant FEE = 1e17; // 0.1 DAI - to buy MKR
    uint constant REWARD = 1e18; // 1 DAI - to give to msg.sender

    event Saved(address DSProxy);
    
    uint constant RAY = 10 ** 27;
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = (x*y + RAY / 2) / RAY;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = (x * RAY + y / 2) / y;
    }
    
    function toRepay(bytes32 cup) internal returns (uint) {
        ITub tub = ITub(TUB);
        uint coll = rmul(tub.tag(),tub.ink(cup));
        uint debt = rmul(IVox(VOX).par(), tub.tab(cup));
        
        uint ratio = coll * 100 / debt;
        
        if (ratio >= ACTIVE) {
            return 0;
        }

        uint need = (TARGET * debt - 100 * coll) / (TARGET - 100);
        uint can = coll - debt * LIQUIDATION / 100;
        uint to = need < can ? need : can;
        return rmul(tub.ink(cup), tub.per()) * to / coll; // redeem part of ink
    }
    
    function withdraw(address target, bytes32 cup, uint amount) internal {
        bytes memory free_data = abi.encodeWithSignature("free(address,bytes32,uint256)", TUB, cup, amount);
        IDSProxy(target).execute(PROXY, free_data);
    }
    
    function sell() internal {
        IExchange(EXCH).ethToDai.value(address(this).balance)(1);
    }
    
    
    function repay(address target, bytes32 cup, uint amount) internal {
        bytes memory wipe_data = abi.encodeWithSignature("wipe(address,bytes32,uint256,address)", TUB, cup, amount, OTC);
        IDSProxy(target).execute(PROXY, wipe_data);
    }
    
    function saveN(address target, bytes32 cup) external {
        IERC20(SAI).approve(target, uint(-1));
        uint iter = 0;
        while (true) {
            if (gasleft() < 1000000) {
                break;
            }

            // how much collateral do we need?
            uint amountEth = toRepay(cup);
            if (amountEth == 0) {
                break;
            }
            
            // free some collateral as WETH
            withdraw(target, cup, amountEth * 99 / 100);

            // how much eth we want to sell?
            sell();

            uint amountDai = IERC20(SAI).balanceOf(address(this));
            // repay some debt
            iter++;
            repay(target, cup, amountDai - FEE - REWARD*iter);
        }        
        if (iter > 0) {
            // pay rewards
            IERC20(SAI).transfer(msg.sender, iter * REWARD);
            emit Saved(target);
        }
    }
    
    function save(address target, bytes32 cup) external {        
        // how much collateral do we need?
        uint amountEth = toRepay(cup);
        require (amountEth > 0, "No help needed");
        // free some collateral as WETH
        withdraw(target, cup, amountEth * 99 / 100);

        // how much eth we want to sell?
        sell();

        IERC20(SAI).approve(target, uint(-1));
        uint amountDai = IERC20(SAI).balanceOf(address(this));
        // repay some debt
        repay(target, cup, amountDai - FEE - REWARD);

        // pay rewards
        IERC20(SAI).transfer(msg.sender, REWARD);

        emit Saved(target);
    }
    
    function() external payable {
    }
}