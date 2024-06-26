## Summary
LMPVault.sol should comply with the EIP4626 standard but it's not. 

## Vulnerability Detail
Non-compliant EIP4626 functions are listed below along with the reason they are not compliant:
(All official EIP-4626 requirements can be found on [here](https://eips.ethereum.org/EIPS/eip-4626#methods).)
1. [noNavChange](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L141) , [ensureNoNavOps](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L153C14-L153C30)  modifiers should be added to the  [maxDeposit](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L323C1-L325C6), [maxMint](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L347C3-L349C6), [previewDeposit](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L328C4-L330C6) function: Since deposit tokens may exceed nav/share outside of rounding tolerance. 
2. [noNavDecrease](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L147) , [ensureNoNavOps](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L153C14-L153C30) modifier should be added to the [maxRedeem](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L357C1-L359C6) , [previewWithdraw](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L367C5-L369C6) , [previewRedeem](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L372C4-L374C6) function: Since withdrawing tokens may exceed nav/share outside of rounding tolerance. 

## Impact
Other protocols that integrate with Tokemak may wrongly assume that the functions are EIP-4626 compliant. Thus, it might cause integration problems in the future that can lead to wide range of issues for both parties.

## Code Snippet
Please see the links & blocks above mentioned. 

## Tool used

Manual Review

## Recommendation

All functions listed above should be modified to comply with the specifications of EIP-4626.



