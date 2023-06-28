## Delegatecall dost check the contract existence . Since delegatecall returns true even if the contract not existed.

Low-level calls call/delegatecall/staticcall return true even if the account called is non-existent (per EVM design). Solidity documentation warns: "The low-level functions call, delegatecall and staticcall return true as their first return value if the account called is non-existent, as part of the design of the EVM. Account existence must be checked prior to calling if needed.”

Here delegatecall will return true even if the implementation contract doesn't exist at any incorrect-but-not-zero address, e.g. EOA address, used during initialization by accident. Then delegatecall will return true & trasancion done successfully. But still there is a issue. 

## Proof of Concept

     59       function delegateTo(address callee, bytes memory data) internal {
     60           (bool success, bytes memory returnData) = callee.delegatecall(data);
     61           assembly {
     62               if eq(success, 0) { revert(add(returnData, 0x20), returndatasize()) }
     63           }
     64       }

https://github.com/code-423n4/2023-05-maia/blob/main/src/governance/GovernorBravoDelegator.sol#L60

     20      delegateTo(
                    implementation_,
                    abi.encodeWithSignature(
                        "initialize(address,address,uint256,uint256,uint256)",
                        timelock_,
                        govToken_,
                        votingPeriod_,
                        votingDelay_,
                        proposalThreshold_
                    )
                );
        
                _setImplementation(implementation_);
        
                admin = admin_;
            }
        
            /**
             * @notice Called by the admin to update the implementation of the delegator
             * @param implementation_ The address of the new implementation for delegation
             */
            function _setImplementation(address implementation_) public {
                require(msg.sender == admin, "GovernorBravoDelegator::_setImplementation: admin only");
                require(
                    implementation_ != address(0), "GovernorBravoDelegator::_setImplementation: invalid implementation address"
                );
        
                address oldImplementation = implementation;
     48           implementation = implementation_;

delegatecall will return true & trasancion can be completed successfully. But trasanction can be completed successfully with even
with the non existant of implementation_ address. So it casuse a issue. 

https://github.com/code-423n4/2023-05-maia/blob/main/src/governance/GovernorBravoDelegator.sol#L20-L51

https://docs.soliditylang.org/en/v0.8.6/control-structures.html#error-handling-assert-require-revert-and-exceptions

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

Check the  callee.code.length > 0 . So add require statement dn isContract function as below. 

     59       function delegateTo(address callee, bytes memory data) internal {
     ++          require(isContract(callee), "Address: call to non-contract");
     60           (bool success, bytes memory returnData) = callee.delegatecall(data);
     61           assembly {
     62               if eq(success, 0) { revert(add(returnData, 0x20), returndatasize()) }
     63           }
     64       }


and add this function

     ++     function isContract(address account) internal view returns (bool) {
     ++             // This method relies on extcodesize/address.code.length, which returns 0
     ++             // for contracts in construction, since the code is only stored at the end
     ++             // of the constructor execution.
     ++     
     ++             return account.code.length > 0;
     ++         }







     

     
