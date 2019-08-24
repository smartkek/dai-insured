var Insured = artifacts.require('./Insured.sol');

module.exports = async function(deployer, network, accounts) {
	deployer.then(async() => {
		await deployer.deploy(Insured);
	});
};
