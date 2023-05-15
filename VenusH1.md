# riskFund.poolReserves return the token amount & its compaired with the USD value {units are not same}

poolReserves in RiskFund.sol returns the token amount. But its compaired with the incentivizedRiskFundBalance which is in USD value.

## Proof of Concept

     403              uint256 riskFundBalance = riskFund.poolReserves(comptroller);
                      uint256 remainingRiskFundBalance = riskFundBalance;
                      uint256 incentivizedRiskFundBalance = poolBadDebt + ((poolBadDebt * incentiveBps) / MAX_BPS);
                      if (incentivizedRiskFundBalance >= riskFundBalance) {
                          auction.startBidBps =
                              (MAX_BPS * MAX_BPS * remainingRiskFundBalance) /
                              (poolBadDebt * (MAX_BPS + incentiveBps));
                          remainingRiskFundBalance = 0;
                          auction.auctionType = AuctionType.LARGE_POOL_DEBT;
                          
 
 https://github.com/code-423n4/2023-05-venus/blob/main/contracts/Shortfall/Shortfall.sol#L406
 
 Here incentivizedRiskFundBalance in USD & riskFundBalance is token amount. 
 Due to this its always incentivizedRiskFundBalance < riskFundBalance. Hence else part executed.
 
    412            } else {
                          uint256 maxSeizeableRiskFundBalance = incentivizedRiskFundBalance;

                          remainingRiskFundBalance = remainingRiskFundBalance - maxSeizeableRiskFundBalance;
                          auction.auctionType = AuctionType.LARGE_RISK_FUND;
                          auction.startBidBps = MAX_BPS;
                      }

                      auction.seizedRiskFund = riskFundBalance - remainingRiskFundBalance;
                      auction.startBlock = block.number;
                      auction.status = AuctionStatus.STARTED;
                      auction.highestBidder = address(0);
                      
https://github.com/code-423n4/2023-05-venus/blob/main/contracts/Shortfall/Shortfall.sol#L412


Here auction.seizedRiskFund = riskFundBalance - remainingRiskFundBalance;
                            = riskFundBalance - ( remainingRiskFundBalance - maxSeizeableRiskFundBalance) 
                            = remainingRiskFundBalance - remainingRiskFundBalance + maxSeizeableRiskFundBalance
                            = maxSeizeableRiskFundBalance 
                            = incentivizedRiskFundBalance
                            = poolBadDebt + ((poolBadDebt * incentiveBps) / MAX_BPS)

This final value is in USD . This is the amount that going to be send after auction finished.

    241           if (auction.auctionType == AuctionType.LARGE_POOL_DEBT) {
                        riskFundBidAmount = auction.seizedRiskFund;
                    } else {
                        riskFundBidAmount = (auction.seizedRiskFund * auction.highestBidBps) / MAX_BPS;
                    }

                    uint256 transferredAmount = riskFund.transferReserveForAuction(comptroller, riskFundBidAmount);
                    IERC20Upgradeable(convertibleBaseAsset).safeTransfer(auction.highestBidder, riskFundBidAmount);
  
https://github.com/code-423n4/2023-05-venus/blob/main/contracts/Shortfall/Shortfall.sol#L248
                    
But on the other hand bidder needs to pay in tokens

      188                } else {
                                if (auction.highestBidder != address(0)) {
                                      erc20.safeTransfer(auction.highestBidder, auction.marketDebt[auction.markets[i]]);
                                  }

                                  erc20.safeTransferFrom(msg.sender, address(this), auction.marketDebt[auction.markets[i]]);
                                 }
https://github.com/code-423n4/2023-05-venus/blob/main/contracts/Shortfall/Shortfall.sol#L190

So Finally bidder get small amount of tokens compared to his spend for the bidding.

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

keep the incentivizedRiskFundBalance in terms of token value not USD value. 


                                 
                    

                            
                            
                            

                      
