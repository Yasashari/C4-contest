## If user unsake very less amount, He is penalized full forfeitedRewardAmount  whereas user unstake more tokens he is penalized less forfeitedRewardAmount tokens.

What it should be is if user unstake less tokens he should penalized less forfeitedRewardAmount & vice verisa. But here it's not
happened during some token amount period (range) of unstacking. 

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

Lets think user unstake 1wei of Link tokens which satisfy this inequality 
forfeitedRewardAmountTimesUnstakedAmount < oldPrincipal
Then he is gonna forfeit the full forfeit amount(fullForfeitedRewardAmount). (line 18)

Whereas, If user unstake forfeitedRewardAmountTimesUnstakedAmount = oldPrincipal , he is forfeited only 1 wei of link token.
(line 20)

Foundry poc

In order to run this test its needed to copy & paste below functions in to the [RewardVault.t.sol](https://github.com/code-423n4/2023-08-chainlink/blob/main/test/units/rewards/RewardVault.t.sol#L1085) in to (around) line 1085.
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
      console.log("forfeitedRewardAmount1",forfeitedRewardAmount);
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

  forfeitedRewardAmount1 55726166902404526157
  
  oldPrincipal1 100000000000000000001
  
  forfeitedRewardAmount1 55726166902404526157

  
Here user unstaked 2 wei of Link tokens . His forfeited amount = 1 wei. 

```solidity
function test_forfeitedMoreFromLessUnstaker() public {
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

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake( 2 , false );
   
}
```
Logs:

  forfeitedRewardAmountTimesUnstakedAmount2 111452333804809052314
  
  oldPrincipal2 100000000000000000001
  
  forfeitedRewardAmount2 1

  

## Tools Used
Foundry & Manual auditing

## Recommended Mitigation Steps

      forfeitedRewardAmountTimesUnstakedAmount < oldPrincipal
      
Check the above [inequality](https://github.com/code-423n4/2023-08-chainlink/blob/main/src/rewards/RewardVault.sol#L935) & if it's satisfied, revert the unstacking transaction. 




















