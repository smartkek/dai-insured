const Insured = artifacts.require('./Insured.sol');
const Authority = artifacts.require('./Authority.sol');
const MockDSProxy = artifacts.require('./mock/MockDSProxy.sol');


module.exports = async function(deployer, network, accounts) {
	deployer.then(async() => {
        await deployer.deploy(Insured);
        await deployer.deploy(Authority, Insured.address);
        await deployer.deploy(MockDSProxy);
	});
};
