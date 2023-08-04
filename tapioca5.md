##  _totalBorrow.elastic is increased number of the accrue() function called by the users. So attacker is able to liquidate the users by frequently calling accrue() function. 

 _totalBorrow.elastic can have different values if users call this function in different time intervals. i.e.  _totalBorrow.elastic
 changing with the number of calls accrue() function by users. If someone called accrue() in 5 seconds interval  there is a one
 value for _totalBorrow.elastic & it's different with if someone called that function in 100 seconds interval . Also, 5 secons
 interval value is greater than 100 seconds interval. Finally, It's affected the user liquidation as well.

 ### Proof of Concept

        512                function _accrue() internal override {
                            IBigBang.AccrueInfo memory _accrueInfo = accrueInfo;
                            // Number of seconds since accrue was called
                            uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
                            if (elapsedTime == 0) {
                                return;
                            }
                            //update debt rate
                            uint256 annumDebtRate = getDebtRate();
                            _accrueInfo.debtRate = uint64(annumDebtRate / 31536000); //per second
                    
                            _accrueInfo.lastAccrued = uint64(block.timestamp);
                    
                            Rebase memory _totalBorrow = totalBorrow;
                    
                            uint256 extraAmount = 0;
                    
                            // Calculate fees
         530                    extraAmount =
                                (uint256(_totalBorrow.elastic) *
                                    _accrueInfo.debtRate *
                                    elapsedTime) /
                                1e18;
                            _totalBorrow.elastic += uint128(extraAmount);
                    
                            totalBorrow = _totalBorrow;
                            accrueInfo = _accrueInfo;
                    
                            emit LogAccrue(extraAmount, _accrueInfo.debtRate);
          541               }
        
https://github.com/Tapioca-DAO/tapioca-bar-audit/blob/2286f80f928f41c8bc189d0657d74ba83286c668/contracts/markets/bigBang/BigBang.sol#L512C1-L542C1


when calculating the extraAmount (line 530) you can see it's multiplying by the previous _totalBorrow.elastic by the elapsed
time. It acts like a compound interesting. If someone called this function frequently _totalBorrow.elastic value drastically
increased. 


          232                  function accrue() public {
                                 _accrue();
          234                  }

https://github.com/Tapioca-DAO/tapioca-bar-audit/blob/2286f80f928f41c8bc189d0657d74ba83286c668/contracts/markets/bigBang/BigBang.sol#L232C5-L234C6

An attacker is able to call accrue() function frequently such that user get liquidated.

          414                   return
                                yieldBox.toAmount(
                                    collateralId,
                                    collateralShare *
                                        (EXCHANGE_RATE_PRECISION / FEE_PRECISION) *
                                        collateralizationRate,
                                    false
                                ) >=
                                // Moved exchangeRate here instead of dividing the other side to preserve more precision
                                (borrowPart * _totalBorrow.elastic * _exchangeRate) /
          424                   _totalBorrow.base;

https://github.com/Tapioca-DAO/tapioca-bar-audit/blob/2286f80f928f41c8bc189d0657d74ba83286c668/contracts/markets/Market.sol#L423C27-L423C47

This inequality determines if a user is solvent or not. An attacker able to set the high value to _totalBorrow.elastic such that
above inequality returns false then the user liquidating here. 




          668                      if (!_isSolvent(user, _exchangeRate)) {
                                                liquidatedCount++;
                                                _liquidateUser(
                                                    user,
                                                    maxBorrowParts[i],
                                                    swapper,
                                                    _exchangeRate,
                                                    swapData
                                                );
          677                                  }

          
https://github.com/Tapioca-DAO/tapioca-bar-audit/blob/2286f80f928f41c8bc189d0657d74ba83286c668/contracts/markets/bigBang/BigBang.sol#L668

### Tools Used
Vs code

###  Recommended Mitigation Steps

Need to rewrite the _accrue() function ( extraAmount) such that it's not affecting the previous state of _totalBorrow.elastic
value. Or else elapsed time should be considered differently. The issue is caused due to elapsed time & the way of using
_totalBorrow.elastic in extraAmount calculation. 



          


        

 


