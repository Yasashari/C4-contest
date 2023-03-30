# Not defining deadline in ExactInputSingleParams 


## Proof of Concept

      177        uint256 amountSwapped = swapExactInputSingleHop(
      178                        W_ETH_ADDRESS,
      179                        rethAddress(),
      180                        500,
      181                        msg.value,
      182                        minOut
      183                    );



https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#[L177,L183]
