## Initial depositor can manipulate the price per share value and future depositors are forced to deposit huge value. 

This is a kind of 1st depositor attack. Initial depositor deposits 1 wei of asset token. Then he sends a large amount of asset 
token directly to the cotract without using the deposit() or  mint() functions. So that asset account balance is increased.
Because of that minting ratio is drastically increased so future users need to pay large amounts of tokens in order to mint valut
tokens.

## Proof of Concept

A malicious early user can deposit() with 1 wei of asset token as the first depositor and get 1 wei of shares.

    32            function deposit(uint256 assets, address receiver) public virtual returns (uint256 shares) {
                        // Check for rounding error since we round down in previewDeposit.
                        require((shares = previewDeposit(assets)) != 0, "ZERO_SHARES");
                
                        // Need to transfer before minting or ERC777s could reenter.
                        address(asset).safeTransferFrom(msg.sender, address(this), assets);
                
                        _mint(receiver, shares);
                
                        emit Deposit(msg.sender, receiver, assets, shares);
                
                        afterDeposit(assets, shares);
    44                 }
   
https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/ERC4626.sol#L32C1-L44C6

Then the attacker can send 10000e18 - 1 of asset tokens and inflate the price per share from 1.0000 to an extreme value of
1.0000e22 ( from (1 + 10000e18 - 1) / 1) . ( Attacker directly send asset tokens to the contract not using deposit() or mint
function())


As a result, the future user who deposits 19999e18 will only receive 1 wei (from 19999e18 * 1 / 10000e18) of shares token.


They will immediately lose 9999e18 or half of their deposits if they redeem() right after the deposit().

     80         function redeem(uint256 shares, address receiver, address owner) public virtual returns (uint256 assets) {
                  if (msg.sender != owner) {
                      uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
          
                      if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
                  }
          
                  // Check for rounding error since we round down in previewRedeem.
                  require((assets = previewRedeem(shares)) != 0, "ZERO_ASSETS");
          
                  beforeWithdraw(assets, shares);
          
                  _burn(owner, shares);
          
                  emit Withdraw(msg.sender, receiver, owner, assets, shares);
          
                  address(asset).safeTransfer(receiver, assets);
    97          }

https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/ERC4626.sol#L80C1-L97C6

The same issues occurred with ERC4626DepositOnly.sol contracts as well. 

https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/ERC4626DepositOnly.sol
(Since the initial depositor can change the minting ratio)

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

Consider requiring a minimal amount of share tokens to be minted for the first minter, and send a port of the initial mints as a
reserve to the DAO so that the pricePerShare can be more resistant to manipulation.

                function deposit(uint256 assets, address receiver) public virtual returns (uint256 shares) {
                    beforeDeposit(assets, shares);
                
                    // Check for rounding error since we round down in previewDeposit.
                    require((shares = previewDeposit(assets)) != 0, "ZERO_SHARES");
                
                    // for the first mint, we require the mint amount > (10 ** decimals) / 100
                    // and send (10 ** decimals) / 1_000_000 of the initial supply as a reserve to DAO
                    if (totalSupply == 0 && decimals >= 6) {
                        require(shares > 10 ** (decimals - 2));
                        uint256 reserveShares = 10 ** (decimals - 6);
                        _mint(DAO, reserveShares);
                        shares -= reserveShares;
                    }
                
                    // Need to transfer before minting or ERC777s could reenter.
                    asset.safeTransferFrom(msg.sender, address(this), assets);
                
                    _mint(receiver, shares);
                
                    emit Deposit(msg.sender, receiver, assets, shares);
                }
                
                function mint(uint256 shares, address receiver) public virtual returns (uint256 assets) {
                    beforeDeposit(assets, shares);
                
                    assets = previewMint(shares); // No need to check for rounding error, previewMint rounds up.
                
                    // for the first mint, we require the mint amount > (10 ** decimals) / 100
                    // and send (10 ** decimals) / 1_000_000 of the initial supply as a reserve to DAO
                    if (totalSupply == 0 && decimals >= 6) {
                        require(shares > 10 ** (decimals - 2));
                        uint256 reserveShares = 10 ** (decimals - 6);
                        _mint(DAO, reserveShares);
                        shares -= reserveShares;
                    }
                
                    // Need to transfer before minting or ERC777s could reenter.
                    asset.safeTransferFrom(msg.sender, address(this), assets);
                
                    _mint(receiver, shares);
                
                    emit Deposit(msg.sender, receiver, assets, shares);
                }




