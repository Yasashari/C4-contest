1. Analysis of the codebase (What's unique? What's using existing patterns?)

During this audit process gained a lot of new things such as uniswapv3 pool  , how to Calculate the price of assets from
sqrtPriceX96 , how  sqrtPriceX96 related to tick and vise versa & uniswapV3 slot0 manipulation.

Also during the audit we were able to find 1st depositor attack vectors , invalid comparisons , not properly removing the array
elements (parallel storing) , decimal errors when normalizing & denormaling , Significant round off errors when depositing like USDC , 



During the audit, we identified certain issues that were not included in any of the reports.

ERC4626MultiToken.sol : Here there is an issue that user able to deposit underlyine assets & if he reddem it he will be getting less amounts of token comared with what he deposited. This bug is reported & mitigation steps also there. Another mitigation step would be enforce user to send only the multiple of weights . If user send different amounts(than multiple of weights) then reverted.


