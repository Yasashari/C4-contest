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
     










