## Internal and private functions should have an underscore prefix with mixedCase(Naming convention). Internal and private variable with same convention. 
Affected Source Code
Total instances : 

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L16

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L22

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#248

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#154

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#68

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L75

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L87

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L128

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L132

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L139

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L356

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L650

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L665

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#26

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#27

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#28

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#L44














## No visibility set
Affected Source Code
Total instances : 

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L40

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L42

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L44


























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

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L70

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L78

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L218

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#l227

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L262

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L286

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L337

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L397

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L416

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L437

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L548

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L553

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L586

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L597

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L611

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L707

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L725


 ## SPLITTING REQUIRE() STATEMENTS THAT USE && SAVES GAS
 
 https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Deployer.sol#L49
 
 



















