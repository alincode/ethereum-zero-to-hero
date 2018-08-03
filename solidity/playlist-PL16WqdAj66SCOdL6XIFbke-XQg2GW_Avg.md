# [Learning Solidity](https://www.youtube.com/playlist?list=PL16WqdAj66SCOdL6XIFbke-XQg2GW_Avg) created by [What's Solidity](https://www.youtube.com/channel/UCaWes1eWQ9TbzA695gl_PtA)

* [source code](https://github.com/willitscale/learning-solidity/)

| title                                                                                                              | Published At |
| ------------------------------------------------------------------------------------------------------------------ | ------------ |
| [Tutorial 1 The Basics](https://www.youtube.com/watch?v=v_hU0jPtLto)                                               | 2017-09-06   |
| [Tutorial 2 Inheritance](https://www.youtube.com/watch?v=6hkmLOtIq8A)                                              | 2017-09-10   |
| [Tutorial 3 Custom Modifiers and Error Handling](https://www.youtube.com/watch?v=3ObTNzDM3wI)                      | 2017-09-11   |
| [Tutorial 4 Imports and Libraries](https://www.youtube.com/watch?v=0Lyf_3kA3Ms)                                    | 2017-09-13   |
| [Tutorial 5 Event logging and Transaction Information](https://www.youtube.com/watch?v=Jlq997yOoRs)                | 2017-09-13   |
| [Tutorial 6 Data Types (Array, Mapping, Struct)](https://www.youtube.com/watch?v=8UhO3IKApSg)                      | 2017-09-16   |
| [Tutorial 7 Extending String Functionality and Bytes](https://www.youtube.com/watch?v=6iiWwT0O2fY)                 | 2017-09-16   |
| [Tutorial 8 Debugging Solidity Using Remix](https://www.youtube.com/watch?v=7z52hP26MFs)                           | 2017-09-17   |
| [Tutorial 9 ERC20 Tokens and Creating your own Crypto Currency](https://www.youtube.com/watch?v=r7XojpIDuhA)       | 2017-09-21   |
| [Tutorial 10 ERC223 Tokens and Creating your own Crypto Currency](https://www.youtube.com/watch?v=IWC9-yGoDGs)     | 2017-09-23   |
| [Tutorial 11 Deploying Tokens and Creating your own Crypto Currency](https://www.youtube.com/watch?v=WfkPTyvOL_g)  | 2017-09-24   |
| [Tutorial 12 Functional Assembly](https://www.youtube.com/watch?v=nkGN6GwkMzU)                                     | 2017-09-24   |
| [Tutorial 13 Instructional Assembly](https://www.youtube.com/watch?v=axZJ2NFMH5Q)                                  | 2017-09-26   |
| [Tutorial 14 Transferring Ethereum between contracts](https://www.youtube.com/watch?v=ELWSKMcJfI8)                 | 2017-09-29   |
| [Tutorial 15 Public vs External](https://www.youtube.com/watch?v=Ii4g38mPPlg)                                      | 2017-10-04   |
| [Tutorial 16 Time Based Events](https://www.youtube.com/watch?v=HGw-yalqdgs)                                       | 2017-10-10   |
| [Tutorial 17 Polymorphism](https://www.youtube.com/watch?v=l_E5F5qnbtk)                                            | 2017-10-10   |
| [Tutorial 18 Randomness and Gambling](https://www.youtube.com/watch?v=3wY5PRliphE)                                 | 2017-10-10   |
| [Tutorial 19 Nested Arrays and Storage](https://www.youtube.com/watch?v=zkNHRJEuYQg)                               | 2017-10-18   |
| [Tutorial 20 Parameter Mapping and Multiple Return Values](https://www.youtube.com/watch?v=v3aoiTh-UVQ)            | 2017-10-22   |
| [Tutorial 21 Truffle, Atom and TestRPC](https://www.youtube.com/watch?v=YcTSilIfih0)                               | 2017-10-30   |
| [Tutorial 22 Developing an ICO/Crowdsale with TDD](https://www.youtube.com/watch?v=Cow_aL7NUGY)                    | 2017-11-11   |
| [Tutorial 23 State Modifiers (view, pure, constant)](https://www.youtube.com/watch?v=RKos31UueqY)                  | 2017-11-12   |
| [Tutorial 24 Multisig Wallet](https://www.youtube.com/watch?v=OwavQTuHoM8)                                         | 2017-11-20   |
| [Tutorial 25 Multisig Wallet cont. Multi Authentication](https://www.youtube.com/watch?v=23YLeX7mpbU)              | 2017-12-06   |
| [Tutorial 26 Auditing, Security and Testing (Long, but important)](https://www.youtube.com/watch?v=LGCMZ7S_ITE)    | 2017-12-08   |
| [Tutorial 27 Getting started with browser development using Metamask](https://www.youtube.com/watch?v=eog2eYrPEu0) | 2017-12-19   |

## Tutorial 1 The Basics

### attribute

* internal
* public
* private

```
string private name;
unit private age;
```

#### function


```
contract SimpleStorage {
    string name;
    function setName(string newName) {
        name = newName;
    }
    
    function getName() returns (string) {
        return name;
    }
}
```

## Tutorial 2 Inheritance


```
interface Regulator {
    function checkValue(uint amount) returns (bool);
    function loan() returns (bool);
}

contract Bank is Regulator {
    uint private value;
    
    function Bank(uint amount) {
        value = amount;
    }
    function checkValue(uint amount) returns (bool) {
        return value >= amount;
    }
    
    function loan() returns (bool) {
        return value > 0;
    }
}

contract MyFirstContract is Bank(10) {
	// ...
}
```

## Tutorial 3 Custom Modifiers and Error Handling

### Error Handling

* assert(bool condition): invalidates the transaction if the condition is not met - to be used for internal errors.
* require(bool condition): reverts if the condition is not met - to be used for errors in inputs or external components.
* require(bool condition, string message): reverts if the condition is not met - to be used for errors in inputs or external components. Also provides an error message.
* revert(): abort execution and revert state changes
* revert(string reason): abort execution and revert state changes, providing an explanatory string

```
    modifier ownerFunc {
        require(owner == msg.sender);
        _;
    }

    function deposit(uint amount) ownerFunc {
        value += amount;
    }
    
    function withdraw(uint amount) ownerFunc {
        if (checkValue(amount)) {
            value -= amount;
        }
    }
```

```
contract TestThrows {
    function testAssert() {
        assert(1 == 2);
    }
    
    function testRequire() {
        require(2 == 1);
    }
    
    function testRevert() {
        revert();
    }
    
    function testThrow() {
        throw;
    }
}
```

## Tutorial 4 Imports and Libraries

```
// library.sol
pragma solidity ^0.4.0;

library IntExtended {
    
    function increment(uint _self) returns (uint) {
        return _self+1;
    }
    
    function decrement(uint _self) returns (uint) {
        return _self-1;
    }
    
    function incrementByValue(uint _self, uint _value) returns (uint) {
        return _self + _value;
    }
    
    function decrementByValue(uint _self, uint _value) returns (uint) {
        return _self - _value;
    }
}
```

```
// testLibrary.sol
pragma solidity ^0.4.0;

import "browser/library.sol";

contract TestLibrary {
    using IntExtended for uint;
    
    function testIncrement(uint _base) returns (uint) {
        return IntExtended.increment(_base);
    }
    
    function testDecrement(uint _base) returns (uint) {
        return IntExtended.decrement(_base);
    }
    
    function testIncrementByValue(uint _base, uint _value) returns (uint) {
        return _base.incrementByValue(_value);
    }
    
    function testDecrementByValue(uint _base, uint _value) returns (uint) {
        return _base.decrementByValue(_value);
    }
}
```

## Tutorial 5 Event logging and Transaction Information

[Units and Globally Available Variables — Solidity 0.4.25 documentation](http://solidity.readthedocs.io/en/develop/units-and-global-variables.html#block-and-transaction-properties)

### Block and Transaction Properties

* ~~block.blockhash(uint blockNumber) returns (bytes32): hash of the given block - only works for 256 most recent, excluding current, blocks - deprecated in version 0.4.22 and replaced by blockhash(uint blockNumber).~~
* block.coinbase (address): current block miner’s address
* block.difficulty (uint): current block difficulty
* block.gaslimit (uint): current block gaslimit
* block.number (uint): current block number
* block.timestamp (uint): current block timestamp as seconds since unix epoch
* gasleft() returns (uint256): remaining gas
* msg.data (bytes): complete calldata
* ~~msg.gas (uint): remaining gas - deprecated in version 0.4.21 and to be replaced by gasleft()~~
* msg.sender (address): sender of the message (current call)
* msg.sig (bytes4): first four bytes of the calldata (i.e. function identifier)
* msg.value (uint): number of wei sent with the message
* now (uint): current block timestamp (alias for block.timestamp)
* tx.gasprice (uint): gas price of the transaction
* tx.origin (address): sender of the transaction (full call chain)

```
pragma solidity ^0.4.0;

contract Transaction {
    
    event SenderLogger(address);
    event ValueLogger(uint);
    
    address private owner;
    
    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    
    modifier validValue {
        assert(msg.value >= 1 ether);
        _;
    }
    
    function Transaction() {
        owner = msg.sender;
    }
    
    function () payable isOwner validValue {
        SenderLogger(msg.sender);
        ValueLogger(msg.value);
    }
    
}
```

## Tutorial 6 Data Types (Array, Mapping, Struct)

[Types — Solidity 0.4.25 documentation](http://solidity.readthedocs.io/en/develop/types.html)

#### Booleans

```
contract DataTypes {
	bool myBool = false;
}
```

#### Integers

* int
* uint
* int8 ~ int256

```
contract DataTypes {
	int8 myInt = -128;
	uint8 myUInt = 255;
}
```

#### byte

```
contract DataTypes {	
	byte myValue;
	bytes1 myBytes1; 
	bytes32 myBytes32;
}
```

#### string

```
contract DataTypes {
	string myString;
}
```

#### Fixed Point Numbers

* fixed
* ufixed


#### enum

```
contract DataTypes {
    enum Action {ADD, REMOVE, UPDATE}
    Action myAction = Action.ADD;
}
```

#### address

```
contract DataTypes {

	address myAddress;

	function assignAddress() {
    myAddress = msg.sender;
    myAddress.balance;
    myAddress.transfer(10);
	}

}
```


#### Members of Addresses

* balance
* transfer
* send
* call, callcode and delegatecall

### Array

```
contract DataTypes {
	uint[] myIntArr = [1,2,3];
    
	function arrFunc() {
    myIntArr.push(1);
    myIntArr.length;
    myIntArr[0];
	}

	uint[10] myFixedArr;
}
```

### Struct

```
contract DataTypes {
	struct Account {
    uint balance;
    uint dailyLimit;
	}

  Account myAccount;

  function structFunc() {
    myAccount.balance = 100;
  }
}
```

### Mapping

```
contract DataTypes {
	
	struct Account {
    uint balance;
    uint dailyLimit;
	}
	
	mapping (address => Account) _accounts;
	
	function () payable {
    _accounts[msg.sender].balance += msg.value;
	}

  function getBalance() returns (uint) {
		return _accounts[msg.sender].balance;
  }
}
```

## Tutorial 7 Extending String Functionality and Bytes


```
// TestStrings.sol
pragma solidity ^0.4.0;

import "browser/Strings.sol";

contract TestStrings {
    
    using Strings for string;
    
    function testConcat(string _base) returns (string) {
        return _base.concat("_suffix");
    }
    
    function needleInHaystack(string _base) returns (int) {
        return _base.strpos("t");
    }
}
```

```
// Strings.sol
pragma solidity ^0.4.0;

library Strings {
    
    function concat(string _base, string _value) internal returns (string) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);
        
        string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);
        
        uint i;
        uint j;
        
        for(i=0;i<_baseBytes.length;i++) {
            _newValue[j++] = _baseBytes[i];
        }
        
        for(i=0;i<_valueBytes.length;i++) {
            _newValue[j++] = _valueBytes[i];
        }
        
        return string(_newValue);
    }
    
    function strpos(string _base, string _value) internal returns (int) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length == 1);        
        
        for(uint i=0;i<_baseBytes.length;i++) {
            if (_baseBytes[i] == _valueBytes[0]) {
                return int(i);
            }
        }
        
        return -1;
    }
    
}
```

#### More

* [bytes and strings in Solidity – Cryptopusco – Medium](https://medium.com/@cryptopusco/bytes-and-strings-in-solidity-f2cd4e53f388)

```
pragma solidity ^0.4.0;

contract BytesOrStrings {

  string constant _string = "cryptopus.co Medium";
  bytes32 constant _bytes = "cryptopus.co Medium";

  function  getAsString() public returns(string) {
	  // gasUsed：21916
    return _string;
  }

  function  getAsBytes() public returns(bytes32) {
	  // gasUsed：21484
 	  return _bytes;
  }
}
```
