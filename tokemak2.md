## Summary
Is greater than lib is not working as expected when  two unsigned integers are the same ( a=b ).

## Vulnerability Detail
It should be reverted isGte function if a = b. But here it's not reverted & accept if a = b.  

## Impact
isGte function is not working as expected when two unsigned integers are equal. It is expected to be reverted two units are equal but it's not happened here. 

## Code Snippet

The current implementation of [isGte function](https://github.com/sherlock-audit/2023-06-tokemak-BPZ/blob/main/v2-core-audit-2023-07-14/src/solver/helpers/Integer.sol#L13C2-L21C6)  is shown below. 

```solidity

          12                 /**
          13             * @notice Checks if a given unsigned integer 'a' is greater than another unsigned integer 'b'.
          14             * @param a The first unsigned integer.
          15             * @param b The second unsigned integer.
          16             */
          17            function isGte(uint256 a, uint256 b) public pure {
          18                if (a < b) {
          19                    revert NotLessThan(a, b);
          20                }
          21            }

```


## Tool used

Manual Review

## Recommendation

Add an equal sign to line 18. 

```solidity

        18                if (a <= b) {
```




