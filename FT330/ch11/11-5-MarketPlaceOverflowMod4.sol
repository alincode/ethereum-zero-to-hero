pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod4 {
	address public owner;

	uint public stockQuantity; // 庫存數
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/// 顯示新增庫存數的event 
	event AddStock(uint _addedQuantity);

	/// 建構子
	function MarketPlaceOverflowMod4() {
		owner = msg.sender;
		stockQuantity = 0;
	}

	/// 新增庫存的處理
	function addStock(uint _addedQuantity) public onlyOwner {
		// 溢位檢查
		require(stockQuantity + _addedQuantity > stockQuantity);
		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}
