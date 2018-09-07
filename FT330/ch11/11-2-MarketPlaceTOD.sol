pragma solidity ^0.4.11;
contract MarketPlaceTOD {
	address public owner;
	uint public price; // 單件價格
	uint public stockQuantity; //庫存數量
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	event UpdatePrice(uint _price);
	event Buy(uint _price, uint _quantity, uint _value, uint _change);
	
	/// 建構子
	function MarketPlaceTOD() {
		owner = msg.sender;
		price = 1;
		stockQuantity = 100;
	}

	/// 更新價格的處理
	function updatePrice(uint _price) public onlyOwner {
		price = _price;
		UpdatePrice(price);
	}
	
	/// 購買的處理
	function buy(uint _quantity) public payable {
		if (msg.value < _quantity * price || _quantity > stockQuantity) {
			throw;
		}
		
		// 找零錢的處理
		if(!msg.sender.send(msg.value - _quantity * price)) {
			throw;
		}
		
		stockQuantity -= _quantity;
		Buy(price, _quantity, msg.value, msg.value - _quantity * price);
	}
}
