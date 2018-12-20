pragma solidity ^0.4.11;
contract VictimBalance {
	// 管理每個位址的餘額
	mapping (address => uint) public userBalances;
	
	// 用於顯示訊息的event
	event MessageLog(string);
	
	// 用於顯示餘額的event 
	event BalanceLog(uint);
	
	/// 建構子
	function VictimBalance() {
	}
	
	/// 使用者要匯款到合約時，會被呼叫的函數
	function addToBalance() public payable {
		userBalances[msg.sender] += msg.value;
	}
	
	/// 要提領ether時，會被呼叫的函數

	function withdrawBalance() public payable returns(bool) {
		MessageLog("withdrawBalance started.");
		BalanceLog(this.balance);
		
		// 確認餘額
		if(userBalances[msg.sender] == 0) {
			MessageLog("No Balance.");
			return false;
		}
		
		// 更新餘額前，暫存需返還之金額
		uint amount = userBalances[msg.sender];
		
		// 更新餘額
		userBalances[msg.sender] = 0;
		
		// 匯出款項到呼叫函數的位址
		if (!(msg.sender.call.value(amount)())) { throw; }
			MessageLog("withdrawBalance finished.");
		return true;
	}

}
