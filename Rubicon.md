# Miscalculation of pay_amt so that _matcho function doesn't work as expected 

When orders get filled either one of these t_pay_amt or t_buy_amt goes to zero (Limiting factor should go to zero first). But
with current implementation t_pay_amt is 0 if only t_buy_amt = 0.  So function offer not doesn't work properly.

https://github.com/code-423n4/2023-04-rubicon/blob/main/contracts/RubiconMarket.sol#L840



## Proof of Concept

     1315       t_buy_amt_old = t_buy_amt;
     1316       t_buy_amt = sub(t_buy_amt, min(m_pay_amt, t_buy_amt));
     1317       t_pay_amt = mul(t_buy_amt, t_pay_amt) / t_buy_amt_old;
     
     
     1319           if (t_pay_amt == 0 || t_buy_amt == 0) {
     1320           break;
     1321           }


https://github.com/code-423n4/2023-04-rubicon/blob/main/contracts/RubiconMarket.sol#L1317

Consider this scenario ,

t_buy_amt = 2ETH (That's mean he need to buy 2 Eth) 

t_pay_amt = 2000 USDC (That's mean he wish to pay 2000 USDC)

Current best offer 1ETH = 1600 USDC

      1315     t_buy_amt_old = t_buy_amt;
               t_buy_amt_old = 2ETH
               
      1316    t_buy_amt = sub(t_buy_amt, min(m_pay_amt, t_buy_amt)); 
  	          t_buy_amt = 2ETH - 1ETH = 1ETH

( This is a simple calculation. Buyer buy 1ETH for 1600 USDC and rest should be 400 USDC. )

      
      1317	  t_pay_amt = mul(t_buy_amt, t_pay_amt) / t_buy_amt_old;    
	            t_pay_amt = 1ETH x 2000 / 2 ETH = 1000 USDC 	(is this correct ?)

But correct answer should  be 

	          t_pay_amt  =  2000 - 1600 = 400 USDC     
		             =  2000 - 1ETH x 1600 / 1 ETH  = 400 USDC
                       

## Tools Used
Manual Auditing

## Recommended Mitigation Steps

Use this equation to calculate t_pay_amt

t_pay_amt  = How much tokes left to fill next orders - spend amount of current filling order

1317     t_pay_amt = t_pay_amt - min(m_pay_amt, t_buy_amt) x m_buy_amt / m_pay_amt


                       




