## Not able to transfer the tokens if user remove all the guages one by one.

User must have enough free boost to trasnfer the tokens. Thats meaning if user wants to transfer all the tokens this mapping needs
to be set to zero. (getUserBoost[msg.sender] = 0 ) . But it set to zero thorugh only this decrementAllGaugesAllBoost() function. If
user use decrementGaugeBoost function , decrementGaugeAllBoost or decrementGaugesBoostIndexed to remove the all the guages then
user cannot transfer the tokens since those functions not setting getUserBoost[msg.sender] mapping to zero.

## Proof of Concept
      
     312      function transfer(address to, uint256 amount) public override notAttached(msg.sender, amount) returns (bool) {
     313           return super.transfer(to, amount);
     314       }
https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-20/ERC20Boost.sol#L312C2-L314C6

      341       modifier notAttached(address user, uint256 amount) {
                    if (freeGaugeBoost(user) < amount) revert AttachedBoost();
                    _;
                }
      345      }
https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-20/ERC20Boost.sol#L341C1-L345C2

i.e. User needs to have enough free boost to trasnfer the tokens.

     81         function freeGaugeBoost(address user) public view returns (uint256) {
     82             return balanceOf[user] - getUserBoost[user];
     83         }
     
https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-20/ERC20Boost.sol#L81C1-L83C6

Lets think guage attach user

     116           function attach(address user) external {
                    if (!_gauges.contains(msg.sender) || _deprecatedGauges.contains(msg.sender)) {
                        revert InvalidGauge();
                    }
            
                    // idempotent add
                    if (!_userGauges[user].add(msg.sender)) revert GaugeAlreadyAttached();
            
     124               uint128 userGaugeBoost = balanceOf[user].toUint128();
            
                    if (getUserBoost[user] < userGaugeBoost) {
     127                   getUserBoost[user] = userGaugeBoost;
                        emit UpdateUserBoost(user, userGaugeBoost);
                    }
            
                    getUserGaugeBoost[user][msg.sender] =
                        GaugeState({userGaugeBoost: userGaugeBoost, totalGaugeBoost: totalSupply.toUint128()});
            
                    emit Attach(user, msg.sender, userGaugeBoost);
     135            }

Here you can see user balance set to the getUserBoost[user] mapping. 

https://github.com/code-423n4/2023-05-maia/blob/main/src/erc-20/ERC20Boost.sol#L116C1-L135C6

Now user detach that guage using this function . (But same thing could be happend if user use decrementGaugeAllBoost or
decrementGaugesBoostIndexed  fucntions)


    190                 function decrementGaugeAllBoost(address gauge) external {
                          require(_userGauges[msg.sender].remove(gauge));
                          delete getUserGaugeBoost[msg.sender][gauge];
                  
                          emit Detach(msg.sender, gauge);
    195                  }

    
    
Here  getUserBoost[user]  is not set to zero. Now if user transfer the tokens user will not be able transfer the tokens. 

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

You can call the  updateUserBoost(address user) inside of every attach , dettach guage fucntions as well as decrementgauge and
decrementboost functions unless _userGauges[user].values() not equal to zero. when removing the last guage set 
getUserBoost[user] = 0 .







     
     


