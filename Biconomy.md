## NO TRANSFER OWNERSHIP PATTERN
if owner has passed wrong account address here then contract is in huge risk. To avoid that one there is a two step process transfer ownership and accept it by new owner.

    109  function setOwner(address _newOwner) external mixedAuth {
    
    110    require(_newOwner != address(0), "Smart Account:: new Signatory address cannot be zero");
    
    111    address oldOwner = owner;
    
    112    owner = _newOwner;
    
    113    emit EOAChanged(address(this), oldOwner, _newOwner);
    
    114   }
