pragma solidity ^0.5.10;

import "./IERC20.sol";
import "./IExchange.sol";

contract Exchange is IExchange {
    address internal constant DAI = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2; // DAI
    
    function ethToDai(uint minDai) external payable {
        IERC20(DAI).transfer(msg.sender, msg.value * 250);
    }
}