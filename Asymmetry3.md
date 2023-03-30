# Not enough liquidity on rETH/WETH pair so rebalance may be reverted 

when rebalancing the protocol it withdraw all the derivatives from respective contracts & deposit Eth acccording to the newly assigened weights.
If deposit Eth amout is more than 5000 for the Reth.sol contract it will swap Eth using Uniswap rEth/WETH pool , since there is no liquidity for
that transaction (right now) then reverting . So rebalance cannot not perfomed due to lack of liquidty on uniswap rETH/WETH pair.

## Proof of Concept

 Rebalancing invoke the deposit function in the Reth.sol as mark below.

![image](https://user-images.githubusercontent.com/118436384/228853405-e80bc50f-bac3-4e98-87c4-9c17c8cd93fe.png)

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L152

This check poolCanDeposit return value meaning if 

![image](https://user-images.githubusercontent.com/118436384/228854461-a19ae48d-7ba6-40af-8510-cf360371fd9f.png)



![image](https://user-images.githubusercontent.com/118436384/228856402-dc5d1d58-0937-45b6-ad28-7cabcc5fb4e4.png)








