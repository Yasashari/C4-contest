## Internal and private functions should have an underscore prefix with mixedCase(Naming convention)
Affected Source Code
Total instances : 

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L16

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L22

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#248

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#154























## Gas Report

## ADD UNCHECKED {} FOR ITERATOR WHERE THE OPERANDS CANNOT OVERFLOW BECAUSE ITS ALLWAYS BELOW THE GIVEN NUMBER.

for loops j++ and i++ can be set to UNCHECKED{++j} and UNCHECKED{++i} including length.  Cash Array.lenght into variable so that it will evaluate array.lenght
overflow. So no need to check array.length overflow every iteration.    

Recommended Mitigation Steps 
    UNCHECKED{
    ++i ;
    array.length ;
    }


Affected Source Code
Total instances :

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L38

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L49

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L127

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L138

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#L221

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#L238







