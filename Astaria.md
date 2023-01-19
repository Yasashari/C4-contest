## DOS in claim function 

liquidationWithdrawRatio is the ratio of withdrawing to remaining LPs for the current epoch boundary. Definition sources are given below. 

Source:  https://docs.astaria.xyz/docs/smart-contracts/withdrawproxy

Source: https://github.com/code-423n4/2023-01-astaria/blob/main/src/interfaces/IWithdrawProxy.sol#L28

If liquidationWithdrawRatio is above the 1e18 then (1e18 - s.withdrawRatio) is negative and so claim function revert. 

Proof of Concept

Lets consider withdrawing amount is 100.1WETH and remaining LPs amount is 100 wei 
liquidationWithdrawRatio = 100.1e18/100 = 1.001e18 

i.e. this modelling not working when LPs withdraw approximately their total liquidy at once.


    260   (s.expected - balance).mulWadDown(1e18 - s.withdrawRatio)

https://github.com/code-423n4/2023-01-astaria/blob/main/src/WithdrawProxy.sol#L260

    264   (balance - s.expected).mulWadDown(1e18 - s.withdrawRatio)

https://github.com/code-423n4/2023-01-astaria/blob/main/src/WithdrawProxy.sol#L264

    281   ERC20(asset()).safeTransfer(VAULT(), balance);
    
https://github.com/code-423n4/2023-01-astaria/blob/main/src/WithdrawProxy.sol#L281

Tools Used 

Vs code


Recommended Mitigation Steps

Define another set of equations when (1e18 - s.withdrawRatio) becomes negative in if statement. Here consider the (s.withdrawRatio - 1e18) and need to do mathematical
modelling respectively. 


## NO TRANSFER OWNERSHIP PATTERN

if owner enter wrong account address here then contract is in a risk.

    95  function transferOwnership(address newOwner) public virtual requiresAuth {
    
    97  s.owner = newOwner;

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AuthInitializable.sol#L95

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AuthInitializable.sol#L97

## Tools Used
    VS Code 

## Recommended Mitigation Steps

     To avoid that one setup two step process transfer ownership and accept it by new owner.
     
     
 ## QA Report
 
 #### External & Public Functions should use mixedCase withot underscore
 
Affected Source Code

https://github.com/code-423n4/2023-01-astaria/blob/main/src/WithdrawVaultBase.sol#L26

https://github.com/code-423n4/2023-01-astaria/blob/main/src/WithdrawVaultBase.sol#L30

https://github.com/code-423n4/2023-01-astaria/blob/main/src/WithdrawVaultBase.sol#L38

https://github.com/code-423n4/2023-01-astaria/blob/main/src/WithdrawVaultBase.sol#L42

https://github.com/code-423n4/2023-01-astaria/blob/main/src/LienToken.sol#377

https://github.com/code-423n4/2023-01-astaria/blob/main/src/LienToken.sol#L381

https://github.com/code-423n4/2023-01-astaria/blob/main/src/CollateralToken.sol#L105

https://github.com/code-423n4/2023-01-astaria/blob/main/src/ClearingHouse.sol#L43

https://github.com/code-423n4/2023-01-astaria/blob/main/src/ClearingHouse.sol#L47

https://github.com/code-423n4/2023-01-astaria/blob/main/src/ClearingHouse.sol#L51



#### Remove assembly for future updates
its better not to use assembly because it reduce readability & future updatability of the code even though assembly reduce gas.

Recommendation 

Consider removeing all assembly code and re-implement them in Solidity to make the code significantly more clean.

https://github.com/code-423n4/2023-01-astaria/blob/main/src/BeaconProxy.sol#L30


#### Revert without having any error message

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L65

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L71



## Gas Report

#### Use Custom Errors
Custom errors are more gas efficient than using require with a string explanation. So ideally you'd always use this over require.

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L65

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L71

#### Functions guaranteed to revert when called by normal users can be marked payable

if a function modifier such as onlyOwner is used, the function will revert if a normal user tries to pay the function. Marking the function as payable will lower the
gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L70


#### Loop optimization 

if your looping array get array length into cache and use UNCHECKED{++I} . Read more..https://hackmd.io/@totomanov/gas-optimization-loops

#### Empty blocks should be removed or emit something

https://github.com/code-423n4/2023-01-astaria/blob/main/src/BeaconProxy.sol#L87







    
    














