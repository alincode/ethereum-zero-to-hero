pragma solidity ^0.4.11;
contract Lottery {
	// 管理參加者
	mapping (uint => address) public applicants;
	
	// 管理參加人數
	uint public numApplicants;

	// 中獎人情報
	address public winnerAddress;
	uint public winnerInd;

	// owner
	address public owner;

	// 時間戳記
	uint public timestamp;

	/// 確認owner身份的modifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 建構子
	function Lottery() {
		numApplicants = 0;
		owner = msg.sender;
	}
	/// 用於報名抽獎的函數
	function enter() public {
		// 參加人數超過3人就停止處理
		require(numApplicants < 3);

		// 已經報名的話就停止處理
		for(uint i = 0; i < numApplicants; i++) {
		require(applicants[i] != msg.sender);

		}

		// 接受報名
		applicants[numApplicants++] = msg.sender;
	}
	/// 進行抽獎
	function hold() public onlyOwner {
		// 參加者不滿3人就中止處理
		require(numApplicants == 3);
		
		// 設定時間戳記
		timestamp = block.timestamp;
		
		// 抽獎
		winnerInd = timestamp % 3;
		winnerAddress = applicants[winnerInd];
	}
}
