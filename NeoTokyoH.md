# If check can be bypass with the 4 as assetType in  withdraw function

If staker pass 4 as assetType then if check can be bypassed so that staker can get reward without updating staking details.

# Proof of concept


         1659      function withdraw (
         1660             AssetType _assetType,
         1661             uint256
         1662     ) external nonReentrant {

                /*
                  Validate that the asset being withdrawn is of a valid type. BYTES may not 
                  be withdrawn independently of the Citizen that they are staked into.
                */
                if (uint8(_assetType) == 2 || uint8(_assetType) > 4) {
                  revert InvalidAssetType(uint256(_assetType));
                }

                // Grant the caller their total rewards with each withdrawal action.
                IByteContract(BYTES).getReward(msg.sender);

                // Store references to each available withdraw function.
                function () _s1 = _withdrawS1Citizen;
                function () _s2 = _withdrawS2Citizen;
                function () _lp = _withdrawLP;

                // Select the proper withdraw function based on the asset type.
                function () _withdraw;
                assembly {
                  switch _assetType
                    case 0 {
                      _withdraw := _s1
                    }
                    case 1 {
                      _withdraw := _s2
                    }
                    case 3 {
                      _withdraw := _lp
                    }
                    default {}
                }

                // Invoke the correct withdraw function.
                _withdraw();
       1698       }

    
 If staker passs her 4 as assetType then this if statement not reverted. So that user can bypass it
 
       1668     if (uint8(_assetType) == 2 || uint8(_assetType) > 4) {
       1669         revert InvalidAssetType(uint256(_assetType));
       1670         }
       
Then this getReward function is invoked.

      1673    IByteContract(BYTES).getReward(msg.sender);
      
According to the assetType pass here (4) there is no function to excute here. default {} is not implemented . But it should be
updated his withdrawal of S1 S2 or LP token. But none of the S1 S2 LP  withdrawal functions are invoked here.  

             switch _assetType
                    case 0 {
                      _withdraw := _s1
                    }
                    case 1 {
                      _withdraw := _s2
                    }
                    case 3 {
                      _withdraw := _lp
                    }
                    default {}
                }
                
 # Tools Used
    Vs code

# Recommended Mitigation Steps

         1668         if (uint8(_assetType) == 2 || uint8(_assetType) > 3) {
         
 
                
                
                

    
    


