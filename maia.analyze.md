1. Analysis of the codebase (What's unique? What's using existing patterns?)

During the audit, we identified certain issues that were not included in any of the reports.

ERC4626MultiToken.sol : Here there is an issue that user able to deposit underlyine assets & if he reddem it he will be getting less amounts of token comared with what he deposited. This bug is reported & mitigation steps also there. Another mitigation step would be enforce user to send only the multiple of weights . If user send different amounts(than multiple of weights) then reverted.    
