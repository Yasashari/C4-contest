## If the user unsakes a very less amount, He is penalized full forfeitedRewardAmount  whereas user unstakes more tokens he is penalized less forfeitedRewardAmount tokens.

What it should be is if the user unstackes less tokens he should be penalized less forfeitedRewardAmount & more token
unstacking more forfeitedRewardAmount should be penalized. But here it has not happened during some token amount period (range)
of unstacking. (Meaning less token unstacking more forfeitedRewardAmount going to be penalized ).

## Proof of Concept

```solidity
    uint256 forfeitedRewardAmount;

    uint256 forfeitedRewardAmountTimesUnstakedAmount = fullForfeitedRewardAmount * unstakedAmount;

    // This handles the edge case when a staker has earned too little rewards and
    // unstakes a very small amount.  In this scenario the reward vault will
    // forfeit the full amount of unclaimable rewards instead of calculating
    // the proportion of the unclaimable rewards that should be forfeited.
    if (forfeitedRewardAmountTimesUnstakedAmount < oldPrincipal) {
      forfeitedRewardAmount = fullForfeitedRewardAmount;
    } else {
      forfeitedRewardAmount = forfeitedRewardAmountTimesUnstakedAmount / oldPrincipal;
    }

```
https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L927C5-L940C1

Let's think user unstake 1wei of Link tokens which satisfies this inequality 
forfeitedRewardAmountTimesUnstakedAmount < oldPrincipal
Then he is gonna forfeit the full forfeit amount(fullForfeitedRewardAmount). (line 18)

Whereas, If user unstake forfeitedRewardAmountTimesUnstakedAmount = oldPrincipal , he is forfeited only 1 wei of link token.
(line 20)

Foundry poc

In order to run this test it's needed to copy & paste the below functions into the [RewardVault.t.sol](https://github.com/code-423n4/2023-08-chainlink/blob/main/test/units/rewards/RewardVault.t.sol#L1085) in to (around) line 1085.
Here user unstake only 1wei of Link tokens. His forfeited amount = 55.726166902404526157 Link tokens

```solidity
function test_forfeitedMoreFromLessUnstaker() public {
   changePrank(REWARDER);

// Rewarder added REWARD_AMOUNT & emission rate is EMISSION_RATE/2.

    s_rewardVault.addReward(address(0), REWARD_AMOUNT, EMISSION_RATE/2);

// COMMUNITY_STAKER_ONE staked 100Link tokens + 1 wei .

    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL*100+1,
      abi.encode(s_communityStakerOneProof)
    );

// COMMUNITY_STAKER_TWO staked 10000 Link tokens.
     
     changePrank(COMMUNITY_STAKER_TWO);

     s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL*10000,
      abi.encode(s_communityStakerTwoProof)
    );

    changePrank(COMMUNITY_STAKER_ONE);
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake( 1 , false );
   
}
```
console log as below. 

```solidity
  if (forfeitedRewardAmountTimesUnstakedAmount < oldPrincipal) {
      forfeitedRewardAmount = fullForfeitedRewardAmount;
      console.log("forfeitedRewardAmountTimesUnstakedAmount1",forfeitedRewardAmountTimesUnstakedAmount);
      console.log("oldPrincipal1", oldPrincipal);
      console.log("forfeitedRewardAmount1",forfeitedRewardAmount);
    } else {
      forfeitedRewardAmount = forfeitedRewardAmountTimesUnstakedAmount / oldPrincipal;
      console.log("forfeitedRewardAmountTimesUnstakedAmount2", forfeitedRewardAmountTimesUnstakedAmount);
      console.log("oldPrincipal2", oldPrincipal);
      console.log("forfeitedRewardAmount2",forfeitedRewardAmount);
    }
```
https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L935C1-L940C1

in this case terminal is as shown below.

Logs:

  forfeitedRewardAmountTimesUnstakedAmount1 55726166902404526157
  
  oldPrincipal1 100000000000000000001
  
  forfeitedRewardAmount1 55726166902404526157

  
Here user unstaked 2 wei of Link tokens . His forfeited amount = 1 wei. (This value is correct). 

```solidity
function test_CorrectCalculationOnfeitedAmountForMoreUnstaking() public {
   changePrank(REWARDER);
    s_rewardVault.addReward(address(0), REWARD_AMOUNT, EMISSION_RATE/2);

    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL*100+1,
      abi.encode(s_communityStakerOneProof)
    );

     
     changePrank(COMMUNITY_STAKER_TWO);

     s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL*10000,
      abi.encode(s_communityStakerTwoProof)
    );

    changePrank(COMMUNITY_STAKER_ONE);
    s_communityStakingPool.unbond();

// Here unstake 2 wei make sure to correct amount is forfeited.

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake( 2 , false );
   
}
```
Logs:

  forfeitedRewardAmountTimesUnstakedAmount2 111452333804809052314
  
  oldPrincipal2 100000000000000000001
  
  forfeitedRewardAmount2 1

  
This kind of full forfeitedRewardAmount can be penalized with range of values the user unstakes. For that this inequality should
be satisfied.

forfeitedRewardAmountTimesUnstakedAmount < oldPrincipal.

Here forfeitedRewardAmountTimesUnstakedAmount = fullForfeitedRewardAmount * unstakedAmount

This inequality can be satisfied with less amount of unstakedAmount with high fullForfeitedRewardAmount. 

Let's think there is a less emission rate & less unbonding period, then there is a range of values for unstakedAmount which satisfies the above inequality. (Since With less emission rate & less unbonding period, fullForfeitedRewardAmount going to be
a smaller amount. So unstakedAmount can get a range of values that satisfy the above inequality ).




## Tools Used
Foundry & Manual auditing

## Recommended Mitigation Steps

      forfeitedRewardAmountTimesUnstakedAmount < oldPrincipal
      
Check the above [inequality](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L935) & if it's satisfied, revert the unstacking transaction. 




















