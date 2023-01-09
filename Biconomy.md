## NO TRANSFER OWNERSHIP PATTERN
if owner has passed wrong account address here then contract is in a risk.

    109     function setOwner(address _newOwner) external mixedAuth {
    
    110    require(_newOwner != address(0), "Smart Account:: new Signatory address cannot be zero");
    
    111    address oldOwner = owner;
    
    112    owner = _newOwner;
    
    113    emit EOAChanged(address(this), oldOwner, _newOwner);
    
    114   }
    
    
https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/SmartAccount.sol#L109


## Tools Used
    VS Code 

## Recommended Mitigation Steps

     To avoid that one setup two step process transfer ownership and accept it by new owner.
     
    	address public owner;
    	address public newOwner;
    
    	function setOwner(address newAddress) external {
		// Check tx comes from current owner
		if (msg.sender != owner) {
			revert MustBeOwner();
		}
		// Store new address awaiting confirmation
		newOwner = newAddress;
	}

	// Completes transfer of ownership
	function confirmOwner() external {
		if (msg.sender != newOnwer) {
			revert InvalidOwnerConfirmation();
		}
		// Store old owner for event
		address oldOwner = owner;
		// Update owner and clear storage
		owner = newOwner;
		delete newOwner;
		emit EOAChanged(address(this),oldOwner,owner);
	}
    

## There is no upperboud for unstakedelaysec. So user funds can be stucked for long time.
	User able to pass large number (uint32 max number) also cannot decrease untastake delay. That might caused user funds stucked long time. 
	If consider the maximum number of uint32 and users are able to set unstake delay up to 136 years. If user unintentionally pass number then 
	their funds might be stuck long time. 
	
	
	59	function addStake(uint32 _unstakeDelaySec) public payable {
        	....
	62	require(_unstakeDelaySec >= info.unstakeDelaySec, "cannot decrease unstake time");
        	....
    		}

https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/StakeManager.sol#L62

## Tools Used
	VS Code

## Recommended Mitigation Steps
	So better to have upper bound of unstake delay or set function to decrease the unstake delay time. 

# QA report

## LACK OF CHECKS ADDRESS(0)
The following methods have a lack of checks if the received argument is an address, it’s good practice in order to reduce human error to check that the address
specified in the constructor or initialize is different than address(0).


#### Affected Source Code

* [StakeManager.sol:96](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/StakeManager.sol#L96)
* [StakeManager.sol:115](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/StakeManager.sol#L115)
* [FallbackManager.sol:26](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/base/FallbackManager.sol#L26)
* [VerifyingSingletonPaymaster.sol:55](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/verifying/singleton/VerifyingSingletonPaymaster.sol#L55)
* [BasePaymaster.sol:20](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/BasePaymaster.sol#L20)

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


## Missing natspec comments
#### Affected Source Code
* [ModuleManager.sol:19](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/base/ModuleManager.sol#L19)

## OPEN TODO
The code that contains “open todos” reflects that the development is not finished and that the code can change a posteriori, prior release, with or without
audit.

#### Affected Source Code
* [SmartAccountNoAuth.sol:44](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/SmartAccountNoAuth.sol#L44)


# Gas Report

## ADD UNCHECKED {} FOR ITERATOR WHERE THE OPERANDS CANNOT OVERFLOW BECAUSE ITS ALLWAYS BELOW THE GIVEN NUMBER.
	
for loops j++ and i++ can be set to UNCHECKED{++j} and UNCHECKED{++i}

There are 7 instances of this issue:

        File: contracts/contract/MinipoolManager.sol

	100	for (uint256 i = 0; i < opasLen; i++) {
	
	107	for (uint256 a = 0; a < opasLen; a++) {
	
	112	for (uint256 i = 0; i < opslen; i++) {
	
	114	opIndex++;
	
	128	for (uint256 a = 0; a < opasLen; a++) {
	
	134	for (uint256 i = 0; i < opslen; i++) {
	
	136	 opIndex++;
	

https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/EntryPoint.sol#L100




	
	

	
		

	
	
	
	

	
 
    
    
