YasX

medium


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
as expected. 

## Tools Used

Manual auditing 

## Recommended Mitigation Steps

diff should be declared in a other way. 

      393      uint256 diff = poolShortTokenAmount - poolLongTokenAmount ;
 
      402     uint256 diff =  poolLongTokenAmount - poolShortTokenAmount ;



