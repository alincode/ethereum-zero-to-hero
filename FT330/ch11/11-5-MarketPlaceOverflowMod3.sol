pragma solidity ^0.4.11;
contract MarketPlaceOverflowMod3 {
	address public owner;
	uint8 public stockQuantity; // 庫存數量

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/// 新增顯示新增庫存數量的event 
	event AddStock(uint _addedQuantity);

	/// 建構子
	function MarketPlaceOverflowMod3() {
		owner = msg.sender;
		stockQuantity = 100;
	}
	

	/// 新增庫存的處理
	function addStock(uint _addedQuantity) public onlyOwner { 
		// 檢查新增數量
		require(_addedQuantity < 256);
		
		// 溢位檢查
		require(stockQuantity + uint8(_addedQuantity) > stockQuantity);
		
		AddStock(_addedQuantity);
		stockQuantity += uint8(_addedQuantity);
	}


}
