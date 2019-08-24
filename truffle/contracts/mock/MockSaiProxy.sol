pragma solidity ^0.5.10;


contract MockSaiProxy  {
    address public tub;
    bytes32 public cup;
    uint public jam;

    function free(address tub_, bytes32 cup_, uint jam_) public {
        tub = tub_;
        cup = cup_;
        jam = jam_;
    }
}