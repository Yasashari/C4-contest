# Dos due to hardcode slippage during the market turbulence conditions. 

During market turbulence (market crash)  it's unpredictable the minimum output amounts when swapping. But here slippage is
hardcoded so eventually it makes dos during market crash conditions.

## Proof of Concept

          150                   uint256 toWithdraw = amount - queued; //1:1 between eth<>stEth
          151                      uint256 minAmount = toWithdraw - (toWithdraw * 250) / 10_000; //2.5%
          152                      uint256 obtainedEth = curveStEthPool.exchange(
          153                          1,
          154                          0,
          155                          toWithdraw,
          156                          minAmount
          157                      );


https://github.com/Tapioca-DAO/tapioca-yieldbox-strategies-audit/blob/master/contracts/lido/LidoEthStrategy.sol#L150C12-L156C26


         207                          uint256 minAmount = calcAmount - (calcAmount * 50) / 10_000; //0.5%
         208                          swapper.swap(swapData, minAmount, address(this), "");

https://github.com/Tapioca-DAO/tapioca-yieldbox-strategies-audit/blob/master/contracts/convex/ConvexTricryptoStrategy.sol#L207C1-L208C70

Here We cannot change the minAmount as desired so Dos is possible during the market crash condtions. 


## Tools Used
Vs code

## Recommended Mitigation Steps

Use minimum output amount or slipage as a function arguments. 


        






