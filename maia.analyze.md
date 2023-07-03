1. Analysis of the codebase (What's unique? What's using existing patterns?)

During this audit process gained a lot of new things such as uniswapv3 pool, how to Calculate the price of assets from
sqrtPriceX96 , how  sqrtPriceX96 related to tick and vise versa & uniswapV3 slot0 manipulation.

Also during the audit, we were able to find 1st depositor attack vectors, invalid comparisons, not properly removing the array
elements (parallel storing), decimal errors when normalizing & denormalizing, Significant round-off errors when depositing like USDC, delegatecall errors & more. 

 We identified certain issues that were not included in any of the reports in this audit. 

ERC4626MultiToken.sol : Here there is an issue that user being able to deposit underlying assets & if he redeems it he will be
getting fewer amounts of token compared with what he deposited. This bug is reported & mitigation steps are also there. Another
mitigation step would be enforcing the user to send only multiple of weights. If the user sends different amounts(than multiple of
weights) set it to revert.

Please make sure that if any relayer event is associated with this make sure to provide enough gas to execute the transaction in
order to avoid gas griefing. (We are unable to check this with the current time limitation. )

For more reading: https://www.rareskills.io/post/solidity-gasleft


