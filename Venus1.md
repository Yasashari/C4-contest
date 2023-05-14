# Borrow rate and supply rate are incorrect due to incorrect blocksPerYear value

This protocol is going to be deployed to BNB chain so its needed to calculate blocksPerYear relevant to BNB Smart Chain.
But here it has taken blocksPerYear relevant to the ethereum chain.

## Proof of Concept

      17  uint256 public constant blocksPerYear = 2102400;

https://github.com/code-423n4/2023-05-venus/blob/main/contracts/WhitePaperInterestRateModel.sol#L17

Here it should be blocksPerYear = 10512000 

Due to this incorrect value its caused a incorrect values for baseRatePerBlock & multiplierPerBlock

      37   baseRatePerBlock = baseRatePerYear / blocksPerYear;
      38    multiplierPerBlock = multiplierPerYear / blocksPerYear;
      
https://github.com/code-423n4/2023-05-venus/blob/main/contracts/WhitePaperInterestRateModel.sol#{L37,L38}

Its also affected to getBorrowRate & getSupplyRate functions as shown below.

      56    return ((ur * multiplierPerBlock) / BASE) + baseRatePerBlock;

https://github.com/code-423n4/2023-05-venus/blob/main/contracts/WhitePaperInterestRateModel.sol#L56

      74    uint256 borrowRate = getBorrowRate(cash, borrows, reserves);

https://github.com/code-423n4/2023-05-venus/blob/main/contracts/WhitePaperInterestRateModel.sol#L74

## Tools Used
Manual Auditing

## Recommended Mitigation Steps
User correct value for blocksPerYear relevant to binance smart chain.
So it should be 

blocksPerYear = 10512000 

Correct value is in BaseJumpRateModelV2.sol file 
https://github.com/code-423n4/2023-05-venus/blob/main/contracts/BaseJumpRateModelV2.sol#L23








