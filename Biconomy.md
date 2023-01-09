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

	
	

	
		

	
	
	
	

	
 
    
    
