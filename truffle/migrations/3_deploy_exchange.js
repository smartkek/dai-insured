const Uniswap = artifacts.require('./Uniswap.sol');


module.exports = async function(deployer, network, accounts) {
	deployer.then(async() => {
        await deployer.deploy(Uniswap);
	});
};
