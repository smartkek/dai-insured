require('babel-register');
require('babel-polyfill');

var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonicRinkeby = "oxygen crunch note tent verify chicken gossip shield essence runway clinic fortune";
var infuraLinkRinkeby = "https://rinkeby.infura.io/v3/198f519e2d9643d689649459edccc350";

module.exports = {
    networks: {
        rinkeby: {
            provider: function() {
                return new HDWalletProvider(mnemonicRinkeby, infuraLinkRinkeby, 1)
            },
            from : "0x6d92a2d06758E014Da0C98d0bBBE9Ed78E964f34".toLowerCase(),
            network_id: 4
        },
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*"
        }
    },
    compilers: {
        solc: {
            version: "0.5.10",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        }
    }
};
