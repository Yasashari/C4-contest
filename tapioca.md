##  deprecated syntax (this)

There are few occasions used this keyword to obtain the address of the contract. So it should be used address(this) instead of
(this). ( this term is used for the smart contract when the solidity version is below 0.5.0 )

### Proof of Concept

        285           payable(this),

https://github.com/Tapioca-DAO/tapioca-periph-audit/blob/main/contracts/Magnetar/modules/MagnetarMarketModule.sol#L285


        761          gas > 0 ? payable(msg.sender) : payable(this),

https://github.com/Tapioca-DAO/tapioca-periph-audit/blob/main/contracts/Magnetar/modules/MagnetarMarketModule.sol#L761


        312          this.sendFrom{value: address(this).balance}(

https://github.com/Tapioca-DAO/tap-token-audit/blob/main/contracts/tokens/BaseTapOFT.sol#L312

### Tools Used
Vs code

### Recommended Mitigation Steps
Use address(this) instead of this. 








