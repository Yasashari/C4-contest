## Summary
call/delegatecall/staticcall does not check the contract existence. Since call/delegatecall/staticcall returns true even if the contracts which are not not existing. 

## Vulnerability Detail

Low-level calls call/delegatecall/staticcall return true even if the account called is non-existent (per EVM design). Solidity
documentation warns: "The low-level functions call, delegatecall and staticcall return true as their first return value if the
account called is non-existent, as part of the design of the EVM. Account existence must be checked prior to calling if needed.”

There are few cases used the call/staticcall in the below contracts without checking the contract existence. 


## Impact
Here it checked the address for nonzero but still low-level calls return true nonzero(address) nonexisting contracts. Checking
only retune value success is not enough to evaluate transactions done correctly. So It should be checked for contract
existence as well in order to confirm the transaction occurred correctly. 




## Code Snippet

       38              (bool success,) = address(vault).staticcall(abi.encodeWithSignature(funcSelector, poolId, fromAddress));
       39             if (!success) revert DataMismatch("fromAddress");
       40     
       41             (success,) = address(vault).staticcall(abi.encodeWithSignature(funcSelector, poolId, swapData.token));
       42             if (!success) revert DataMismatch("toAddress");

https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/swapper/adapters/BalancerV2Swap.sol#L38C2-L41C111


       41               (bool success,) = AGGREGATOR.call(swapParams.data);

https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/liquidation/BaseAsyncSwapper.sol#L41


https://docs.soliditylang.org/en/v0.8.6/control-structures.html#error-handling-assert-require-revert-and-exceptions

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

Check the  account.code.length > 0 . So add require statement and isContract function as below. 
For BaseAsyncSwapper.sol contract, 


    
     ++          require(isContract(AGGREGATOR), "Address: call to non-contract");
     41          (bool success,) = AGGREGATOR.call(swapParams.data);
  



     ++     function isContract(address account) internal view returns (bool) {
     ++             // This method relies on extcodesize/address.code.length, which returns 0
     ++             // for contracts in construction, since the code is only stored at the end
     ++             // of the constructor execution.
     ++     
     ++             return account.code.length > 0;
     ++         }

Same mitigation can be used for BalancerV2Swap.sol as well. 





     

     

