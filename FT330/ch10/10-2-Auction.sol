pragma solidity ^0.4.11;
contract Auction {
	address public highestBidder;	// 出價最高的位址
	uint public highestBid;	// 最高出價金額
	
	/// 建構子
	function Auction() payable {
		highestBidder = msg.sender;
		highestBid = 0;
	}
	
	/// Bid（出價）用函數
	function bid() public payable {
		// 確認出價金額比目前的最高金額還要大
		require(msg.value > highestBid);
		
		// 暫存退款金額
		uint refundAmount = highestBid;
		
		// 暫存出價最高的位址
		address currentHighestBidder = highestBidder;
		
		// 更新狀態（state）
		highestBid = msg.value;
		highestBidder = msg.sender;
		
		// 退款給之前出價最高的bidder（投標人）
		if(!currentHighestBidder.send(refundAmount)) {
			throw;
		}
	}
}