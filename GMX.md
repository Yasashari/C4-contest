BPZ

High


## Always revert due to not defining inequality properly. 

## Summary

DOS in getAdjustedLongAndShortTokenAmounts() function due to not setting inequality properly. 


## Vulnerability Detail

getAdjustedLongAndShortTokenAmounts() function is always reverted . Reason is diff is always negative with current implementation. 
(diff is zero only if poolLongTokenAmount = poolShortTokenAmount). So it will revert the function.

## Code Snippet

      392      if (poolLongTokenAmount < poolShortTokenAmount) {
      393                 uint256 diff = poolLongTokenAmount - poolShortTokenAmount;
   
      401      } else {
      402      uint256 diff = poolShortTokenAmount - poolLongTokenAmount;
   
   
https://github.com/0x00012345/gmx-synthetics/blob/8028cb8022b85174be861b311f1082b5b76239df/contracts/deposit/ExecuteDepositUtils.sol#L393

https://github.com/0x00012345/gmx-synthetics/blob/8028cb8022b85174be861b311f1082b5b76239df/contracts/deposit/ExecuteDepositUtils.sol#L402

## Impact
getAdjustedLongAndShortTokenAmounts() function is always reverted . So it will not return adjustedLongTokenAmount and adjustedShortTokenAmount
as expected. Becaouse of this market will not able to receive additional deposits when the respective market.shortToken = market.longToken,
for example the WETH/WETH market.

Here is the impact step by steps :

User calls createDeposit with a market where longToken = shortToken (we can use WETH for example) as a param for the deposit in the
ExchangeRouter contract

![image](https://user-images.githubusercontent.com/118436384/227443003-c926ea16-c32c-4dc6-8645-2a5fa9801081.png)



## Tools Used

Manual auditing 

## Recommended Mitigation Steps

diff should be declared in a other way. 

      393      uint256 diff = poolShortTokenAmount - poolLongTokenAmount ;
 
      402     uint256 diff =  poolLongTokenAmount - poolShortTokenAmount ;



