pragma solidity ^0.4.11;
contract HelloEthereum {
	// ���ѽd�ҡ]�d��1�^
	string public msg1;

	string private msg2; // ���ѽd�ҡ]�d��2�^
	/* ���ѽd�ҡ]�d��3�^ */
	address public owner;
	uint8 public counter;
	/// Constructor�]�غc�l�^
	function HelloEthereum(string _msg1) {
		// �Nmsg1�]��_msg1
		msg1 = _msg1;
		// �Nowner�]�w�����X���]Contract�^�Ҳ��ͪ���}�]address�^
		owner = msg.sender;
		//�@���_�l�A�N counter�]��0
		counter = 0;
	}
	/// msg2��setter
	function setMsg2(string _msg2) public {
		// if�y���d��
		if(owner != msg.sender) {
			throw;
		} else {
			msg2 = _msg2;
		}
	}
	// msg2��getter
	function getMsg2() constant public returns(string) {
		return msg2;
	}
	function setCounter() public {
		// for�y���d��
		for(uint8 i = 0; i < 3; i++) {
			counter++;
		}
	}
}
