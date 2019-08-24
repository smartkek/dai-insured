pragma solidity ^0.5.10;

import "./IDSProxy.sol";
import "./IERC20.sol";
import "./Kovan.sol";

contract Insured is Kovan {
    event Saved(address DSProxy);    

    function free_data(bytes32 cup, uint jam) public pure returns (bytes memory) {
        return abi.encodeWithSignature("free(address,bytes32,uint256)", TUB, cup, jam);
    }
    
    address exchange;
    function save(address target, bytes32 cup) external {
        // main logic here
        
        // how much collateral do we need?
        
        // free some collateral as WETH
        IDSProxy(target).execute(PROXY, free_data(cup, 1543));
        
        // how much eth we want to sell?
        // uniswap.sell
        bytes memory data = abi.encodeWithSignature("ethToDai(uint256)", address(this).balance);
        (bool success, ) = exchange.delegatecall(data);//ethToDai()
        require(success, "failed to sell eth for dai at the exchange");
        
        // target.wipe

        emit Saved(target);
    }
    
    function() external payable {
    }
}