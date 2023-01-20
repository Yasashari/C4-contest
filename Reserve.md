Significant roundoff error in melt() function

significant roundoff error is caused when calculating numPeriods.

Proof of Concept

    70  function melt() external notPausedOrFrozen {
    71      if (uint48(block.timestamp) < uint64(lastPayout) + period) return;
    72
    73      // # of whole periods that have passed since lastPayout
    74      uint48 numPeriods = uint48((block.timestamp) - lastPayout) / period;
    75
    76    // Paying out the ratio r, N times, equals paying out the ratio (1 - (1-r)^N) 1 time.
    77    uint192 payoutRatio = FIX_ONE.minus(FIX_ONE.minus(ratio).powu(numPeriods));
    78
    79        uint256 amount = payoutRatio.mulu_toUint(lastPayoutBal);
    80
    81        lastPayout += numPeriods * period;
    82        lastPayoutBal = rToken.balanceOf(address(this)) - amount;
    83        if (amount > 0) rToken.melt(amount);
    84    }
    
    
    Consider this senario.
    
    period = 1000
    lastPayout = Y 
    block.timestamp = Y + 1999 

So numPeriods = uint48((block.timestamp) - lastPayout) / period
              = (Y + 1999 - Y)/1000
              = 1999/1000 = 1



