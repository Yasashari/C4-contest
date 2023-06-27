## Underflow due to incorrect comparison

leftOverBandwidth is underflowed due to incorrect comparison of oldTotalWeights and newTotalWeights. 

### Proof of Concept

    247         uint256 leftOverBandwidth;
    248        
    249                BandwidthState storage poolState = bandwidthStateList[poolIndex];
    250                poolState.weight = weight;
    251        
    252                if (oldTotalWeights > newTotalWeights) {
    253                    for (uint256 i = 1; i < bandwidthStateList.length;) {
    254                        if (i != poolIndex) {
    255                            uint256 oldBandwidth = bandwidthStateList[i].bandwidth;
    256                            if (oldBandwidth > 0) {
    257                                bandwidthStateList[i].bandwidth =
    258                                    oldBandwidth.mulDivUp(oldTotalWeights, newTotalWeights).toUint248();
    259        
    260                                leftOverBandwidth += oldBandwidth - bandwidthStateList[i].bandwidth;
    261                            }
    262                        }


https://github.com/code-423n4/2023-05-maia/blob/main/src/ulysses-amm/UlyssesPool.sol#L260


Here initially consider this check oldTotalWeights > newTotalWeights, and calculate the 

        bandwidthStateList[i].bandwidth =
                                    oldBandwidth.mulDivUp(oldTotalWeights, newTotalWeights).toUint248();
                                    
Due to above condition , 

       oldBandwidth.mulDivUp(oldTotalWeights, newTotalWeights).toUint248()  > oldBandwidth
       
Its meaning , 

      bandwidthStateList[i].bandwidth > oldBandwidth

So eventually , 

      leftOverBandwidth += oldBandwidth - bandwidthStateList[i].bandwidth < 0 

 Initial value is leftOverBandwidth is zero. So leftOverBandwidth is going to be negative then its reverted.


### Tools Used

Vs code

### Recommended Mitigation Steps

Use

      leftOverBandwidth +=  bandwidthStateList[i].bandwidth - oldBandwidth ;  for line 260 

  
      
         

                                    


