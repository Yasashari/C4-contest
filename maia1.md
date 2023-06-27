## Incorrect use of address(this)
When deploying a new instance of UniswapV3Staker contract it should be passed the address of the uniswapV3GaugeFactory as a constructor argument.
So it should be used address(this). But here it's using this .

### Proof of Concept

 
     60       uniswapV3Staker = new UniswapV3Staker(
     61         _factory,
     62         _nonfungiblePositionManager,
     63         this,
     64         _bHermesBoost,
     65         52 weeks,
     66         address(_flywheelGaugeRewards.minter()),
     67         address(_flywheelGaugeRewards.rewardToken())
     68         );
     69       }


   https://github.com/code-423n4/2023-05-maia/blob/main/src/gauges/factories/UniswapV3GaugeFactory.sol#L63

### Tools Used
Vs code

### Recommended Mitigation Steps
Use address(this) instead of this in line 63. 

    

