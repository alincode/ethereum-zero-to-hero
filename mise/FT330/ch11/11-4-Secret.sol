pragma solidity ^0.4.11;
contract Secret {
	string private secret; // 祕密字串
	/// 建構子
	function Secret(string _secret) {
		secret = _secret;
	}
	/// 設定祕密字串
	function setSecret(string _secret) public {
		secret = _secret;
	}
}
