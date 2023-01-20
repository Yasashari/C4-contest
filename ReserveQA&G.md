## Internal and private functions should have an underscore prefix with mixedCase(Naming convention). Internal and private variable with same convention. 
Affected Source Code
Total instances : 56

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L16

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol#L22

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#L248

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol#L154

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L68

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L75

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L87

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L128

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L132

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L139

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L356

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L650

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L665

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#L26

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#L27

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#L28

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol#L44

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Distributor.sol#L17

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RevenueTrader.sol#L20

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RevenueTrader.sol#L21

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L59

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L60

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L61

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L62

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L72

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L76

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L77

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L98

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L102

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L344

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L655

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L737

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L56

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L60

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L61

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L62

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L73

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L83

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L84

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L150

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L574

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L586

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L596

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSRVotes.sol#L49

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RecollateralizationLib.sol#L152

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RecollateralizationLib.sol#L226

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RecollateralizationLib.sol#L319

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RecollateralizationLib.sol#L428

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RecollateralizationLib.sol#L463

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/TradeLib.sol#L38

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/TradeLib.sol#L103

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/TradeLib.sol#L140

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/TradeLib.sol#L154

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/TradeLib.sol#L180

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/TradeLib.sol#L188

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/Trading.sol#L24

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/Trading.sol#L111

 For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#function-names)
    2. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)



## External & Public Functions should use mixedCase withot underscore

Affected Source Code
Total instances : 1

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol#L791

 For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#function-names)
    2. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)


## No visibility set
Affected Source Code
Total instances : 3

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L40

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L42

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol#L44


## Contract and library names should also match their filenames

But these sol files contract name and its file name is different

Affected Source Code
Total instances : 11

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/AssetRegistry.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BackingManager.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/BasketHandler.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Broker.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Deployer.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Distributor.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Furnace.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Main.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RevenueTrader.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSR.sol

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/StRSRVotes.sol

For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#contract-and-library-names)




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
Total instances : 42

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

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Distributor.sol#L108

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Distributor.sol#L133

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Distributor.sol#L143

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L270

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L303

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L329

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L334

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L674

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L683

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L711

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L757

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L767

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L793

https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L802

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RecollateralizationLib.sol#L242

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RecollateralizationLib.sol#L437

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RewardableLib.sol#L27

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RewardableLib.sol#L67

https://github.com/reserve-protocol/protocol/blob/df7ecadc2bae74244ace5e8b39e94bc992903158/contracts/p1/mixins/RewardableLib.sol#L73


 ## SPLITTING REQUIRE() STATEMENTS THAT USE && SAVES GAS
 
 Affected Source Code
Total instances : 5
 
 https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/Deployer.sol#L49
 
 https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L590
 
 https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L623
 
 https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L741
 
 https://github.com/reserve-protocol/protocol/blob/master/contracts/p1/RToken.sol#L813
 

 
 
 
 
 
 
 
 



















