# Not defining deadline in ExactInputSingleParams 

To execute the swap function, its needed to define necessary swap data for ExactInputSingleParams struct. 

![image](https://user-images.githubusercontent.com/118436384/228822051-b5f1e04b-eba8-4c57-a6b8-92ecc8596ebc.png)


Source : https://docs.uniswap.org/contracts/v3/reference/periphery/interfaces/ISwapRouter

Source : https://docs.uniswap.org/contracts/v3/guides/swaps/single-swaps


## Proof of Concept

      177        uint256 amountSwapped = swapExactInputSingleHop(
      178                        W_ETH_ADDRESS,
      179                        rethAddress(),
      180                        500,
      181                        msg.value,
      182                        minOut
      183                    );



https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#[L177,L183]


      91      ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
      92                  .ExactInputSingleParams({
      93                      tokenIn: _tokenIn,
      94                      tokenOut: _tokenOut,
      95                      fee: _poolFee,
      96                      recipient: address(this),
      97                      amountIn: _amountIn,
      98                      amountOutMinimum: _minOut,
      99                      sqrtPriceLimitX96: 0
      100                  });
      101              amountOut = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(params);

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#[L91,L101]

Here you can see that deadline parameter has not been defined so that it could finally revert the swap.

## Tools Used

Manual Auditing

### Recommended Mitigation Steps

Add the deadline: block.timestamp as shown below.

      91      ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
      92                  .ExactInputSingleParams({
      93                      tokenIn: _tokenIn,
      94                      tokenOut: _tokenOut,
      95                      fee: _poolFee,
      96                      recipient: address(this),
      +                        deadline: block.timestamp,
      97                      amountIn: _amountIn,
      98                      amountOutMinimum: _minOut,
      99                      sqrtPriceLimitX96: 0
      100                  });
      101              amountOut = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(params);
      
https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#[L91,L101]

Also its needed to change the ISwapRouter interface ExactInputSingleParams struct accordingly. Add the  deadline: block.timestamp as shown
below.

       5         struct ExactInputSingleParams {
       6             address tokenIn;
       7             address tokenOut;
       8             uint24 fee;
       9             address recipient;
       +              deadline: block.timestamp,
      10              uint amountIn;
      11              uint amountOutMinimum;
      12              uint160 sqrtPriceLimitX96;
      13          }


https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/ISwapRouter.sol#[L5,L13]



