# checkingStuff
## LACK OF CHECKS ADDRESS(0)
The following methods have a lack of checks if the received argument is an address, it’s good practice in order to reduce human error to check that the address
specified in the constructor or initialize is different than address(0).


#### Affected Source Code
* [Base.sol:11](https://github.com/code-423n4/2022-12-gogopool/blob/aec9928d8bdce8a5a4efe45f54c39d4fc7313731/contracts/contract/Base.sol#L11)
* [ClaimNodeOp.sol:31](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/ClaimNodeOp.sol#L31)
* [MinipoolManager.sol:183](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/MinipoolManager.sol#L183)
* [MinipoolManager.sol:184](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/MinipoolManager.sol#L184)
* [Ocyticus.sol:28](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Ocyticus.sol#L28)
* [ProtocolDAO.sol:191](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/ProtocolDAO.sol#L191)
* [Staking.sol:62](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Staking.sol#L62)
* [Storage.sol:47](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Storage.sol#L47)
* [Vault.sol:205](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Vault.sol#L205)





## OPEN TODO
The code that contains “open todos” reflects that the development is not finished and that the code can change a posteriori, prior release, with or without
audit.

#### Affected Source Code
* [BaseAbstract.sol:6](https://github.com/code-423n4/2022-12-gogopool/blob/aec9928d8bdce8a5a4efe45f54c39d4fc7313731/contracts/contract/BaseAbstract.sol#L6)

## Internal and private functions should have an underscore prefix with mixedCase(Naming convention)
#### Affected Source Code
* [BaseUpgradeable.sol:10](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/BaseUpgradeable.sol#L10)

    For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#other-recommendations)
    2. [Solidity Style](https://www.notion.so/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe)

## Structs should be named using the CapWords style(Naming convention)
#### Affected Source Code
* [MinipoolManager.sol:82](https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/MinipoolManager.sol#L82)

    For more read...
    1. [Soliditydocs](https://docs.soliditylang.org/en/v0.8.15/style-guide.html#other-recommendations)
    
    
## Gas Report


## ADD UNCHECKED {} FOR ITERATOR WHERE THE OPERANDS CANNOT OVERFLOW BECAUSE ITS ALLWAYS BELOW THE GIVEN NUMBER.
	
for loops j++ and i++ can be set to UNCHECKED{++j} and UNCHECKED{++i}


There are ... instances of this issue:

        File: contracts/contract/MinipoolManager.sol

	619	for (uint256 i = offset; i < max; i++) {
	
	623	total++;
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/MinipoolManager.sol#L619

	File: contracts/contract/MultisigManager.sol
	
	84	for (uint256 i = 0; i < total; i++) {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/MultisigManager.sol#L84

	File: contracts/contract/Ocyticus.sol
	
	61	for (uint256 i = 0; i < count; i++) {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Ocyticus.sol#L61


	File: contracts/contract/RewardsPool.sol
	
	74	for (uint256 i = 0; i < inflationIntervalsElapsed; i++) {
	
	215	for (uint256 i = 0; i < count; i++) {
	
	230	for (uint256 i = 0; i < enabledMultisigs.length; i++) {
	
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/RewardsPool.sol#L74

	File: contracts/contract/Staking.sol
	
	428	for (uint256 i = offset; i < max; i++) {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Staking.sol#L428



## ADD UNCHECKED {}  WHERE THE OPERANDS CANNOT OVERFLOW/UNDERFLOW BECAUSE THOSE CRITERIA ARE CHECKED BY ABOVE STATEMENTS. 

Above if statement already check overflow avaxBalances and its value cannot be negative because amout is less than avaxBalances.So use uncheck blocks

	File: contracts/contract/Vault.sol
	
	75	avaxBalances[contractName] = avaxBalances[contractName] - amount;
	
	99	avaxBalances[fromContractName] = avaxBalances[fromContractName] - amount;
	
	187	tokenBalances[contractKeyFrom] = tokenBalances[contractKeyFrom] - amount;
	
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Vault.sol#L75


## X = X + Y IS MORE EFFICIENT, THAN X += Y

	File: contracts/contract/TokenggAVAX.sol
	
	245	totalReleasedAssets -= amount;
	
	252	totalReleasedAssets += amount;
	

https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/tokens/TokenggAVAX.sol#L245
	
	
## USAGE OF UINTS/INTS SMALLER THAN 32 BYTES (256 BITS) INCURS OVERHEAD
When using elements that are smaller than 32 bytes, your contract’s gas usage may be higher. This is because the EVM operates on 32 bytes at a time.
Therefore, if the element is smaller than that, the EVM must use more operations in order to reduce the size of the element from 32 bytes to the
desired size.

There are 1 instances of this issue:

	File: contracts/contract/BaseAbstract.sol
	
	19.	uint8 public version;

https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/BaseAbstract.sol#L19

## FUNCTIONS GUARANTEED TO REVERT WHEN CALLED BY NORMAL USERS CAN BE MARKED PAYABLE

if a function modifier such as onlyOwner is used, the function will revert if a normal user tries to pay the function. Marking the function as
payable will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

There are ... instances of this issue:

	File: contracts/contract/ClaimNodeOp.sol
	
	40	function setRewardsCycleTotal(uint256 amount) public onlySpecificRegisteredContract("RewardsPool", msg.sender) {
	
	56	function calculateAndDistributeRewards(address stakerAddr, uint256 totalEligibleGGPStaked) external onlyMultisig {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/ClaimNodeOp.sol#L40

	File: contracts/contract/MultisigManager.sol
	
	35	function registerMultisig(address addr) external onlyGuardian {
	
	55	function enableMultisig(address addr) external onlyGuardian{
	
	68	function disableMultisig(address addr) external guardianOrSpecificRegisteredContract("Ocyticus", msg.sender) {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/MultisigManager.sol#L35

	File: contracts/contract/Ocyticus.sol
	
	27	function addDefender(address defender) external onlyGuardian {
	
	32	function removeDefender(address defender) external onlyGuardian {
	
	37	function pauseEverything() external onlyDefender {
	
	47	function resumeEverything() external onlyDefender {
	
	55	function disableAllMultisigs() public onlyDefender {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Ocyticus.sol#L27

	File: contracts/contract/Oracle.sol
	
	28	function setOneInch(address addr) external onlyGuardian {
	
	57	function setGGPPriceInAVAX(uint256 price, uint256 timestamp) external onlyMultisig {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Oracle.sol#L28

	File: contracts/contract/ProtocolDAO.sol
	
	23	function initialize() external onlyGuardian {
	
	67	function pauseContract(string memory contractName) public onlySpecificRegisteredContract("Ocyticus", msg.sender) {
	
	73	function resumeContract(string memory contractName) public onlySpecificRegisteredContract("Ocyticus", msg.sender) {
	
	96	function setTotalGGPCirculatingSupply(uint256 amount) public onlySpecificRegisteredContract("RewardsPool", msg.sender) {
	
	107	function setClaimingContractPct(string memory claimingContract, uint256 decimal) public onlyGuardian valueNotGreaterThanOne(decimal) {
	
	156	function setExpectedAVAXRewardsRate(uint256 rate) public onlyMultisig valueNotGreaterThanOne(rate) {
	
	190	function registerContract(address addr, string memory name) public onlyGuardian {
	
	198	function unregisterContract(address addr) public onlyGuardian {
	
	209	function upgradeExistingContract(
		address newAddr,
		string memory newName,
		address existingAddr
		) external onlyGuardian {
		
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/ProtocolDAO.sol#L23

	File: contracts/contract/RewardsPool.sol
	
	34	function initialize() external onlyGuardian {
	
https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/RewardsPool.sol#34

	File: contracts/contract/Staking.sol
	
	110	function increaseAVAXStake(address stakerAddr, uint256 amount) public onlySpecificRegisteredContract("MinipoolManager", msg.sender) {
	
	117	function decreaseAVAXStake(address stakerAddr, uint256 amount) public onlySpecificRegisteredContract("MinipoolManager", msg.sender) {
	
	133	function increaseAVAXAssigned(address stakerAddr, uint256 amount) public onlySpecificRegisteredContract("MinipoolManager", msg.sender) {
	
	140	function decreaseAVAXAssigned(address stakerAddr, uint256 amount) public onlySpecificRegisteredContract("MinipoolManager", msg.sender) {
	
	156	function increaseAVAXAssignedHighWater(address stakerAddr, uint256 amount) public onlyRegisteredNetworkContract {
	
	163	function resetAVAXAssignedHighWater(address stakerAddr) public onlyRegisteredNetworkContract {
	
	180	function increaseMinipoolCount(address stakerAddr) public onlySpecificRegisteredContract("MinipoolManager", msg.sender) {
	
	187	function decreaseMinipoolCount(address stakerAddr) public onlySpecificRegisteredContract("MinipoolManager", msg.sender) {
	
	204	function setRewardsStartTime(address stakerAddr, uint256 time) public onlyRegisteredNetworkContract {
	
	224	function increaseGGPRewards(address stakerAddr, uint256 amount) public onlySpecificRegisteredContract("ClaimNodeOp", msg.sender) {
	
	231	function decreaseGGPRewards(address stakerAddr, uint256 amount) public onlySpecificRegisteredContract("ClaimNodeOp", msg.sender) {
	
	248	function setLastRewardsCycleCompleted(address stakerAddr, uint256 cycleNumber) public onlySpecificRegisteredContract("ClaimNodeOp", msg.sender) 
	
	328	function restakeGGP(address stakerAddr, uint256 amount) public onlySpecificRegisteredContract("ClaimNodeOp", msg.sender) {
	
	379	function slashGGP(address stakerAddr, uint256 ggpAmt) public onlySpecificRegisteredContract("MinipoolManager", msg.sender) {

https://github.com/code-423n4/2022-12-gogopool/blob/main/contracts/contract/Staking.sol#L110
	
	
	


	
		
		
		
	



	
	
	

	




	
	



