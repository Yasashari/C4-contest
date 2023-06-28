## Delegatecall dost check the contract existence . Since delegatecall return true even if the contract not existed.

Low-level calls call/delegatecall/staticcall return true even if the account called is non-existent (per EVM design).
Solidity documentation warns: "The low-level functions call, delegatecall and staticcall return true as their first return value
if the account called is non-existent, as part of the design of the EVM. Account existence must be checked prior to calling if needed.”


