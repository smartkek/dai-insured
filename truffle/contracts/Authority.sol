pragma solidity ^0.5.10;

contract Authority {
    address public insured;

    constructor(address _insured) public {
        insured = _insured;
    }
    
    function canCall(address src, address dst, bytes4 sig) public view returns (bool) {
        // check if caller is authorized for this DSProxy
        return src == insured; 
        // we don't need to check `dst` as `src` is used for all contracts
        // we don't need to check `sig` as `dst` is our contract
    } 
}