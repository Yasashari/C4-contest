# maxLoopsLimit can not be decreased onece it has been set.
Lets think if maxLoopsLimit is set to 200 . Later found that above 190 iterations are going to be DOS due to future update of
binance smart chain or protocol update. Then there should be a way to reduced maxLoopsLimit to 190. Otherwise eventhough
_ensureMaxLoops(uint256 len) function not revert on lets say 195 iterations , but its actually going to be DOS.  
So there should be a way to decreased it . Currently Only increasing is possble. 

## Proof of Concept

    25   function _setMaxLoopsLimit(uint256 limit) internal {
    26    require(limit > maxLoopsLimit, "Comptroller: Invalid maxLoopsLimit");

    28    uint256 oldMaxLoopsLimit = maxLoopsLimit;
    29    maxLoopsLimit = limit;

    31    emit MaxLoopsLimitUpdated(oldMaxLoopsLimit, maxLoopsLimit);
    32    }
    

https://github.com/code-423n4/2023-05-venus/blob/main/contracts/MaxLoopsLimitHelper.sol#L26


## Tools Used
Manual Auditing

## Recommended Mitigation Steps

Use this require statement instead of current one. 

    26  require(limit > 0 , "Comptroller: Invalid maxLoopsLimit");
    
    
