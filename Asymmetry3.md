# Not enough liquidity on rETH/WETH pair so rebalance may be reverted 

Rebalancing the protocol it withdraw all the derivatives from respective contracts & deposit Eth acccording to the newly assigened weights.
If deposit Eth amout is more than 5000 for the Reth.sol contract it will swap Eth using Uniswap rEth/WETH pool , since there is no liquidity
for that transaction (right now) then reverting . So rebalance cannot not perfomed due to lack of liquidty on uniswap rETH/WETH pair.

## Proof of Concept

 Rebalancing invoke the deposit function in the Reth.sol as mark below.

![image](https://user-images.githubusercontent.com/118436384/228853405-e80bc50f-bac3-4e98-87c4-9c17c8cd93fe.png)

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L152



![image](https://user-images.githubusercontent.com/118436384/228854461-a19ae48d-7ba6-40af-8510-cf360371fd9f.png)


Here check the deposit amount is greater than the getMinimumDeposit and smaller than then getMaximumDepositPoolSize. If deposit amount is >
5000 Eth then it swap will be done via Uniswap pool.


![image](https://user-images.githubusercontent.com/118436384/228857192-47a89972-aabc-4680-995e-f2ddfa7dad40.png)

When the time of writing the POC there is no enough liquidity on rEth/WETH pool. You can see here.

https://etherscan.io/address/0xf0e02cf61b31260fd5ae527d58be16312bda59b1#readContract

![image](https://user-images.githubusercontent.com/118436384/228860650-9634ca46-fc46-425f-a90f-0d53ff8ee52b.png)


So its unable to perfom the rebalance with current condition.

## Tools Used
Manual Auditing

## Recommended Mitigation Steps













