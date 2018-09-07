pragma solidity ^0.4.11;
contract NameRegistry {
	// 登錄合約用的結構（struct）
	struct Contract {
		address owner;
		address addr;
		bytes32 description;
	}
	// 登錄完成的紀錄數
	uint public numContracts;
	// 保存合約的map（對應表）
	mapping (bytes32 => Contract) public contracts;
	/// 建構子
	function NameRegistry() {
		numContracts = 0;
	}
	///登錄合約
	function register(bytes32 _name) public returns (bool){
		// 名稱尚未被使用就可登錄
		if (contracts[_name].owner == 0) {
			Contract con = contracts[_name];
			con.owner = msg.sender;
			numContracts++;
			return true;
		} else {
			return false;
		}
	}
	/// 刪除合約
	function unregister(bytes32 _name) public returns (bool) {
		if (contracts[_name].owner == msg.sender) {
			contracts[_name].owner = 0;
			numContracts--;
			return true;
		} else {
			return false;
		}
	}
	/// 變更合約（contract）的擁有者（owner）
	function changeOwner(bytes32 _name, address _newOwner) public onlyOwner(_name) {
		contracts[_name].owner = _newOwner;
	}
	/// 取得合約的擁有者
	function getOwner(bytes32 _name) constant public returns (address) {
		return contracts[_name].owner;
	}
	/// 設定合約的位址（address）
	function setAddr(bytes32 _name, address _addr) public onlyOwner(_name) {
		contracts[_name].addr = _addr;
	}
	/// 取得合約的位址
	function getAddr(bytes32 _name) constant public returns (address) {
		return contracts[_name].addr;
	}
	/// 設定合約的說明
	function setDescription(bytes32 _name, bytes32 _description) public onlyOwner(_name) {
		contracts[_name].description = _description;
	}
	/// 取得合約的說明
	function getDescription(bytes32 _name) constant public returns (bytes32) {
		return contracts[_name].description;
	}
	/// 定義會在函數被呼叫出來之前進行處理的modifier
	modifier onlyOwner(bytes32 _name) {
		require(contracts[_name].owner == msg.sender);
		_;
	}
}
