## CHAINLINK'S MULTISIGS CAN IMMEDIATELY BLOCK ACCESS TO PRICE FEEDS AT WILL. 

The multisigs of Chainlink can restrict access to pricing feeds. Therefore, it is safer to query Chainlink pricing feeds using a defensive strategy with Solidity's
try/catch structure to avoid denial of service problems. In this approach, even if the call to the price feed fails, the caller contract is still in charge and has the
ability to safely and explicitly manage any failures.

Proof of Concept

    108   price = getChainlinkOraclePrice(fToken);

https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol#L108

Below function is not solve above issue because it returns minimum of given two prices. 

    114   if (fTokenToUnderlyingPriceCap[fToken] > 0) {
    115   price = _min(price, fTokenToUnderlyingPriceCap[fToken]);
    116   }
    
https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol#L114
    
 Tools Used
    Vs code
 
 Recommended Mitigation Steps
    Refer this article on this issue. https://blog.openzeppelin.com/secure-smart-contract-guidelines-the-dangers-of-price-oracles/ .
    Use try/catch with latestRoundData() instead of calling it directly. In a scenario where the call reverts, the catch block can be used to call a
    fallback oracle or handle the error in any other suitable way. So Update [function getChainlinkOraclePrice](https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/OndoPriceOracleV2.sol#L277) in order to tackle above issue. 
    
## DOS IN UTILIZATIONRATE 
    utilizationrate = borrows / (cash + borrows - reserves). if cash+ borrows ≈ reserves this goes to infinity so that utilizationrate reverts. 
    Also if cash + borrows < reserves same effet caused. 
    If utilizationrate reverts theser functions are also reverts.
    126     function getBorrowRate(
    152     function getSupplyRate(
    
 Proof of Concept
 
     116    return borrows.mul(1e18).div(cash.add(borrows).sub(reserves));
 https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/JumpRateModelV2.sol#L116
 
  Tools Used
    Vs code
 
 Recommended Mitigation Steps
 
    add require statement in function utilizationRate() on  https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/JumpRateModelV2.sol#L116
        require( cash + borrows > reserves )
        
##  FRONTRUN IS POSSIBLE WHEN CHANGING APPROVE AMOUNT
    when changing the approved amount frontrun is possible. So its safer to inherit openzeppling SafeERC20 lib. 

Proof of Concept
    
    182 function approve(
https://github.com/code-423n4/2023-01-ondo/blob/main/contracts/lending/tokens/cToken/CTokenModified.sol#182

 Tools Used
    Vs code
 
 Recommended Mitigation Steps
    
    when increasing or decreaseing approve amount its safer to use safeIncreaseAllowance and safeDecreaseAllowance on safeERC20 lib.
    https://github.com/OpenZeppelin/openzeppelin-contracts/blob/566a774222707e424896c0c390a84dc3c13bdcb2/contracts/token/ERC20/utils/SafeERC20.sol#L59
    https://github.com/OpenZeppelin/openzeppelin-contracts/blob/566a774222707e424896c0c390a84dc3c13bdcb2/contracts/token/ERC20/utils/SafeERC20.sol#L68
    

    
    
 
 
 
 
     
    

