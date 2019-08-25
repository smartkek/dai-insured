# DAI Insured

## Inspiration

The #DeFi movement is rapidly growing into a global financial ecosystem.
One of the key players in this field is MakerDAO.
MakerDAO users lock up ETH in a smart contract and withdraw DAI stablecoin.
This debt is over-collateralized: the value of the Ether locked must exceed the value of the DAI withdrawn with the ratio of at least 1.5.
If it drops below 1.5, the position is liquidated, i.e., the DAI are forcibly returned to the contract, and the (now cheap) Ethers returned to the user, minus the liquidation fee.

To avoid liquidation, users either increase the collateral (ETH) or decrease the debt (DAI).
This moves the position further from the liquidation threshold and makes the CDP "safer".

We identified a problem for Maker CDP holders: to react quickly in the case of rapid market movements, the user must be constantly online.
No existing DeFi project addresses this issue.

### Existing solutions

* [DeFi Saver](https://defisaver.com). It provides the functions ```Repay``` (move further from the liquidation) and ```Boost``` (move closer to liquidation, increase leverage). They have email notifications on the roadmap (see [Can DeFi Saver automatically protect my CDP from liquidation?](https://defisaver.com/faq)), however, even then avoiding liquidation will require manual action. See also: [Introducing CDP Saver](https://blog.decenter.com/2019/04/29/introducing-cdp-saver-cdp-management-and-protection/).
* [InstaDapp Bridge](https://instadapp.io). The InstaDApp liquidity contract "pays back your CDP debt and withdraws ETH that then gets moved to Compound. The liquidity contract then draws an equivalent order to compensate the previously paid debt". This helps as the collateral factor in Compound (80%) is higher than in Maker (66%). This also requires manual user action.
* others?


## What it does

DAI Insured enables a CDP holder to outsource the monitoring and (partially) repaying CDPs to avoid liquidation.
This outsourcing is performed trustlessly and increases market efficiency by enabling markets for CDP monitoring.
When called, DAI Insured decreases the liquidation risk by decreasing the collaterization and debt by the same amount.
With DAI Insure, a user may be sure that their CDP won't be liquidated.

### Two ways to avoid liquidation

We can visualize a CDP as a point on a plane, where the X axis is the collateral value (deposited ETH in USD), and the Y axis is the debt value (withdrawn DAI in USD).
Our goal is to always stay under the Liquidation (red) line.

The black line us is the insurance threshold line.
The insurance threshold indicates 


In the area between these lines (the Danger Area), our contract may act to move the point further from the line.
This can be done in one of the two ways:

1. move down and then left 
2. move left and then down

Let's call our CDP holder Alice.
Let's denote our contract as the Saver.

### Down then left

The Saver identifies a CDP in the Danger Area, it does the following:

1. transfer DAI to close (part of) Alice's debt
1. wipe these DAI and get ETH in the Maker contract
1. sell ETH

The drawback of this method is that the Saver has to have some capital (in form of DAI) upfront to partially repay the CDP.

### Left then down

Another way would be to:
1. take some ETH from the collateral
1. sell ETH for DAI (e.g., at Uniswap)
1. wipe the DAI in the Maker contract

The benefit is that no capital is required upfront.
The drawback is that one such "step" may not be enough to move out of the Danger Area.
In the CDP is close to liquidation, only a small amount of ETH can be withdrawn on step 1.
In this case, multiple steps are required to leave the Danger Area.
As a result, the transaction fees will be higher.


## How we built it

We created a contract to operate the CDP.
This contract helps partially repay the debt to increase collaterization ratio of any CDP that is close to liquidation.
This feature can be attached to any existing CDP and doesn't break existing integrations.

More technical details available [here](truffle/README.md).

## Challenges, Accomplishments, and Insights

The MakerDAO contracts architecture is pretty complicated ;) 
You should find someone who already knows the contracts before digging into it. 

Special thanks to Josh from MakerDAO who helped to understand that logic and many others who discussed this idea and current progress in CDP management. 

## What's next for DAI Insured

* Integrate the insurance mechanics in the MakerDAO itself.
This would allow the Saver to operate in a single step without requiring additional capital, bypassing the collaterization ratio requirements.

* One could integrate this logic into other lending protocols, including [Compound](https://app.compound.finance/) and [Multi-Collateral Dai](https://makerdao.com/da/whitepaper/).

* Implement ready to use bots that automatically discover insured CDPs, monitor them, and protect those close to liquidation. 

* DAI Insured is a simple enough protocol to be formally verified (Maker DAO contracts are formally verified).
This would allow DAI Insured to adhere to the security standards of the DAI ecosystem.
    * We should polish the code first and improve code coverage.
