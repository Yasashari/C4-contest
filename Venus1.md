# Borrow rate and supply rate are incorrect due to incorrect blocksPerYear value

This protocol is going to be deployed to BNB chain so its needed to calculate blocksPerYear relevent to BNB Smart Chain.
But here it has taken blocksPerYear relevent to ethereum chain. 

## Proof of Concept

      17  uint256 public constant blocksPerYear = 2102400  ;

https://github.com/code-423n4/2023-05-venus/blob/main/contracts/WhitePaperInterestRateModel.sol#L17


