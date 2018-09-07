pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod {
	address public owner;
	uint8 public stockQuantity; // 庫存數量

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/// 顯示新增庫存數量的event
	event AddStock(uint8 _addedQuantity);

	/// 建構子
	function MarketPlaceOverflowMod() {
		owner = msg.sender;
		stockQuantity = 100;
	}

	/// 新增庫存的處理
	function addStock(uint8 _addedQuantity) public onlyOwner {
		// 溢位檢查
		require(stockQuantity + _addedQuantity > stockQuantity);

		AddStock(_addedQuantity);
		stockQuantity += _addedQuantity;
	}
}
