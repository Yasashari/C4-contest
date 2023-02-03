## Mathematical Modelling Cause a Significant Roundoff Error

function _drippedAmt calculate a ended cycles. when calculating ended cycles it takes two divisions which cause round off error. 

Lets consider this senario. 

Deposited token - WBTC

amtPerSec =  100000000 = 10^8 (Here consider the 0.1 wei)

start = 1675444689

end =  1675444700

( end - start = 11)

cycleSecs = 10

with above conditions when calculating the ended cycles with the equation used line 1104

    1104  let endedCycles := sub(div(end, cycleSecs), div(start, cycleSecs))
    
endedCycles =  1675444700/10 - 1675444689/10 =  167544470 - 167544468 =  2

    1106  let amtPerCycle := div(mul(cycleSecs, amtPerSec), _AMT_PER_SEC_MULTIPLIER)
 
amtPerCycle =  10 x 100000000 / 10^9  =  1

    1107  amt := mul(endedCycles, amtPerCycle)

amt =  2x1

    1109  let amtEnd := div(mul(mod(end, cycleSecs), amtPerSec), _AMT_PER_SEC_MULTIPLIER)

amtEnd =  0x10^8/10^9 =  0

    1110  amt := add(amt, amtEnd)

amt =  2

    1112  let amtStart := div(mul(mod(start, cycleSecs), amtPerSec), _AMT_PER_SEC_MULTIPLIER)

amtStart =  9x10^8/10^9 = 0

    1113  amt := sub(amt, amtStart)

amt =  2 wei

But amt should be = (end - start)x amtPerSec  = 11x 10^8 = 1.1x 10^9 = 1.1 wei

This is affecting _isBalanceEnough function 

        745   for (uint256 i = 0; i < configsLen; i++) {
                (uint256 amtPerSec, uint256 start, uint256 end) = _getConfig(configs, i);
                // slither-disable-next-line timestamp
                if (maxEnd <= start) {
                    continue;
                }
                // slither-disable-next-line timestamp
                if (end > maxEnd) {
                    end = maxEnd;
                }
        755       spent += _drippedAmt(amtPerSec, start, end);
                if (spent > balance) {
                    return false;
                }
Due to this roundoff error it could be return false here. (spent > balance). But Infact balance is able to cover the spent.

## Tools Used
Vs code

## Recommended Mitigation Steps

Use below equation to calculate _drippedAmt

    drippedAmt  =  (end - start) * amtPerSec

if need more precision 
    
    drippedAmt  =  (end - start) * amtPerSec /  _AMT_PER_SEC_MULTIPLIER
    

    











