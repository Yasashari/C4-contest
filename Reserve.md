## Significant roundoff error in melt() function

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
    
https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/Furnace.sol#L74
    
    Consider this senario.
    
    period = 1000
    lastPayout = Y 
    block.timestamp = Y + 1999 

So numPeriods = uint48((block.timestamp) - lastPayout) / period

              = (Y + 1999 - Y)/1000
              
              = 1999/1000 = 1
              
 But in this situation numPeriods should be approximatly 2 .
 
 this error propogate futher such that , 
 
 payoutRatio = (1 - (1-r)^N) 
 
 payoutRatio shoud be = (1 - (1-r)^2)
 
 But payoutRatio now = (1 - (1-r)^1)
 
 Also it affected to amount , lastPayout , lastPayoutBal . 
 
        81  lastPayout += numPeriods * period;
        
https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/Furnace.sol#L81
        
Because of above line these wrong calculated values are accumulated in lastPayout . If someone call this function frequntly such as (lastPayout + 1.9999period) time
interval  error is going to be huge. 

Tools Used

Vs code

Recommended Mitigation Steps

consider calculate like this, Basically do the multipication first and devide eventually. ( Basically this one. A^(b/c)  = A^b/A^c)


    numPeriods = uint48((block.timestamp) - lastPayout) / period
    consider x = uint48((block.timestamp) - lastPayout)
    and  y  = period
    so numPeriods(N) = x/y
 
    payoutRatio = (1 - (1-r)^N) 
                = 1 -((1-r)^x)/((1-r)^y)
 
 








 
 
 
 


 
 
 
 



