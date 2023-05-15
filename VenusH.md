# Hardcoded deciamal places caused incorrect usdValue for poolBadDebt

When calculating the poolBadDebt in terms of USD value , first take the marketBadDebt in terms of underlying token then it is
multiply by the corrosponding price finnaly its divided by the corrospoinding decimal places. But here it has been divided by the 
1e18. 

## Proof of Concept

    389   for (uint256 i; i < marketsCount; ++i) {
    390        uint256 marketBadDebt = vTokens[i].badDebt();
    391
    392        priceOracle.updatePrice(address(vTokens[i]));
    393        uint256 usdValue = (priceOracle.getUnderlyingPrice(address(vTokens[i])) * marketBadDebt) / 1e18;
    394
    395        poolBadDebt = poolBadDebt + usdValue;
    396        auction.markets[i] = vTokens[i];
    397        auction.marketDebt[vTokens[i]] = marketBadDebt;
    398        marketsDebt[i] = marketBadDebt;
    399    }

https://github.com/code-423n4/2023-05-venus/blob/main/contracts/Shortfall/Shortfall.sol#L393
    
If we consider the WBTC here 

Consider the current price of WBTC = 30000 USD (UnderlyingPrice) 

badDebt = 2 WBTC token = 2 x 10^8 (Decimals of WBTC = 10 ^ 8)

So usdValue =  30000 x 2 x 10^ 8 / 1e18 

This value round off to zero.

But the correct value should be = 30000 x 2 x 10^ 8 / 10^ 8 = 60000 USD

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

It should be divided by the corrosponding decimals for each underlying tokens.

      392      priceOracle.updatePrice(address(vTokens[i]));
      ++       IERC20Upgradeable erc20 = IERC20Upgradeable(address(vTokens[i].underlying()));
      393      uint256 usdValue = (priceOracle.getUnderlyingPrice(address(vTokens[i])) * marketBadDebt) / erc20.decimals() ;



























