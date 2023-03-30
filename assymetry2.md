# Hard-coded slippage may revert withdrawing during market turbulence

## Proof of Concept

    35  maxSlippage = (1 * 10 ** 16); // 1%

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol#L35
