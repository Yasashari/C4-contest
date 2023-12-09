## Bug Description
Attacker is able to drain almost all the staked ether in ThreeFMutual contract. Here attacker front run the MakerDAO’s emergency
shutdown and call buy function with minimum staked ETH( 1000000000  wei of ETH . The Reason for do this is to update the today
variable). Attacker called buy function with another account and send 3ETH . By sending 3ETH his units is ~= 1028.76 ETH. Current
issuedInsurance is 20.000000016 ETH & due to this 3ETH deposit its going to issuedInsurance ~= 1048.76 ETH. This means if Attacker
called claim function after MakerDAO’s emergency shutdown (back run), he is able to claim allmost all Ether.( 1897.40 ETH * 1028.76
ETH /  1048.46 ETH = 1862.56 ETH ).

## Impact
Attacker able to drain all most all ether in ThreeFMutual contract (98% ETH). 

## Risk Breakdown
Difficulty to Exploit: Easy
Weakness:
CVSS2 Score: 9.3

## Recommendation


## References

