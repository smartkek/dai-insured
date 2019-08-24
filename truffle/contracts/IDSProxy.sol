pragma solidity ^0.5.10;

interface IDSProxy {
    function owner() external view returns (address);
    function authority() external view returns (address);
    function setAuthority(address) external;
    function execute(address _target, bytes calldata _data) external payable returns (bytes memory response);
}