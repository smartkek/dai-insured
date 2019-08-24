const Insured = artifacts.require('./Insured.sol');
const Authority = artifacts.require('./Authority.sol');
const MockDSProxy = artifacts.require('./mock/MockDSProxy.sol');
const MockSaiProxy = artifacts.require('./mock/MockSaiProxy.sol');

// kovan
const WETH = "0xd0A1E359811322d97991E03f863a0C30C2cF029C";
const DAI = "0xf4d791139cE033Ad35DB2B2201435fAd668B1b64";
const SAI_PROXY = "0x96Fc005a8Ba82B84B11E0Ff211a2a1362f107Ef0";
const TUB = "0xa71937147b55Deb8a530C7229C442Fd3F31b7db2";

module.exports = async function(deployer, network, accounts) {
	deployer.then(async() => {
        await deployer.deploy(Insured);
        await deployer.deploy(Authority, Insured.address);
        await deployer.deploy(MockDSProxy);
        await deployer.deploy(MockSaiProxy);
        
	});
};
