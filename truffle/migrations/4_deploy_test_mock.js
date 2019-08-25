const MockDSProxy = artifacts.require('./mock/MockDSProxy.sol');


module.exports = async function(deployer, network, accounts) {
	deployer.then(async() => {
        await deployer.deploy(MockDSProxy);
	});
};
