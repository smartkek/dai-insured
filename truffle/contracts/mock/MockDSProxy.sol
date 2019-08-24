pragma solidity ^0.5.10;

import "./../IDSProxy.sol";

contract MockDSProxy is IDSProxy {
    address public authority;
    address public constant owner = 0xf9958fC198163C10f34e931d93aBf7EF18762A2d;
    // function owner() external view returns (address) {
    //     return 0xf9958fC198163C10f34e931d93aBf7EF18762A2d;
    // }

    // function authority() external view returns (address);
    function setAuthority(address a) external {
        authority = a;
    }

    event Called(address _target, bytes _data);
    
    function execute(address _target, bytes calldata  _data) external payable returns (bytes memory response) {
        emit Called(_target, _data);
    }
}