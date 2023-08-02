# Liquidation swap having 2 minimum amounts to satisfy in order to swap successfully. ( Possible dos during the market crash )

When liquidator liquidates user during the market crash, liquidator is able to set the minAssetMount as he needs. But He is
unable to set a minAssetMount that is less than the borrowShare. In order to swap successfully minAssetMount > borrowShare during
the market crash. ( Since during the market crash there is possible to hit minAssetMount when swapping. But minAssetMount cannot
lower than the borrowShare so it could be unable to swap during the market crash ). Eventually, protocol ended up with more band
debit compared with less bad debt. 


## Proof of Concept

         622           (uint256 feeShare, uint256 callerShare) = _extractLiquidationFees(
         623               returnedShare,
         624               borrowShare,
         625               callerReward
         626           );

https://github.com/Tapioca-DAO/tapioca-bar-audit/blob/2286f80f928f41c8bc189d0657d74ba83286c668/contracts/markets/bigBang/BigBang.sol#L622C4-L626C11

Here returnedShare  always should be greater than  borrowShare.

If not here it is underflow & dos.


        644             uint256 extraShare = returnedShare - borrowShare;

https://github.com/Tapioca-DAO/tapioca-bar-audit/blob/2286f80f928f41c8bc189d0657d74ba83286c668/contracts/markets/bigBang/BigBang.sol#L644

i.e. this swap has 2 minimun output amounts such that liquidator is unable to set minAssetMount that is less than the
borrowShare during the market crash.

## Tools Used
Vs code

## Recommended Mitigation Steps
There should be a onlyowner function to liquidate users during market crash. If not liquidator set the minAssetMount as
he desired and sandwich the liquidation swap. 



        












