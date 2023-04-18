# Not burning tokens from the all the address in a array due to hardcoded value

Its hardcoded to 0th element in the addressesToWipe array in the restructureCapTable function. So it skip burning the tokens from
rest of the address in the array. So function does not work as expected. 

## Proof of Concept

    309        function restructureCapTable(address[] calldata helpers, address[] calldata addressesToWipe) public {
    310                require(zchf.equity() < MINIMUM_EQUITY);
    311                checkQualified(msg.sender, helpers);
    312                for (uint256 i = 0; i<addressesToWipe.length; i++){
    313                    address current = addressesToWipe[0];
    314                    _burn(current, balanceOf(current));
    315                }
    316            }
   
https://github.com/code-423n4/2023-04-frankencoin/blob/main/contracts/Equity.sol#L313

Here you can see its hardcorded to 0th element in the for loop(line 313) .

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

313                    address current = addressesToWipe[i];

Use i instead of 0 so that its burned tokens from address which are in the addressesToWipe array. 


