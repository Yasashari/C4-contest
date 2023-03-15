# Significant roundoff error in bonusPoints calculation

If some user deposit anything less than 2 Bytes tokens then bonusPoints going to be zero. Significant round off error occurred here. There are two instances occured as shown below. 

Proof of Concept

    1077  uint256 bonusPoints = (amount * 100 / _BYTES_PER_POINT);
    
    1098  uint256 bonusPoints = (amount * 100 / _BYTES_PER_POINT);
    

https://github.com/code-423n4/2023-03-neotokyo/blob/main/contracts/staking/NeoTokyoStaker.sol#L1077
https://github.com/code-423n4/2023-03-neotokyo/blob/main/contracts/staking/NeoTokyoStaker.sol#L1098


lets consider this senario.

    203   uint256 constant private _BYTES_PER_POINT = 200 * 1e18;

    User stake 1.9999 * 1e18 Bytes tokens. 
    
    bonusPoints =  1.9999 * 1e18 * 100 /  200 * 1e18 
    bonusPoints = 0
    
# Tools Used
    Vs code

# Recommended Mitigation Steps

  Here there are two set of mitigation are possible. 
  
  
  Points for staking S1 tokens, S2 tokens  and LP tokens as follows.
  
      968   citizenStatus.points =
				identityPoints * vaultMultiplier * timelockMultiplier /
				_DIVISOR / _DIVISOR;
        
      
      1022    citizenStatus.points = 100 * timelockMultiplier / _DIVISOR;
      
      1155    uint256 points = amount * 100 / 1e18 * timelockMultiplier / _DIVISOR;
      
and Bonus point

      1077  uint256 bonusPoints = (amount * 100 / _BYTES_PER_POINT);
      
https://github.com/code-423n4/2023-03-neotokyo/blob/main/contracts/staking/NeoTokyoStaker.sol#L968
https://github.com/code-423n4/2023-03-neotokyo/blob/main/contracts/staking/NeoTokyoStaker.sol#L1022
https://github.com/code-423n4/2023-03-neotokyo/blob/main/contracts/staking/NeoTokyoStaker.sol#L1155
https://github.com/code-423n4/2023-03-neotokyo/blob/main/contracts/staking/NeoTokyoStaker.sol#L1077

When calculating above points multiply each point by  correction factor (1e18)  and get the total point then devided by correction
factor. 

      968   citizenStatus.points =
				identityPoints * vaultMultiplier * timelockMultiplier /
				_DIVISOR / _DIVISOR * 1e18 ; 
        
      
      1022    citizenStatus.points = 100 * timelockMultiplier / _DIVISOR * 1e18 ;
      
      1155    uint256 points = amount * 100 / 1e18 * timelockMultiplier / _DIVISOR * 1e18;
 
      1388    uint256 share = points * _PRECISION / pool.totalPoints * totalReward / 1e18 ;
      
 
Another option is reverted anything less than 2 Bytes token deposits using revert statement.  


    
      
 
   
  

    
    
  
    
    

    





