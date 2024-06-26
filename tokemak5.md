## Summary
Users will experience a DOS when trying to deposit to a LMPVault after rebalance. 

## Vulnerability Detail
When user [deposits](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L337) its checked that assets is less than maxDeposit. However, because the _maxMint function will
return the [type(uint256).max](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L936C7-L938C10) value when both the supplyLimit andwalletLimit are set to type(uint256).max value, this
assertion will almost always revert when
the [totalAssets() / supply](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L597C57-L597C78) is greater than 1 because the type(uint256).max will be provided to the _convertToAssets function as the shares
parameter, leading to an over-flow error on the [assets](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L597C9-L597C15) calculation.

## Impact
Users no longer able to deposit funds on LMPVault contract. 

## Code Snippet

This test case was extracted from the LMPVault-Withdraw.t.sol. After this
[test_withdraw_ReceivesNoMoreThanCachedIfPriceIncreases()](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/test/vault/LMPVault-Withdraw.t.sol#L1000) it has been added the user deposit code  & eventually it DOS
due to overflow.

```solidity
function test_withdraw_ReceivesNoMoreThanCachedIfPriceIncreases() public {
        _accessController.grantRole(Roles.SOLVER_ROLE, address(this));
        _accessController.grantRole(Roles.LMP_FEE_SETTER_ROLE, address(this));

        // User is going to deposit 1000 asset
        _asset.mint(address(this), 1000);
        _asset.approve(address(_lmpVault), 1000);
        _lmpVault.deposit(1000, address(this));
      
  
        // Deployed 200 asset to DV1
        _underlyerOne.mint(address(this), 100);
        _underlyerOne.approve(address(_lmpVault), 100);
        _lmpVault.rebalance(
            address(_destVaultOne),
            address(_underlyerOne), // tokenIn
            100,
            address(0), // destinationOut, none when sending out baseAsset
            address(_asset), // baseAsset, tokenOut
            200
        );


        // Deploy 800 asset to DV2
        _underlyerTwo.mint(address(this), 800);
        _underlyerTwo.approve(address(_lmpVault), 800);
        _lmpVault.rebalance(
            address(_destVaultTwo),
            address(_underlyerTwo), // tokenIn
            800,
            address(0), // destinationOut, none when sending out baseAsset
            address(_asset), // baseAsset, tokenOut
            800
        );

       

        // Price of DV1 doubled
        _mockRootPrice(address(_underlyerOne), 4e18);

        // Cashing in 900 shares, which means we're entitled to at most 900 assets
        // We can get 400 from DV1, and we'll get the remaining 500 from DV2
        // Should leave us with no shares of DV1 and 300 of DV2

        uint256 balBefore = _asset.balanceOf(address(this));
        // vm.expectEmit(true, true, true, true);
        // emit Withdraw(address(this), address(this), address(this), 425, 500);
        uint256 assets = _lmpVault.redeem(900, address(this), address(this));
        uint256 balAfter = _asset.balanceOf(address(this));

        assertEq(assets, 900, "returned");
        assertEq(balAfter - balBefore, 900, "actual");

 
// User deposit here, DOS due to overflow. 
        address user1 = address(0x1);
        _asset.mint(user1, 700);

        vm.startPrank(user1);
        _asset.approve(address(_lmpVault), 700);
        _lmpVault.deposit(700, user1);

        vm.stopPrank();

    }
```

Also used console.log to check  [_convertToAssets function](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L595C3-L598C6) .  Also final output values as in terminal as shown below. 
```solidity
  function _convertToAssets(uint256 shares, Math.Rounding rounding) internal view virtual returns (uint256 assets) {
        uint256 supply = totalSupply();
        console.log("supply:", supply);
        console.log("shares:" , shares);
        console.log("totalAssets():" , totalAssets());
        assets = (supply == 0) ? shares : shares.mulDiv(totalAssets(), supply, rounding);
       // assets = (supply == 0) ? shares : shares.mulDiv(1, supply, rounding);
        console.log("assets" , assets);
    }
```

TERMINAL
```
supply: 100
shares: 115792089237316195423570985008687907853269984665640564039457584007913129639935  
totalAssets(): 300
```
So here assets = shares x totalAssets() / supply 
              = 115792089237316195423570985008687907853269984665640564039457584007913129639935 x 300 / 100 ---> Overflow
              
## Tool used
Foundry

## Recommendation
It is recommended to refactor the [maxDeposit](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L323) function to return the type(uint256).max value if the [_maxMint](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/vault/LMPVault.sol#L921) function
returns this value. This can be implemented by refactoring the maxDeposit function as follows:
```solidity
    function maxDeposit(address wallet) public view virtual override returns (uint256 maxAssets) {
        // @audit recommended mitigation
        uint256 maxMintAmount = _maxMint(wallet);
        maxAssets = maxMintAmount == type(uint256).max ? maxMintAmount : convertToAssets(maxMintAmount);
    }
```

