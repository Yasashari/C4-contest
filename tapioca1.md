# computeSGLPoolWeights() eventually revert due to block gas limit

computeSGLPoolWeights() calculates the  total pool weight of all active singularity markets. It iterates all the active
markets(unbound loop) so that sooner or later it will exceed the block gas limit. 

## Proof of Concept

           336         function _computeSGLPoolWeights() internal view returns (uint256) {
           337             uint256 total;
           338             uint256 len = singularities.length;
           339             for (uint256 i = 0; i < len; i++) {
           340                 total += activeSingularities[sglAssetIDToAddress[singularities[i]]]
           341                     .poolWeight;
           342             }
           343     
           344             return total;
           345         }

https://github.com/Tapioca-DAO/tap-token-audit/blob/main/contracts/options/TapiocaOptionLiquidityProvision.sol#L336C1-L345C6

## Tools Used
Vs code

## Recommended Mitigation Steps

Add some start and end indices to for loop & calculate total pool weight. 
