pragma solidity ^0.4.11;
contract CircuitBreaker {
	bool public stopped; //值為 true的時候，Circuit Breaker在啟動狀態中
	address public owner;
	bytes16 public message;
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	/// 確認stopped變數的modifier
	modifier isStopped() {
		require(!stopped);
		_;
	}
	/// 建構子
	function CircuitBreaker() {
		owner = msg.sender;
		stopped = false;
	}
	/// 變更stopped的狀態
	function toggleCircuit(bool _stopped) public onlyOwner {
		stopped = _stopped;
	}

	/// 更新message的函數
	/// 當stopped變數為true的時候不能更新
	function setMessage(bytes16 _message) public isStopped {
		message = _message;
	}
}
