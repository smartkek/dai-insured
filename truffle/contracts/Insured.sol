pragma solidity ^0.5.10;

import "./IDSProxy.sol";
import "./IERC20.sol";
import "./Kovan.sol";

contract Insured is Kovan {

    event Saved(IDSProxy DSProxy);    

    function save(IDSProxy target, bytes32 cup) external {
        // main logic here
        
        
        bytes memory data = abi.encodeWithSignature("free(address,bytes32,uint256)", TUB, cup, 0.1 ether);
        target.execute(PROXY, data);
        
        // uniswap.sell
        
        // target.wipe

        emit Saved(target);
    }
    
    // function() external payable {
    //     // only accept payments from MakerDAO system
    //     require (msg.sender == address(target));
    // }
}