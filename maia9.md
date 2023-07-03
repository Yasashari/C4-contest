## User gets less number of tokens compared with what he deposited. 
User is able to deposit different amounts of underlying tokens if user immediately redeems it he will get always less amount of
tokens compared with the deposited amount with ERC4626MultiToken.sol contract. 

## Proof of Concept

     93          function deposit(uint256[] calldata assetsAmounts, address receiver)
                      public
                      virtual
                      nonReentrant
                      returns (uint256 shares)
                  {
                      // Check for rounding error since we round down in previewDeposit.
                      require((shares = previewDeposit(assetsAmounts)) != 0, "ZERO_SHARES");
              
                      // Need to transfer before minting or ERC777s could reenter.
                      receiveAssets(assetsAmounts);
              
                      _mint(receiver, shares);
              
                      emit Deposit(msg.sender, receiver, assetsAmounts, shares);
              
                      afterDeposit(assetsAmounts, shares);
     110             }

https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/ERC4626MultiToken.sol#L93C1-L110C6


     156               function redeem(uint256 shares, address receiver, address owner)
                        public
                        virtual
                        nonReentrant
                        returns (uint256[] memory assetsAmounts)
                    {
                        if (msg.sender != owner) {
                            uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
                
                            if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
                        }
                
                        assetsAmounts = previewRedeem(shares);
                        uint256 length = assetsAmounts.length;
                        for (uint256 i = 0; i < length;) {
                            // Check for rounding error since we round down in previewRedeem.
                            if (assetsAmounts[i] == 0) revert ZeroAssets();
                            unchecked {
                                i++;
                            }
                        }
                
                        beforeWithdraw(assetsAmounts, shares);
                
                        _burn(owner, shares);
                
                        emit Withdraw(msg.sender, receiver, owner, assetsAmounts, shares);
                
                        sendAssets(assetsAmounts, receiver);
     185               }


https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/ERC4626MultiToken.sol#L156C1-L185C6

let's consider the,

uint256[] public weights = [10000,300,10]

So totalWeights = 10310

If the User deposits  [ 20000 , 20000 , 20000 ] amount of underlying assets he will be minted  20620 amount of shares. 

Now user redeem 20620 share token he will get back [ 20000,600,20 ] amounts of underlyin tokens. So you can see clearly user loss
the funds.





     


