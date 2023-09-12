## Overflow is possible due to downcasting. 

what [_calculateForfeitedRewardDistribution()](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L1579) function does is distribute the forfeited Amount to the rest of the remaining stakers. There is a [division](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L1591C7-L1591C82) to calculate vestedRewardPerToken.Then finally its downcast to unit80 [here](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L1556C1-L1558C95). Issue is if the amountOfRecipientTokens is gonna be very small amount then its going to be a overflow due to downcasting to uint80. 
amountOfRecipientTokens can be a small value after slashing. Since stackers are unable to unstake so that remaining balance is in a [dust](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/pools/StakingPoolBase.sol#L478C3-L481C6). But slashers able to slash such that remaining balance is gonna be [dust](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/pools/OperatorStakingPool.sol#L326). 

## Proof of Concept
Operator One stack 10000 full Link tokens + 100 wei Link token.
Operator two stack 10000 full Link tokens.

Slasher will slash Operator one with 10000 Link token. So the Operator one remaining balance is now 100 wei.

Now Operator two unstack. He will be not able to unstack due to overflow as explained above.

Foundry POC.


[Here](https://github.com/code-423n4/2023-08-chainlink/blob/main/test/units/pools/OperatorStakingPool.t.sol#L2701) its added 100
wei to OPERATOR_STAKER_ONE. 

```solidity
 function setUp() public override {
    PriceFeedAlertsController_WithSlasherRole.setUp();
    changePrank(OPERATOR_STAKER_ONE);
    s_LINK.transferAndCall(address(s_operatorStakingPool), FEED_SLASHABLE_AMOUNT+100, '');
    changePrank(OPERATOR_STAKER_TWO);
    s_LINK.transferAndCall(address(s_operatorStakingPool), FEED_SLASHABLE_AMOUNT, '');
  }
```

Below mentioned test_OverflowDueToSlashing() test case same as [this](https://github.com/code-423n4/2023-08-chainlink/blob/main/test/units/pools/OperatorStakingPool.t.sol#L2756) with slight modification. Here its added unbond and unstacking of OPERATOR_STAKER_TWO. 




```solidity
   function test_OverflowDueToSlashing() public {
  
    address[] memory slashedOperators = new address[](1);
    slashedOperators[0]= OPERATOR_STAKER_ONE ;
   
    uint256 operatorPrincipalBefore = s_operatorStakingPool.getStakerPrincipal(OPERATOR_STAKER_ONE);
  // console.log("operatorPrincipalBefore", operatorPrincipalBefore);    

    changePrank(address(s_pfAlertsController));
    for (uint256 i; i < slashedOperators.length; ++i) {
      uint256 operatorPrincipal = s_operatorStakingPool.getStakerPrincipal(slashedOperators[i]);
  
      vm.expectEmit(true, true, true, true, address(s_operatorStakingPool));
      emit Slashed(
        slashedOperators[i], FEED_SLASHABLE_AMOUNT*2, operatorPrincipal - FEED_SLASHABLE_AMOUNT*2
      );
    }

    
    s_operatorStakingPool.slashAndReward(
      slashedOperators, COMMUNITY_STAKER_ONE, FEED_SLASHABLE_AMOUNT*2, ALERTER_REWARD_AMOUNT
    );
    assertEq(
      s_operatorStakingPool.getStakerPrincipal(OPERATOR_STAKER_ONE),
      operatorPrincipalBefore - FEED_SLASHABLE_AMOUNT*2
    );

    changePrank(OPERATOR_STAKER_TWO);
   
    s_operatorStakingPool.unbond();
    skip(UNBONDING_PERIOD);
    s_operatorStakingPool.unstake(OPERATOR_MIN_PRINCIPAL, false);

  }
```

Console log Used on these places in RewardVault.sol contract.


```solidity
  if (vestedRewardPerToken != 0) {
      if (toOperatorPool) {
        console.log("vestedRewardPerToken",vestedRewardPerToken);
        s_rewardBuckets.operatorBase.vestedRewardPerToken += vestedRewardPerToken.toUint80();
      } else {
```
https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L1554C1-L1557C15



Terminal is as given below.

![yasas1](https://github.com/Yasashari/C4-contest/assets/118436384/72db9bee-4df0-4227-8c95-e3aa41fe05cc)



## Tools Used
Foundry & Manual Auditing


## Recommended Mitigation Steps

Downcasting is not safe [here](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L1556).
The maximum value would be [vestedRewardPerToken](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L1556) is Total Link supply x e18 / 1  . So use casting appropriately.







