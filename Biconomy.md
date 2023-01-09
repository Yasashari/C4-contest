## NO TRANSFER OWNERSHIP PATTERN
if owner has passed wrong account address here then contract is in huge risk.

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
* [BasePaymaster.sol:20](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/paymasters/BasePaymaster.sol#L20)
* [StakeManager.sol:96](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/StakeManager.sol#L96)
* [StakeManager.sol:115](https://github.com/code-423n4/2023-01-biconomy/blob/main/scw-contracts/contracts/smart-contract-wallet/aa-4337/core/StakeManager.sol#L115)
* [MinipoolManager.sol:184](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/MinipoolManager.sol#L184)
* [Ocyticus.sol:28](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Ocyticus.sol#L28)
* [ProtocolDAO.sol:191](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/ProtocolDAO.sol#L191)
* [Staking.sol:62](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Staking.sol#L62)
* [Storage.sol:47](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Storage.sol#L47)
* [Vault.sol:205](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Vault.sol#L205)





## OPEN TODO
The code that contains “open todos” reflects that the development is not finished and that the code can change a posteriori, prior release, with or without
audit.

#### Affected Source Code
* [BaseAbstract.sol:6](https://github.com/code-423n4/2022-12-gogopool/blob/aec9928d8bdce8a5a4efe45f54c39d4fc7313731/contracts/contract/BaseAbstract.sol#L6)

	
	

	
		

	
	
	
	

	
 
    
    
