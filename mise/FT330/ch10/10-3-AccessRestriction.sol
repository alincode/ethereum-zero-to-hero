pragma solidity ^0.4.11;
contract Owned {
	address public owner;
	/// 檢查存取權限用的modifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	/// 設定擁有者
	function owned() internal {
		owner = msg.sender;
	}
	///　變更擁有者
	function changeOwner(address _newOwner) public onlyOwner {
		owner = _newOwner;
	}
}
contract AccessRestriction is Owned{
	string public someState;
	/// 建構子
	function AccessRestriction() {
		// 呼叫在Owned定義的own函數
		owned();
		// 設定someState初始值 
		someState = "initial";
	}
	/// 更新someState的函數
	function updateSomeState(string _newState) public onlyOwner {
		someState = _newState;
	}
}
