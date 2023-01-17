## CHAINLINK'S MULTISIGS CAN IMMEDIATELY BLOCK ACCESS TO PRICE FEEDS AT WILL. 

The multisigs of Chainlink can restrict access to pricing feeds. Therefore, it is safer to query Chainlink pricing feeds using a defensive strategy with Solidity's
try/catch structure to avoid denial of service problems. In this approach, even if the call to the price feed fails, the caller contract is still in charge and has the
ability to safely and explicitly manage any failures.

Proof of Concept

    108   price = getChainlinkOraclePrice(fToken);

https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol#L108

Below function is not solve above issue because it returns minimum of given two prices. 

    114   if (fTokenToUnderlyingPriceCap[fToken] > 0) {
    115   price = _min(price, fTokenToUnderlyingPriceCap[fToken]);
    116   }
    
https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol#L114
    
 Tools Used
    Vs code
 
 Recommended Mitigation Steps
    Refer this article on this issue. https://blog.openzeppelin.com/secure-smart-contract-guidelines-the-dangers-of-price-oracles/ .
    Use try/catch with latestRoundData() instead of calling it directly. In a scenario where the call reverts, the catch block can be used to call a
    fallback oracle or handle the error in any other suitable way. So Update [function getChainlinkOraclePrice](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol#L277) in order to tackle above issue. 
    
## DOS IN UTILIZATIONRATE 
    utilizationrate = borrows / (cash + borrows - reserves). if cash+ borrows ≈ reserves this goes to infinity so that utilizationrate reverts. 
    Also if cash + borrows < reserves same effet caused. 
    If utilizationrate reverts theser functions are also reverts.
    126     function getBorrowRate(
    152     function getSupplyRate(
    
 Proof of Concept
 
     116    return borrows.mul(1e18).div(cash.add(borrows).sub(reserves));
 https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/JumpRateModelV2.sol#L116
 
  Tools Used
    Vs code
 
 Recommended Mitigation Steps
 
    add require statement in function utilizationRate() on  https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/JumpRateModelV2.sol#L116
        require( cash + borrows > reserves )
        
##  FRONTRUN IS POSSIBLE WHEN CHANGING APPROVE AMOUNT
    When changing the approved amount frontrun is possible. So its safer to inherit openzeppling SafeERC20 lib. 
    There are 2 instances ot this issue. 

Proof of Concept
    
    182 function approve(
https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/tokens/cToken/CTokenModified.sol#L182

    182  function approve(
https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/tokens/cCash/CTokenCash.sol#L182

 Tools Used
    Vs code
 
 Recommended Mitigation Steps
    
    Implement safeIncreaseAllowance and safeDecreaseAllowance functions or use openzeppling safeERC20 lib to increase or decrease approve amount.
    https://github.com/OpenZeppelin/openzeppelin-contracts/blob/566a774222707e424896c0c390a84dc3c13bdcb2/contracts/token/ERC20/utils/SafeERC20.sol#L59
    https://github.com/OpenZeppelin/openzeppelin-contracts/blob/566a774222707e424896c0c390a84dc3c13bdcb2/contracts/token/ERC20/utils/SafeERC20.sol#L68
    
..................................................................................................................................................................    
    

# QA report

## FLOATING & OLD VERSION OF PRAGMA 
#### Affected Source Code
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [JumpRateModelV2.sol:1](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/JumpRateModelV2.sol#L1)

* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)
* [OndoPriceOracle.sol:15](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L15)








## LACK OF CHECKS ADDRESS(0)
The following methods have a lack of checks if the received argument is an address, it’s good practice in order to reduce human error to check that the address
specified in the constructor or initialize is different than address(0).


#### Affected Source Code

* [OndoPriceOracle.sol:80](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L80)
* [OndoPriceOracle.sol:106](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L106)
* [OndoPriceOracle.sol:119](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L119)



* [StakeManager.sol:115](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/StakeManager.sol#L115)
* [FallbackManager.sol:26](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/base/FallbackManager.sol#L26)
* [VerifyingSingletonPaymaster.sol:55](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/verifying/singleton/VerifyingSingletonPaymaster.sol#L55)
* [BasePaymaster.sol:20](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/BasePaymaster.sol#L20)

## LACK OF CHEKS FOR UNITS IN ORDER TO PREVENT SETTING DEFAULT VALUES. 
    In oder to prevent human errors its better to having a value for units rather than inizialize with 0 values.
    
* [OndoPriceOracle.sol:80](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracle.sol#L80)
   

## Internal and private functions should have an underscore prefix with mixedCase(Naming convention)
#### Affected Source Code
* [EntryPoint.sol:484](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/EntryPoint.sol#L484)
* [EntryPoint.sol:496](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/EntryPoint.sol#L496)
* [EntryPoint.sol:500](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/EntryPoint.sol#L500)
* [EntryPoint.sol:504](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/EntryPoint.sol#L504)
* [EntryPoint.sol:511](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/EntryPoint.sol#L511)
* [StakeManager.sol:23](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/EntryPoint.sol#L511)
* [Executor.sol:13](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/base/Executor.sol#L13)
* [FallbackManager.sol:14](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/base/FallbackManager.sol#L14)
* [SecuredTokenTransfer.sol:10](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/common/SecuredTokenTransfer.sol#L10)
* [SelfAuthorized.sol:6](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/common/SelfAuthorized.sol#L6)
* [SignatureDecoder.sol:10](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/common/SignatureDecoder.sol#L10)
* [LibAddress.sol:11](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/libs/LibAddress.sol#L11)
* [PaymasterHelpers.sol:24](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/PaymasterHelpers.sol#L24)
* [PaymasterHelpers.sol:34](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/PaymasterHelpers.sol#L34)
* [PaymasterHelpers.sol:43](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/PaymasterHelpers.sol#L43)
* [SmartAccount.sol:247](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/SmartAccount.sol#L247)


    For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#other-recommendations)
    2. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)

## Private state variables should have an underscore prefix
#### Affected Source Code
[MultiSend.sol:10](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/libs/MultiSend.sol#L10)

  For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#other-recommendations)
    2. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)


## Missing natspec comments
#### Affected Source Code
* [ModuleManager.sol:19](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/base/ModuleManager.sol#L19)

## OPEN TODO
The code that contains “open todos” reflects that the development is not finished and that the code can change a posteriori, prior release, with or without
audit.

#### Affected Source Code
* [SmartAccountNoAuth.sol:44](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/SmartAccountNoAuth.sol#L44)


................................................................................................................................................................




    
 
 
 
 
     
    

