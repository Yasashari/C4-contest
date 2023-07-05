## Significant roundoff error in depositToPort function (ArbitrumBranchBridgeAgent.sol )

This issue is caused with different decimals than 18. As an Eg USDC, WBTC. Let's consider the USDC as the case scenario. If User
deposit USDC into the depositToPort function, He needs to enter the amount as at least 1Million USDC (underlying) in order to mint
1 wei of localtoken. But here actually user sends the 1 wei of USDC (10^-6). So user is confused what's going with there since he
needs to enter the values as a minimum of 1Million USDC, but the actual sending amount is 1 wei of USDC.

## Proof of Concept

```solidity
    function depositToPort(address underlyingAddress, uint256 amount) external payable lock {
        IArbPort(localPortAddress).depositToPort(
            msg.sender, msg.sender, underlyingAddress, _normalizeDecimals(amount, ERC20(underlyingAddress).decimals())
        );
    }
```

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/ArbitrumBranchBridgeAgent.sol#L102C5-L106C6

```solidity
    function depositToPort(address _depositor, address _recipient, address _underlyingAddress, uint256 _deposit)
        external
        requiresBridgeAgent
    {
        address globalToken = IRootPort(rootPortAddress).getLocalTokenFromUnder(_underlyingAddress, localChainId);
        if (globalToken == address(0)) revert UnknownUnderlyingToken();

        _underlyingAddress.safeTransferFrom(_depositor, address(this), _deposit);

        IRootPort(rootPortAddress).mintToLocalBranch(_recipient, globalToken, _deposit);
    }
```

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/ArbitrumBranchPort.sol#L45C1-L55C6

User need to enter the amount as more than 1Million USDC in to depositToPort function.
But the actual amount sent is only 10^-6 of USDC.

He will be minted 1wei of local token. Here root cause of this issue is, not using the correct equation for normalize &
denormalize functions as well as needed to use the \_normalizeDecimals function between the asset amount & minting token amount.
But here initially amount is normalized then transfer the undelying token & minting the same amount of local token. Borth reasons
caused an error.

## Tools Used

Manual Auditing

## Recommended Mitigation Steps

There are 2 sets of mitigation steps here.

Mitigation 1:

Remove the normalize & denormalize between the assets to minting amount. Then consider the apply same decimals to local token.

Mitigation 2:

Correct normalize/ denormalize functions as well as depositToPort & withdrawFromPort functions given below.

```solidity
    function depositToPort(address underlyingAddress, uint256 amount) external payable lock {
        IArbPort(localPortAddress).depositToPort(
            // @audit correction.
            msg.sender, msg.sender, underlyingAddress, amount
        );
    }
```

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/ArbitrumBranchBridgeAgent.sol#L102C5-L106C6

```solidity
    function _normalizeDecimals(uint256 _amount, uint8 _decimals) internal pure returns (uint256) {
        // @audit correction.
        return _decimals == 18 ? _amount : _amount * 1 ether / (10 ** _decimals);
    }
```

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/BranchBridgeAgent.sol#L1340C2-L1342C6

```solidity
    function _denormalizeDecimals(uint256 _amount, uint8 _decimals) internal pure returns (uint256) {
        // @audit correction.
        return _decimals == 18 ? _amount : _amount * (10 ** _decimals) / 1 ether;
    }
```

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/BranchPort.sol#L388C1-L391C1

```solidity
    function depositToPort(address _depositor, address _recipient, address _underlyingAddress, uint256 _deposit)
        external
        requiresBridgeAgent
    {
        address globalToken = IRootPort(rootPortAddress).getLocalTokenFromUnder(_underlyingAddress, localChainId);
        if (globalToken == address(0)) revert UnknownUnderlyingToken();

        // @audit correction.
        _underlyingAddress.safeTransferFrom(_depositor, address(this), _normalizeDecimals(amount, ERC20(underlyingAddress).decimals()));

        IRootPort(rootPortAddress).mintToLocalBranch(_recipient, globalToken, _deposit);
    }

    ///@inheritdoc IArbitrumBranchPort
    function withdrawFromPort(address _depositor, address _recipient, address _globalAddress, uint256 _deposit)
        external
        requiresBridgeAgent
    {
        if (!IRootPort(rootPortAddress).isGlobalToken(_globalAddress, localChainId)) {
            revert UnknownToken();
        }

        address underlyingAddress = IRootPort(rootPortAddress).getUnderlyingTokenFromLocal(_globalAddress, localChainId);

        if (underlyingAddress == address(0)) revert UnknownUnderlyingToken();

        IRootPort(rootPortAddress).burnFromLocalBranch(_depositor, _globalAddress, _deposit);

        underlyingAddress.safeTransfer(_recipient, _denormalizeDecimals(_deposit, ERC20(underlyingAddress).decimals()));
    }
```

https://github.com/code-423n4/2023-05-maia/blob/54a45beb1428d85999da3f721f923cbf36ee3d35/src/ulysses-omnichain/ArbitrumBranchPort.sol#L45C1-L73C6
