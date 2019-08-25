const Insured = artifacts.require('./Insured.sol');
const Authority = artifacts.require('./Authority.sol');
const DSProxy = artifacts.require('./mock/MockDSProxy.sol');


contract("Testing System", accounts => {
  let insured;
  let authority;
  let proxy;
  let saiproxy;

  before("setup", async() => {
    insured = await Insured.deployed();
    authority = await Authority.deployed(insured.address);
    proxy = await DSProxy.deployed(insured.address);
    await proxy.setAuthority(authority.address);
  });



  it("DSProxy should have correct authority", async () => {
    assert.equal(await proxy.authority(), authority.address);
  });

  it("Authority should authorize Insured to call DSProxy", async () => {
    assert.isTrue(await authority.canCall(insured.address, proxy.address, "0x11223344"));
  });
});
