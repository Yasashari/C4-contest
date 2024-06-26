## DOS in claim function 

liquidationWithdrawRatio is the ratio of withdrawing to remaining LPs for the current epoch boundary. Definition sources are given below. 

Source:  https://docs.astaria.xyz/docs/smart-contracts/withdrawproxy

Source: https://github.com/code-423n4/2023-01-astaria/blob/main/src/interfaces/IWithdrawProxy.sol#L28

If liquidationWithdrawRatio is above the 1e18 then (1e18 - s.withdrawRatio) is negative and so claim function revert. 

Proof of Concept

Lets consider withdrawing amount is 100.1WETH and remaining LPs amount is 100 wei 
liquidationWithdrawRatio = 100.1e18/100 = 1.001e18 
So (1e18 - s.withdrawRatio) is negative 

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
 
 ## External & Public Functions should use mixedCase withot underscore
 
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

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaVaultBase.sol#L28

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaVaultBase.sol#L32

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaVaultBase.sol#L50

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaVaultBase.sol#L54

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaVaultBase.sol#L58

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaVaultBase.sol#L62

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L229

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L234

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L239

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L244

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L252

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L259

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L345

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AstariaRouter.sol#L352

https://github.com/code-423n4/2023-01-astaria/blob/main/src/interfaces/ICollateralToken.sol#L141

https://github.com/code-423n4/2023-01-astaria/blob/main/src/interfaces/IAstariaVaultBase.sol#L25

https://github.com/code-423n4/2023-01-astaria/blob/main/src/interfaces/IAstariaVaultBase.sol#L27

https://github.com/code-423n4/2023-01-astaria/blob/main/src/interfaces/IAstariaVaultBase.sol#L29

https://github.com/code-423n4/2023-01-astaria/blob/main/src/interfaces/IAstariaVaultBase.sol#L31

 For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#function-names)
    2. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)


## Remove assembly for future updates
its better not to use assembly because it reduce readability & future updatability of the code even though assembly reduce gas.

Recommendation 

Consider removeing all assembly code and re-implement them in Solidity to make the code significantly more clean.

https://github.com/code-423n4/2023-01-astaria/blob/main/src/BeaconProxy.sol#L30


## Revert without having any error message

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L65

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L71

## Constants should be named with all capital letters with underscores separating words.(For Internal or private constants it should be started with underscore
prefix)

https://github.com/code-423n4/2023-01-astaria/blob/main/src/AuthInitializable.sol#L26


For more read...
    1. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)




## Gas Report

## Use Custom Errors
Custom errors are more gas efficient than using require with a string explanation. So ideally you'd always use this over require.

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L65

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L71

## Functions guaranteed to revert when called by normal users can be marked payable

if a function modifier such as onlyOwner is used, the function will revert if a normal user tries to pay the function. Marking the function as payable will lower the
gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

https://github.com/code-423n4/2023-01-astaria/blob/main/src/Vault.sol#L70


## Empty blocks should be removed or emit something

https://github.com/code-423n4/2023-01-astaria/blob/main/src/BeaconProxy.sol#L87








    
    














