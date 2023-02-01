## Floating and Outdated Pragma
Use debugged complier version . Also use more recent compiler version.

Affected Source Code Total instances : 15

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/Factory.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/Lendgine.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/LiquidityManager.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/LendgineRouter.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/ImmutableState.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/JumpRate.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/Payment.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/SwapHelper.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/Pair.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/libraries/PositionMath.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/libraries/Balance.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/libraries/SafeCast.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/libraries/LendgineAddress.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/libraries/Position.sol#L2

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/UniswapV2/libraries/UniswapV2Library.sol#L1


## State variables should be decleared before events (Order of Layout)

Total instances : 1

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/LendgineRouter.sol#L43

For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#order-of-layout)
    

## Internal and private functions should have an underscore prefix with mixedCase(Naming convention)

Affected Source Code
Total instances : 14

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/JumpRate.sol#L40

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/Payment.sol#L52

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/SwapHelper.sol#L69

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/Pair.sol#L70

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/Pair.sol#L93

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/libraries/PositionMath.sol#L12

https://github.com/code-423n4/2023-01-numoen/blob/main/src/libraries/Balance.sol#L12

https://github.com/code-423n4/2023-01-numoen/blob/main/src/libraries/SafeCast.sol#L8

https://github.com/code-423n4/2023-01-numoen/blob/main/src/libraries/SafeCast.sol#L15

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/libraries/LendgineAddress.sol#L9

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/libraries/Position.sol#L38

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/libraries/Position.sol#L73

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/libraries/Position.sol#L86

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/UniswapV2/libraries/UniswapV2Library.sol#L10

https://github.com/code-423n4/2023-01-numoen/blob/main/src/periphery/UniswapV2/libraries/UniswapV2Library.sol#L17


 For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#function-names)
    2. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)
    

## Significant roundoff error in invariant() function

When calculating scale0 and scale1 there is a significant roundoff error due to initial division (division by - uint256 liquidity).
        
        56  FullMath.mulDiv(amount0, 1e18, liquidity)

#### Proof of Concept

        53  function invariant(uint256 amount0, uint256 amount1, uint256 liquidity) public view override returns (bool) {
        54  if (liquidity == 0) return (amount0 == 0 && amount1 == 0);

        56  uint256 scale0 = FullMath.mulDiv(amount0, 1e18, liquidity) * token0Scale;
        57  uint256 scale1 = FullMath.mulDiv(amount1, 1e18, liquidity) * token1Scale;

        59  if (scale1 > 2 * upperBound) revert InvariantError();

        61  uint256 a = scale0 * 1e18;
        62  uint256 b = scale1 * upperBound;
        63  uint256 c = (scale1 * scale1) / 4;
        64  uint256 d = upperBound * upperBound;

        66  return a + b >= c + d;
        67  }


https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/Pair.sol#56

https://github.com/code-423n4/2023-01-numoen/blob/main/src/core/Pair.sol#57

This FullMath.mulDiv(amount0, 1e18, liquidity) roundoff value again multiplied by 3 times when calculating a, b, c, d . 
Thats mean if consider calculating a


        a = FullMath.mulDiv(amount0, 1e18, liquidity)*token0Scale*scale0 * 1e18 
        
This cause even worse because roundoff value multiply by another 3 factors so finally its ended up with significant different value which it
should be. 

## Tools Used
Vs code

## Recommended Mitigation Steps
Perform all the multiplication first and divide eventually. 




    
    
    
    
    
    
    



