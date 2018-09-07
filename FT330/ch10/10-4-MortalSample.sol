
pragma solidity ^0.4.11;
contract Owned {
	address public owner;

	/// 檢查存取權限用的modifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/// 設定擁有者（owner） 
	function owned() internal {
		owner = msg.sender;
	}

	///　變更擁有者（owner）
	function changeOwner(address _newOwner) public onlyOwner {
		owner = _newOwner;
	}
}
contract Mortal is Owned {
	/// 銷毀合約，將ether傳送給owner
	function kill() public onlyOwner {
		selfdestruct(owner);
	}
}
contract MortalSample is Mortal{
	string public someState;

	/// Fallback函數
	function() payable {
	}
	
	/// 建構子
	function MortalSample() {
	// 呼叫在合約Owned定義的owned函數
	owned();

	// 設定someState初始值
	someState = "initial";
	}
}
