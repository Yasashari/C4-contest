## ERC4626.sol contract not fully comply with EIP-4626's specification

ERC4626.sol is not EIP-4626 compliant, variation from the standard could break composability and potentially lead to loss of funds.

## Proof of Concept

    148          function maxDeposit(address) public view virtual returns (uint256) {
    149              return type(uint256).max;
    150          }
    151      
    152          /// @inheritdoc IERC4626
    153          function maxMint(address) public view virtual returns (uint256) {
    154              return type(uint256).max;
    155          }


https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-4626/ERC4626.sol#L148-L155

From the EIP-4626 method specifications (https://eips.ethereum.org/EIPS/eip-4626)

For maxDeposit:

MUST factor in both global and user-specific limits, like if deposits are entirely disabled (even temporarily) it MUST return 0.

For maxMint:

MUST factor in both global and user-specific limits, like if mints are entirely disabled (even temporarily) it MUST return 0.






