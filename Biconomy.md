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
    
 
    
    
