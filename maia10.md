## depositToPort function having substantial roundoff in ArbitrumBranchBridgeAgent.sol 
This issue is caused with different decimals than 18. As a Eg USDC , WBTC . Let's consider the USDC as the case scenario. If User
deposit USDC in to depositToPort funciton , He need to enter the amount as atleast 1Million USDC (underlyin) in oder to mint 1 wei of
localtoken.  But here actually user send the 1 wei of USDC (10^-6).So user is confused whats going with there since he need to enter
the values as a minimum of 1Million USDC, but the actual sending amount is 1 wei of USDC. 

## Proof of Concept

      102      function depositToPort(address underlyingAddress, uint256 amount) external payable lock {
                  IArbPort(localPortAddress).depositToPort(
                      msg.sender, msg.sender, underlyingAddress, _normalizeDecimals(amount, ERC20(underlyingAddress).decimals())
                  );
     107           }

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/ArbitrumBranchBridgeAgent.sol#L102C5-L106C6


     45            function depositToPort(address _depositor, address _recipient, address _underlyingAddress, uint256 _deposit)
                    external
                    requiresBridgeAgent
                {
                    address globalToken = IRootPort(rootPortAddress).getLocalTokenFromUnder(_underlyingAddress, localChainId);
                    if (globalToken == address(0)) revert UnknownUnderlyingToken();
            
                    _underlyingAddress.safeTransferFrom(_depositor, address(this), _deposit);
            
                    IRootPort(rootPortAddress).mintToLocalBranch(_recipient, globalToken, _deposit);
    55            }      

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/ArbitrumBranchPort.sol#L45C1-L55C6



     






