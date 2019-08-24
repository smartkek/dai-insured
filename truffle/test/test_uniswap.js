const Uniswap = artifacts.require('./Uniswap.sol');

contract("Testing System", accounts => {
  let uniswap;

  before("setup", async() => {
    uniswap = await Uniswap.deployed();
  });
});
