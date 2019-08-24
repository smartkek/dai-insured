const Insured = artifacts.require('./Insured.sol');
const Authority = artifacts.require('./Authority.sol');
const DSProxy = artifacts.require('./mock/MockDSProxy.sol');
const SaiProxy = artifacts.require('./mock/MockSaiProxy.sol');

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
    saiproxy = await SaiProxy.deployed();
  });



  it("DSProxy should have correct authority", async () => {
    assert.equal(await proxy.authority(), authority.address);
  });

  it("Authority should authorize Insured to call DSProxy", async () => {
    assert.isTrue(await authority.canCall(insured.address, proxy.address, "0x11223344"));
  });
  // it("Insured should call SaiProxy", async () => {
    // await insured.save(DSProxy.address, new BN("0x0102030405060708091011121314151617181920212223242526272829303132"));
    // assert.equal(await SaiProxy.tub(), await insured.tub());
    // assert.equal(await SaiProxy.cup(), 0x0102030405060708091011121314151617181920212223242526272829303132);
    // assert.equal(await SaiProxy.jam(), 1543);
  // });


  // it("should detect incorrect proof", async () => {
  //   let instance = await Lazy.deployed();
  //   let task = await instance.tasks(0);
  //   assert.equal(task.status, 0);
  //   await instance.challenge(0);   
  //   task = await instance.tasks(0);
  //   assert.equal(task.status, 2);
  // });

  // it("should pass correct proof", async () => {
  //   let instance = await Lazy.deployed();
  //   let task = await instance.tasks(1);
  //   assert.equal(task.status, 0);
  //   await instance.challenge(1);
  //   task = await instance.tasks(1);
  //   assert.equal(task.status, 1);
  // });

});
