## amount0Min and amount1Min are hardcoded to zero. Front running & sandwich opportunities. 

amount0Min and amount1Min are hardcoded to zero in rerange() function in the PoolActions.sol contract . So that attackers have the
front running & sandwich opportunities. 

## Proof of Concept

     73               (tokenId, liquidity, amount0, amount1) = nonfungiblePositionManager.mint(
                              INonfungiblePositionManager.MintParams({
                                  token0: address(actionParams.token0),
                                  token1: address(actionParams.token1),
                                  fee: poolFee,
                                  tickLower: tickLower,
                                  tickUpper: tickUpper,
                                  amount0Desired: balance0,
                                  amount1Desired: balance1,
                                  amount0Min: 0,
                                  amount1Min: 0,
                                  recipient: address(this),
                                  deadline: block.timestamp
                              })
    87                        );

https://github.com/code-423n4/2023-05-maia/blob/main/src/talos/libraries/PoolActions.sol#L82C1-L83C31

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

Use amount0Min & amount1Min as user input parameters so that (Not hard cording to some value) anyone who using this function can
set those values accordingly at the time of their execution. 







    




