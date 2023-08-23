## Summary
LMPVault.sol should comply with the EIP4626 standard but it's not. 

## Vulnerability Detail
Non-compliant EIP4626 functions are listed below along with the reason they are not compliant:
(All official EIP-4626 requirements can be found on [here](https://eips.ethereum.org/EIPS/eip-4626#methods).)
1. previewDeposit is not compliant because it must account for fees which it does not.
2. [noNavChange](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L141) , [ensureNoNavOps](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L153C14-L153C30)  modifiers should be added to the  maxDeposit function: Since maxDeposit may exceed nav/share outside of rounding tolerance. Here it should be calculated the maximum amount that is satisfied the nav/share rounding tolerance. 
3. [noNavDecrease](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L153) , [ensureNoNavOps](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L153C14-L153C30) modifier should be added to the maxRedeem function: Since maxRedeem may exceed nav/share outside of rounding tolerance. Here it should be calculated the maxRedeem amount that is satisfied the nav/share rounding tolerance.

## Impact
Other protocols that integrate with Tokemak may wrongly assume that the functions are EIP-4626 compliant. Thus, it might cause integration problems in the future that can lead to wide range of issues for both parties.

## Code Snippet
[previewDeposit function](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L328C3-L330C6)

```solidity
                function previewDeposit(uint256 assets) public view virtual returns (uint256 shares) {
                      shares = _convertToShares(assets, Math.Rounding.Down);
                  }
```

[maxDeposit function](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L323C1-L325C6)

```solidity
                function maxDeposit(address wallet) public view virtual override returns (uint256 maxAssets) {
                    maxAssets = convertToAssets(_maxMint(wallet));
                }
```
[maxRedeem function](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L357C3-L359C6)

```solidity

                function maxRedeem(address owner) public view virtual returns (uint256 maxShares) {
                      maxShares = _maxRedeem(owner);
                  }
```

## Tool used

Manual Review

## Recommendation

All functions listed above should be modified to comply with the specifications of EIP-4626.



