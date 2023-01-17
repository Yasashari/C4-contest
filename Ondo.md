## CHAINLINK'S MULTISIGS CAN IMMEDIATELY BLOCK ACCESS TO PRICE FEEDS AT WILL. 

The multisigs of Chainlink can restrict access to pricing feeds. Therefore, it is safer to query Chainlink pricing feeds using a defensive strategy with Solidity's
try/catch structure to avoid denial of service problems. In this approach, even if the call to the price feed fails, the caller contract is still in charge and has the
ability to safely and explicitly manage any failures.

Proof of Concept

    108   price = getChainlinkOraclePrice(fToken);

https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol

Below function is not solve above issue because it returns minimum of given two prices. 

    114   if (fTokenToUnderlyingPriceCap[fToken] > 0) {
    115   price = _min(price, fTokenToUnderlyingPriceCap[fToken]);
    116   }
    
 Tools Used
    Vs code
 
 Recommended Mitigation Steps
    Refer this article on this issue. https://blog.openzeppelin.com/secure-smart-contract-guidelines-the-dangers-of-price-oracles/
    use try/catch with latestRoundData() instead of calling it directly. In a scenario where the call reverts, the catch block can be used to call a
    fallback oracle or handle the error in any other suitable way. So Update [function getChainlinkOraclePrice](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol#L277)
    


