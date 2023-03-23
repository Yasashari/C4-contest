# Always revert due to not defining inequality properly. 

# Proof of Concept

      392      if (poolLongTokenAmount < poolShortTokenAmount) {
      393                 uint256 diff = poolLongTokenAmount - poolShortTokenAmount;
   
      401      } else {
      402      uint256 diff = poolShortTokenAmount - poolLongTokenAmount;
   
   
https://github.com/0x00012345/gmx-synthetics/blob/8028cb8022b85174be861b311f1082b5b76239df/contracts/deposit/ExecuteDepositUtils.sol#L393

https://github.com/0x00012345/gmx-synthetics/blob/8028cb8022b85174be861b311f1082b5b76239df/contracts/deposit/ExecuteDepositUtils.sol#L402

Here diff is always negative(zero only if poolLongTokenAmount = poolShortTokenAmount). So it will revert the function.

Tools Used

Manual auditing 

# Recommended Mitigation Steps

diff should be declared in a other way. 

      393      uint256 diff = poolShortTokenAmount - poolLongTokenAmount ;
 
      402     uint256 diff =  poolLongTokenAmount - poolShortTokenAmount ;



