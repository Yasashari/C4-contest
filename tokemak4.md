## Summary
User A who stake some period getting same reward as User B who front run topoffRewards and stake to end date(withdrawal date)
of UserA. So it's unfair the user who stake a longer duration. Here front run opportunity is there,  So better not to stake longer duration but front run the topoffRewards and stake. 

## Vulnerability Detail
When calculating [points](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/staking/GPToke.sol#L195) in [previewPoints](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/staking/GPToke.sol#L183C2-L196C6) function, points is calculated regardless of the time they staking but
only considering the duration & amount of staking. So points would be the same if two users stake same amounts with same withdrawal timestamp but with different times of stacking. This amount is minted to stacker & this amount acts as the final
proportion method to divide the topoffRewards. So this minted amount is not dependent on the time of the stacking. So it's unfair the users who stake longer periods.

## Impact
It's unfair to the users who stake longer periods. Since front runner is able to get the same proportion of rewards, not staking the whole period but front running the topoffRewards and stake. 

## Code Snippet

Here its attached Foundry-POC.  test_StakingRewards_MultiUser() is the test that considers here. All the required comments are included in relevant places. 

Here User1 deposit 1WETH as well as User2 deposit 1WETH. (same amount) . User1 duration 12 months whereas user2 duration 11
month. Here reward is 10WETH. But User1 and User2 is clamied as nearly as same amounts. (5WETH for each ). 


```solidity
// solhint-disable no-console, not-rely-on-time, func-name-mixedcase
// SPDX-License-Identifier: UNLICENSED
// Copyright (c) 2023 Tokemak Foundation. All rights reserved.
pragma solidity 0.8.17;

import { IGPToke, GPToke, BaseTest } from "test/BaseTest.t.sol";
import { WETH_MAINNET } from "test/utils/Addresses.sol";

contract StakingTest is BaseTest {
    uint256 private stakeAmount = 1 ether;
    uint256 private maxDuration = 1461 days;

    event Stake(address indexed user, uint256 lockupId, uint256 amount, uint256 end, uint256 points);
    event Unstake(address indexed user, uint256 lockupId, uint256 amount, uint256 end, uint256 points);
    event Extend(
        address indexed user,
        uint256 lockupId,
        uint256 amount,
        uint256 oldEnd,
        uint256 newEnd,
        uint256 oldPoints,
        uint256 newPoints
    );
    event RewardsAdded(uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    // solhint-disable-next-line var-name-mixedcase
    uint256 public TOLERANCE = 1e14; // 0.01% (1e18 being 100%)

    // Fuzzing constraints
    uint256 public constant MAX_STAKE_AMOUNT = 100e6 * 1e18; // default 100m toke
    uint256 public constant MAX_REWARD_ADD = 1e9 * 1e18; // default 1B eth

    function setUp() public virtual override {
        super.setUp();

        // get some initial toke
        deal(address(toke), address(this), 10 ether);

        deployGpToke();

        assertEq(gpToke.name(), "Staked Toke");
        assertEq(gpToke.symbol(), "accToke");

        // approve future spending
        toke.approve(address(gpToke), toke.balanceOf(address(this)));
    }

    /* **************************************************************************** */
    /* 						Staking helper methods									*/

    function stake(uint256 amount, uint256 stakeTimespan) private {
        stake(amount, stakeTimespan, address(this));
    }

    function stake(uint256 amount, uint256 stakeTimespan, address user) private {
        vm.assume(amount > 0 && amount < MAX_STAKE_AMOUNT);

        (uint256 points, uint256 end) = gpToke.previewPoints(amount, stakeTimespan);
        vm.expectEmit(true, false, false, false);
        emit Stake(user, 0, amount, end, points);
        gpToke.stake(amount, stakeTimespan);
    }

    /* **************************************************************************** */
    /* 									Rewards										*/
    /* **************************************************************************** */

    

    
    function test_StakingRewards_MultiUser() public {
  

        prepareFunds(address(this), 100e18); 

        // Stakes for user 1

        // add awards (just to have original pot)
        address user1 = address(this);
        vm.label(user1, "user1");

        // stake toke for 1 years
        stake(1e18, ONE_YEAR, user1);
        // make sure we can't cash anything yet
        assertEq(gpToke.previewRewards(), 0, "Shouldn't have any rewards yet to claim");
        
        //Skip 1 month
        // 60x60x24x30 = 2,592,000
        skip(2592000);

        // User2 front run the topoffRewards and stake

        address user2 = createAndPrankUser("user2", 100e18);
        prepareFunds(user2, 100e18);

        // User2 stake same amount that User1 stake for 11 month
        // 60x60x24x30x11 = 28512000 
        stake(1e18, 28512000 , user2);
        // ////////////////////
        // add new rewards
        vm.startPrank(user1);
        topOffRewards(10e18);
        
          // verify rewards
        assertApproxEqRel(gpToke.previewRewards(user1), 5020129571549399955, TOLERANCE, "Incorrect new rewards amount");
        assertApproxEqRel(gpToke.previewRewards(user2), 4979870428448333152 , TOLERANCE, "Incorrect new rewards amount");

        // claim rewards
        collectRewards(user1);
        collectRewards(user2);

        assertApproxEqRel(gpToke.previewRewards(user1), 0, TOLERANCE);
        assertApproxEqRel(gpToke.rewardsClaimed(user1), 5020129571549399955, TOLERANCE);
        assertApproxEqRel(gpToke.previewRewards(user2), 0, TOLERANCE);
        assertApproxEqRel(gpToke.rewardsClaimed(user2), 4979870428448333152, TOLERANCE);
    }

    /* **************************************************************************** */
    /* 						Rewards helper methods									*/

    // @dev Top off rewards to make sure there is enough to claim
    function topOffRewards(uint256 _amount) private {
        vm.assume(_amount < MAX_REWARD_ADD);

        // get some weth if not enough to top off rewards
        if (weth.balanceOf(address(this)) < _amount) {
            deal(address(weth), address(this), _amount);
        }

        uint256 wethStakingBalanceBefore = weth.balanceOf(address(gpToke));

        weth.approve(address(gpToke), _amount);

        vm.expectEmit(true, false, false, false);
        emit RewardsAdded(_amount);
        gpToke.addWETHRewards(_amount);

        assertEq(weth.balanceOf(address(gpToke)), wethStakingBalanceBefore + _amount);
    }

    function collectRewards(address user) private {
        vm.startPrank(user);

        uint256 claimTargetAmount = gpToke.previewRewards();

        vm.expectEmit(true, true, true, true);
        emit RewardsClaimed(user, claimTargetAmount);
        gpToke.collectRewards();

        vm.stopPrank();
    }

    function prepareFunds(address user, uint256 amount) private {
        vm.startPrank(user);

        deal(address(toke), user, amount);
        toke.approve(address(gpToke), amount);
        deal(address(weth), user, amount);
        weth.approve(address(gpToke), amount);
    }

   

    
}

```

## Tool used

Manual Review

## Recommendation

Consider the recalculating the [points](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/staking/GPToke.sol#L195C9-L195C15) which affected by the staking block.timestamp. 



