## Some functions of UlyssesERC4626.sol contract not working as expected

previewMint , previewDeposit, convertToAssets , convertToShares are not exactly return the same value as expected. Since fees are
involving with it.

## Proof of Concept

When user use deposit or mint function user should able to see how much token they will be recieved (due to minting) using
previewMint or previewDeposit functions. But they will be recieved diffrent amount with what previewMint or Previewdeposit
functions returning.

    96            function previewDeposit(uint256 assets) public view virtual returns (uint256) {
    97                return assets;
    98            }
    99        
    100            function previewMint(uint256 shares) public view virtual returns (uint256) {
    101                return shares;
    102            }

 https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/UlyssesERC4626.sol#L96-L102   

These above functions showing exactly same amount they will be recived. 

But Deposit and mint functions are used different functions to get the recived amounts. 


    34        function deposit(uint256 assets, address receiver) public virtual nonReentrant returns (uint256 shares) {
              // Need to transfer before minting or ERC777s could reenter.
              asset.safeTransferFrom(msg.sender, address(this), assets);
      
              shares = beforeDeposit(assets);
      
              require(shares != 0, "ZERO_SHARES");
      
              _mint(receiver, shares);
      
              emit Deposit(msg.sender, receiver, assets, shares);
          }
      
          function mint(uint256 shares, address receiver) public virtual nonReentrant returns (uint256 assets) {
              assets = beforeMint(shares); // No need to check for rounding error, previewMint rounds up.
      
              require(assets != 0, "ZERO_ASSETS");
      
              asset.safeTransferFrom(msg.sender, address(this), assets);
      
              _mint(receiver, shares);
      
              emit Deposit(msg.sender, receiver, assets, shares);
     57        }

https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/UlyssesERC4626.sol#L34-57

  Here its used beforeDeposit & beforeMint functions to get the mint amount. But its different with previewMint and previewDeposit
  return values. Currently previewMint or previewDeposit showing the same amount they will be minted. But actual one is different.
  Since beforeDeposit & beforeMint functions are associate with the fees so deposit & minting amounts are different. 

 Same thing is going with previewRedeem(uint256 shares) and redeem functions. 

Also this is also not comply with the EIP-4626 standared. 

previewDeposit

        MUST return as close to and no more than the exact amount of Vault shares that would be minted in a deposit call in the
        same transaction. I.e. deposit should return the same or more shares as previewDeposit if called in the same transaction.

https://eips.ethereum.org/EIPS/eip-4626. 


## Tools Used
Manual Auditing

## Recommended Mitigation Steps

Use standared ERC4626 contract to implement those functions.





  

  

  
  

  
    

  









