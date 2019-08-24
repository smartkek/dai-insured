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
* [InstaDapp Bridge](https://instadapp.io). The InstaDApp liquidity contract "pays back your CDP debt and withdraws ETH that then gets moved to Compound. The liquidity contract then draws an equivalent order to compensate the previously paid debt". This also requires manual user action.
* others?


## What it does

TODO: come up with a single-word term for "partially repay the CDP to move further from liquidations threshold". For now, just use "repay".

DAI Insured enables a CDP holder to outsource the monitoring and (partially) relaying CDPs to avoid liquidation.
This outsourcing is performed trustlessly and increases market efficiency by enabling markets for CDP monitoring.

### Two ways to avoid liquidation

TODO: draw the graph (or simply take a photo of the hand-drawn one)

We can visualize a CDP as a point on a plane, where the X axis is the collateral value (deposited ETH in USD), and the Y axis is the debt value (withdrawn DAI in USD).
Line A is the liquidation threshold.
Our goal is to always stay under this line.
Line B is the threshold line.
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

The drawback of this method is that the Saver has to have some capital (in form of DAI) upfront to partially relay the CDP.

### Left then down

Another way would be to:
1. take some ETH from the collateral
1. sell ETH for DAI (e.g., at Uniswap)
1. wipe the DAI in the Maker contract

The benefit is that n capital is required upfront.
The drawback is that one such "step" may not be enough to move out of the Danger Area.
In the CDP is close to liquidation, only a small amount of ETH can be withdrawn on step 1.
In this case, multiple steps are required to leave the Danger Area.
As a result, the transaction fees will be higher.



### Trustless outsourcing

With DAI Insure, a user may be sure that their CDP won't be liquidated.
TODO: fee structure.
TODO: economic analysis (ideally, "XXX dollars could have been saved").



## How we built it

### Interacting with MakerDAO

We created a contract to operate the CDP so that the collaterization ration can be adjusted.

## Challenges we ran into

The MakerDAO contract structure is pretty complicated ;)

## Accomplishments that we're proud of

## What we learned

## What's next for DAI Insured

Integrate the "insurance mechanics in the MakerDAO itself.
This would allow the Saver to operate in a single step without requiring additional capital, temporarily going above the liquidation ration (within one transaction).

The user might want to be sure that the Saver would performed as advertised.
We may introduce penalties in addition to rewards to motivate the required behavior.
Potential Savers could put up stake (in ETH, DAI, or tokens) and accumulate reputation.
Users would be sure that the Saver they trust to protect their CDP is highly likely to actually do it.
