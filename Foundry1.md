```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ERC677ReceiverInterface} from
  '@chainlink/contracts/src/v0.8/interfaces/ERC677ReceiverInterface.sol';
import {LinkTokenInterface} from '@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol';
import {SafeCast} from '@openzeppelin/contracts/utils/math/SafeCast.sol';
import {IERC165} from '@openzeppelin/contracts/interfaces/IERC165.sol';
import {FixedPointMathLib} from '@solmate/utils/FixedPointMathLib.sol';
import {BaseTest} from '../../BaseTest.t.sol';
import {CommunityStakingPool} from '../../../src/pools/CommunityStakingPool.sol';
import {IAccessControlDefaultAdminRulesTest} from
  '../../interfaces/IAccessControlDefaultAdminRulesTest.t.sol';
import {IMigratable} from '../../../src/interfaces/IMigratable.sol';
import {IPausableTest} from '../../interfaces/IPausableTest.t.sol';
import {
  IRewardVault_GetMultiplier,
  IRewardVault_SetDelegationRateDenominator,
  IRewardVault_SetMultiplierDuration
} from '../../interfaces/IRewardVaultTest.t.sol';
import {IRewardVault} from '../../../src/interfaces/IRewardVault.sol';
import {OperatorStakingPool} from '../../../src/pools/OperatorStakingPool.sol';
import {RewardVault} from '../../../src/rewards/RewardVault.sol';
import {
  RewardVault_ConfigurablePoolSizes_DelegationDenominatorNotZero,
  RewardVault_DelegationDenominatorIsZero,
  RewardVault_WithoutStakersAndTimePassed,
  RewardVault_WithStakersAndTimeDidNotPass,
  RewardVault_WithStakersAndTimePassed,
  RewardVault_WithUpgradedVaultDeployedButNotMigrated
} from '../../base-scenarios/RewardVaultScenarios.t.sol';

// Use calculations based on amounts from
// https://www.notion.so/chainlink/Changing-Dynamic-Delegation-Rate-f80d702fd6e44b3282ca20e4c0f7e0b0
// this is different algorithm than the prod code, so we are correctly testing the algorithm
function getExpectedEmissionRates(
  uint256 stakeAmount,
  uint256 emissionRate,
  uint256 operatorDenominator,
  uint256 newDelegationRateDenominator
) pure returns (uint256, uint256) {
  uint256 rewardDuration = emissionRate == 0 ? 0 : stakeAmount / emissionRate;
  uint256 totalCommunityRewards = stakeAmount - (stakeAmount / operatorDenominator);

  uint256 delegatedRewards =
    newDelegationRateDenominator == 0 ? 0 : (totalCommunityRewards / newDelegationRateDenominator);
  uint256 expectedCommunityRewards = totalCommunityRewards - delegatedRewards;
  uint256 expectedCommunityEmissionRate =
    emissionRate == 0 ? 0 : expectedCommunityRewards / rewardDuration;
  uint256 expectedDelegatedEmissionRate = emissionRate == 0 ? 0 : delegatedRewards / rewardDuration;
  return (expectedDelegatedEmissionRate, expectedCommunityEmissionRate);
}

contract RewardVault_GetMultiplier is
  IRewardVault_GetMultiplier,
  RewardVault_WithoutStakersAndTimePassed
{
  function test_ReturnsZeroWhenStakerNotStaked() public {
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }

  function test_ReturnsZeroWhenStakerStakedAndNoTimePassed() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }

  function test_ReturnsCorrectValueWhenStakerStakedAndTimePassed() public {
    changePrank(COMMUNITY_STAKER_ONE);
    // first stake
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    // time passed
    uint256 elapsedTime = 100;
    vm.warp(block.timestamp + elapsedTime);

    uint256 multiplierDuration = s_rewardVault.getMultiplierDuration();
    uint256 expectedMultiplier = elapsedTime * FixedPointMathLib.WAD / multiplierDuration;
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), expectedMultiplier);
  }

  function test_ReducesMultiplierWhenStakerStakedAgain() public {
    changePrank(COMMUNITY_STAKER_ONE);

    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    // time passed
    uint256 elapsedTime = 100;
    vm.warp(block.timestamp + elapsedTime);

    // second stake
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }

  function test_ReturnsMaxValueWhenStakerStakedForFullMultiplierDuration() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    vm.warp(block.timestamp + INITIAL_MULTIPLIER_DURATION);

    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), MAX_MULTIPLIER);
  }

  function test_DoesNotChangeWhenStakerClaimsReward() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    vm.warp(block.timestamp + INITIAL_MULTIPLIER_DURATION);

    s_rewardVault.claimReward();

    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), MAX_MULTIPLIER);
  }

  function test_ReturnsZeroWhenStakerFullyUnstaked() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(
      s_communityStakingPool.getStakerPrincipal(COMMUNITY_STAKER_ONE), false
    );
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }
//Start my code
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
//end
  function test_DoesNotGrowAfterStakerFullyUnstaked() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(
      s_communityStakingPool.getStakerPrincipal(COMMUNITY_STAKER_ONE), false
    );

    skip(10 days);
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }

  function test_ReturnsZeroWhenStakerStakedAgainAfterFullyUnstaked() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(
      s_communityStakingPool.getStakerPrincipal(COMMUNITY_STAKER_ONE), false
    );

    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }

  function test_ReturnsCorrectValueWhenStakerStakedAgainAfterFullyUnstakedAndTimePassed() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(
      s_communityStakingPool.getStakerPrincipal(COMMUNITY_STAKER_ONE), false
    );

    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);

    // grows linearly as if it started from 0 at the time of staking
    skip(INITIAL_MULTIPLIER_DURATION / 2);
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), MAX_MULTIPLIER / 2);
  }

  function test_ReturnsZeroWhenStakerPartiallyUnstaked() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL * 2,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(COMMUNITY_MIN_PRINCIPAL, false);
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }

  function test_DoesGrowAfterStakerPartiallyUnstaked() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL * 2,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(COMMUNITY_MIN_PRINCIPAL, false);

    uint256 timeAfterUnstake = 90 days;
    uint256 expectedMultiplier = _calculateStakerMultiplier(
      block.timestamp, block.timestamp + timeAfterUnstake, INITIAL_MULTIPLIER_DURATION
    );

    skip(timeAfterUnstake);

    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), expectedMultiplier);
  }

  function test_ReturnsCorrectValueWhenStakerStakedAgainAfterPartiallyUnstaked() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL * 2,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(COMMUNITY_MIN_PRINCIPAL, false);

    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), 0);
  }

  function test_ReturnsCorrectValueWhenStakerStakedAgainAfterPartiallyUnstakedAndTimePassed()
    public
  {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL * 2,
      abi.encode(s_communityStakerOneProof)
    );
    s_communityStakingPool.unbond();

    skip(UNBONDING_PERIOD);
    s_communityStakingPool.unstake(COMMUNITY_MIN_PRINCIPAL, false);

    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    // grows linearly as if it started from 0 at the time of staking
    skip(INITIAL_MULTIPLIER_DURATION / 2);
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), MAX_MULTIPLIER / 2);
  }

  function test_ReturnsMaxValueWhenMultiplierDurationIsChangedToZero() public {
    changePrank(COMMUNITY_STAKER_ONE);
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    assertLt(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), MAX_MULTIPLIER);

    changePrank(OWNER);
    s_rewardVault.setMultiplierDuration(0);

    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), MAX_MULTIPLIER);
  }

  function test_ReturnsCorrectValueWhenMultiplierDurationIsIncreased() public {
    changePrank(COMMUNITY_STAKER_ONE);
    // first stake
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    // time passed
    uint256 elapsedTime = 100;
    vm.warp(block.timestamp + elapsedTime);

    uint256 multiplierDuration = s_rewardVault.getMultiplierDuration();
    uint256 expectedMultiplierBeforeChange =
      elapsedTime * FixedPointMathLib.WAD / multiplierDuration;

    // multiplier duration doubled
    changePrank(OWNER);
    s_rewardVault.setMultiplierDuration(INITIAL_MULTIPLIER_DURATION * 2);

    // multiplier halved
    assertEq(s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE), expectedMultiplierBeforeChange / 2);
  }

  function test_ReturnsCorrectValueWhenMultiplierDurationIsDecreased() public {
    changePrank(COMMUNITY_STAKER_ONE);
    // first stake
    s_LINK.transferAndCall(
      address(s_communityStakingPool),
      COMMUNITY_MIN_PRINCIPAL,
      abi.encode(s_communityStakerOneProof)
    );

    // time passed
    uint256 elapsedTime = 100;
    vm.warp(block.timestamp + elapsedTime);

    uint256 multiplierDuration = s_rewardVault.getMultiplierDuration();

    // multiplier duration halved
    changePrank(OWNER);
    s_rewardVault.setMultiplierDuration(multiplierDuration / 2);

    // multiplier doubled
    assertEq(
      s_rewardVault.getMultiplier(COMMUNITY_STAKER_ONE),
      elapsedTime * FixedPointMathLib.WAD * 2 / multiplierDuration
    );
  }
}

```
















