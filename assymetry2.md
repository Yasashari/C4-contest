# Function withdraw may be reverted due to hardcoded slippage during market turbulence conditions.

WstEth.sol has a hardcoded maxSlipage as 1%. It could revert the withdraw function during sudden price crashes.

## Proof of Concept

    35  maxSlippage = (1 * 10 ** 16); // 1%

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol#L35


    60   uint256 minOut = (stEthBal * (10 ** 18 - maxSlippage)) / 10 ** 18;

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol#L60

Due to hard coded maxSlippage owner unable to define minOut so that its a constant (relative to the input parameter amount) , eventually Owner
unable to perform the withdraw function during price crash conditions. 

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

 Remove the hard coded maxSlippage & let owner to  determine the maximum slippage he's willing to take with the current market condition as a
 input parameter for the withdraw function. 
 
