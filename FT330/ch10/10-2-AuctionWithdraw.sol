pragma solidity ^0.4.11;
contract AuctionWithdraw {
	address public highestBidder; // 出價最高的位址
	uint public highestBid; // 最高出價金額
	mapping(address => uint) public usersBalance; // 管理退款金額的map（對應表）
	/// 建構子
	function AuctionWithdraw() payable {
		highestBidder = msg.sender;
		highestBid = 0;
	}
	/// Bid用函數
	function bid() public payable {
		// 確認出價金額比目前的最高金額還要大
		require(msg.value > highestBid);
		// 更新出價最高之位址（人）的退款金額
		usersBalance[highestBidder] += highestBid;
		// 更新狀態（state）
		highestBid = msg.value;
		highestBidder = msg.sender;
	}
	function withdraw() public{
		// 確認退款金額大於0 
		require(usersBalance[msg.sender] > 0);
		// 暫存退款金額數值
		uint refundAmount = usersBalance[msg.sender];
		// 更新退款金額
		usersBalance[msg.sender] = 0;
		// 退款處理
		if(!msg.sender.send(refundAmount)) {
			throw;
		}
	}
}
