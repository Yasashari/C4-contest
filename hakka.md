## Bug Description
Attacker is able to drain almost all the staked ether in [ThreeFMutual contract](https://etherscan.io/address/0x66be1bc6C6aF47900BBD4F3711801bE6C2c6CB32?utm_source=immunefi#code). Here attacker front run the MakerDAO’s emergency
shutdown and call [buy](https://etherscan.io/address/0x66be1bc6C6aF47900BBD4F3711801bE6C2c6CB32?utm_source=immunefi#code#L313) function with minimum staked ETH( 1000000000  wei of ETH . The Reason for do this is to update the [today](https://etherscan.io/address/0x66be1bc6C6aF47900BBD4F3711801bE6C2c6CB32?utm_source=immunefi#code#L53)
variable). Attacker called buy function again with another account and send 3ETH . By sending 3ETH his [units](https://etherscan.io/address/0x66be1bc6C6aF47900BBD4F3711801bE6C2c6CB32?utm_source=immunefi#code#L403) is ~= 1028.76 ETH.
Current [issuedInsurance](https://etherscan.io/address/0x66be1bc6C6aF47900BBD4F3711801bE6C2c6CB32?utm_source=immunefi#code#L49) is 20.000000016 ETH & due to this 3ETH deposit new issuedInsurance ~= 1048.76 ETH. This means if Attacker called [claim](https://etherscan.io/address/0x66be1bc6C6aF47900BBD4F3711801bE6C2c6CB32?utm_source=immunefi#code#L490) function after MakerDAO’s emergency shutdown (back run), he is able to claim allmost all Ether.( 1918.75 ETH * 1028.76 ETH /  1048.46 ETH =  1882.69 ETH ).

## Impact
Attacker able to drain all most all ether in ThreeFMutual contract (Attacker able to drain 98% ETH in ThreeFMutual contract). 

## Risk Breakdown
Difficulty to Exploit: Easy
Weakness:
CVSS2 Score: 9.3

## Recommendation


## References

