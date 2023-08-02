# computeClosingFactor function does not comply with the relevant docs.


```For example, if a user borrowed 8000 USDO with $10,000 in ETH in a 75% LTV market, the liquidator will only be allowed to liquidate $500 of user collateral, therefore the amount that can be liquidated is $500 + 3% (of the borrowed amount) which in this case equals $800.```

But here actual liquidation amount is different with 800$. 


## Proof of Concept



                 function computeClosingFactor(
                      uint256 borrowPart,
                      uint256 collateralPartInAsset,
                      uint256 borrowPartDecimals,
                      uint256 collateralPartDecimals,
                      uint256 ratesPrecision
                  ) public view returns (uint256) {
                      uint256 borrowPartScaled = borrowPart;
                      if (borrowPartDecimals > 18) {
                          borrowPartScaled = borrowPart / (10 ** (borrowPartDecimals - 18));
                      }
                      if (borrowPartDecimals < 18) {
                          borrowPartScaled = borrowPart * (10 ** (18 - borrowPartDecimals));
                      }
              
                      uint256 collateralPartInAssetScaled = collateralPartInAsset;
                      if (collateralPartDecimals > 18) {
                          collateralPartInAssetScaled =
                              collateralPartInAsset /
                              (10 ** (collateralPartDecimals - 18));
                      }
                      if (collateralPartDecimals < 18) {
                          collateralPartInAssetScaled =
                              collateralPartInAsset *
                              (10 ** (18 - collateralPartDecimals));
                      }
              
                      uint256 liquidationStartsAt = (collateralPartInAssetScaled *
                          collateralizationRate) / (10 ** ratesPrecision);
                      if (borrowPartScaled < liquidationStartsAt) return 0;
              
                      uint256 numerator = borrowPartScaled -
                          ((collateralizationRate * collateralPartInAssetScaled) /
                              (10 ** ratesPrecision));
                      uint256 denominator = ((10 ** ratesPrecision) -
                          (collateralizationRate *
                              ((10 ** ratesPrecision) + liquidationMultiplier)) /
                          (10 ** ratesPrecision)) * (10 ** (18 - ratesPrecision));
              
                      uint256 x = (numerator * 1e18) / denominator;
                      return x;
                  }


https://github.com/Tapioca-DAO/tapioca-bar-audit/blob/2286f80f928f41c8bc189d0657d74ba83286c668/contracts/markets/Market.sol#L256C2-L298C1

Considering the above-mentioned case scenario, the liquidating amount is 800$ if user borrowed 8000$ USDO against his 10000$ ETH
deposited value. But if it's checked with computeClosingFactor function it returns 3125$ needs to be liquidated. It's way more
than with docs. 

  function computeClosingFactor(
                      uint256 borrowPart ( 0.8e18) ,
                      uint256 collateralPartInAsset ( e18),
                      uint256 borrowPartDecimals (18),
                      uint256 collateralPartDecimals (18),
                      uint256 ratesPrecision (5)
                  ) 
                      = 0.3125e18 

Also,
``` A liquidator can only liquidate all collateral contained in a CDP if the LTV is greater than 100% due to the danger to Tapioca's system solvency that a CDP of above 100% LTV possesses. Otherwise, a liquidator can only liquidate the amount of collateral necessary to make a CDP solvent, also including the liquidation penalty bonus. ```

Above mentioned liquidator is able to liquidate all the collateral if LTV value is greater than 100%.

But it also does not comply with the computeClosingFactor function. If LTV is 91% at that point liquidator able to liquidate all
the collateral. 

## Tools Used
Vs code

## Recommended Mitigation Steps
It's needed to rewrite the computeClosingFactor function in order to achieve the doc's target values.  






                  













