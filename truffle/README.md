# DAI Insured smart contracts
System consists of two contracts:
* Insured - does all the heavy-lifting (talks to MakerDAO contracts, exchange, etc). Main target for bots.
* Authority - allows [DSProxy](https://github.com/dapphub/ds-proxy/blob/master/src/proxy.sol) to work with Insured. Users can continue to use [CDP Portal](https://cdp.makerdao.com/). 

When set up anyone can call `save` and `saveN` methods of Insured to repay endangered CDPs. Both take `DSProxy` and CDP's id as arguments.
* `save(address target, bytes32 cup)` - withdraws ether, sells it, and repays debt. Will revert gracefully if has nothing to do (current collaterizatoin ratio above  `ACTIVE` level);
* `save(address target, bytes32 cup)` - similar to `save`, but continues to repay debt until transaction runs out of gas (transaction finishes successfully) or the CDP becomes safe. Consider setting gas limit manually (might consume several million gas). 


## Deployment
1. Deploy Insured
2. Deploy Authority, use Insured address in constructor
3. Assuming user has his DSProxy contract (created via CDP Portal). Initialize `DSProxy.setAuthority` with Authority's address. 
    * One can use [IDSProxy](contracts/IDSProxy.sol) and [Remix](http://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.5.11+commit.c082d0b4.js) to call `setAuthority` function 
    * Or send call the proxy contract with that `msg.data`: `0x7a9e5e4b000000000000000000000000951b0913e4acb4e788cad7c82b171e3a4402e754` 

Enjoy help from bots! 

### Kovan 
* Insured: [`0xf3bc363b33f4f6efe9fff29257e2dbcdf500f77d`](https://kovan.etherscan.io/address/0xf3bc363b33f4f6efe9fff29257e2dbcdf500f77d). Uses [mock exchange](contracts/mock/MockExchange.sol) for ETH/DAI pair. Send some [Kovan-Dai](https://kovan.etherscan.io/token/0xc4375b7de8af5a38a93548eb8453a498222c4ff2) to [it](https://kovan.etherscan.io/address/0xabe3111ea7c98bef0f748f552f64b22106a374a4).
* Authority: [`0x951b0913e4acb4e788cad7c82b171e3a4402e754`](https://kovan.etherscan.io/address/0x951b0913e4acb4e788cad7c82b171e3a4402e754).

### Mainnet 
* Insured: [`0x...`](). Uses [Uniswap](contracts/mock/MockExchange.sol) for ETH/DAI pair.
* Authority: [`0x...`]().

## Bots
Bots could watch for [LogSetAuthority events](https://github.com/dapphub/ds-auth/blob/f783169408c278f85e26d77ba7b45823ed9503dd/src/auth.sol#L49), emitted from [`DSProxy.setAuthority` cals](https://kovan.etherscan.io/tx/0xba9c937ca87858dc9c0b2c11d33f87fed0f3c95bdc9ef9a38594f948f263f3da#eventlog).

