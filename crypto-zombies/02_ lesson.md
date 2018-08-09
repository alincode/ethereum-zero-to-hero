# 第二課：殭屍攻擊人類

## 第一章：概述

殭屍獵食的時候，殭屍病毒侵入獵物，這些病毒會將獵物變為新的殭屍，加入你的殭屍大軍。系統會通過獵物和獵食者殭屍的DNA計算出新殭屍的DNA。

## 第二章：Mapping 和 Address

我們通過給資料庫中的殭屍指定「主人」， 來支持「多玩家」模式。

### Addresses

以太坊區塊鏈由 account (賬戶)組成，你可以把它想像成銀行賬戶。一個帳戶的餘額是 以太 （在以太坊區塊鏈上使用的幣種），你可以和其他帳戶之間支付和接受以太幣，就像你的銀行帳戶可以電匯資金到其他銀行帳戶一樣。

每個帳戶都有一個“地址”，你可以把它想像成銀行賬號。這是賬戶唯一的標識符，它看起來長這樣：

0x0cE446255506E92DF41614C46F1d6df9Cc969183

（這是 CryptoZombies 團隊的地址，如果你喜歡 CryptoZombies 的話，請打賞我們一些以太幣！😉）

我們將在後面的課程中介紹地址的細節，現在你只需要瞭解地址屬於特定用戶（或智能合約）的。

所以我們可以指定“地址”作為殭屍主人的 ID。當用戶通過與我們的應用程序交互來創建新的殭屍時，新殭屍的所有權被設置到調用者的以太坊地址下。

### Mapping

```
// 對於金融應用程序，將用戶的餘額保存在一個 uint類型的變量中：
mapping (address => uint) public accountBalance;
// 或者可以用來通過userId 存儲/查找的用戶名
mapping (uint => string) userIdToName;
```

mapping 本質上是儲存和查找資料所用的 key 和 value 對應。在第一個例子中，key 是 address，value 是一個 uint，在第二個例子中，key 是一個uint，value 是一個 string。

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
```

## 第三章: Msg.sender

### msg.sender

在 Solidity 中，有一些全局變量可以被所有函數調用。 其中一個就是 msg.sender，它指的是當前調用者（或智能合約）的 address。

ps. 在 Solidity 中，合約一定需要被調用者呼叫才會執行，反則不會做任何事，所以 msg.sender 一定會有值。

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
```

## 第四章: Require

在調用一個函數之前，用 require 驗證前置條件是非常有必要的。

```
require(ownerZombieCount[msg.sender] == 0);
```

### 完整程式碼

```
// zombiefactory.sol

pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
```

## 第五章: 繼承（Inheritance）

```
contract Doge {
  function catchphrase() public returns (string) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string) {
    return "Such Moon BabyDoge";
  }
}
```


```
contract ZombieFeeding is ZombieFactory {

}
```

## 第六章: 引入（Import）

```
pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

}
```

## 第七章: Storage 與 Memory

在 Solidity 中，有兩個地方可以存放變數 `storage` 或 `memory`

Storage 變數是指永久儲存在區塊鏈中的變數。 Memory 變數則是臨時存放，當外部函示對某合約調用完成時，Memory 變數即被移除。你可以把它想像成儲存在你電腦的硬碟或是RAM 中資料的關係。

大多數時候你都用不到這些關鍵字，預設情況下 Solidity 會自動處理它們。狀態變數（在函示之外宣告的變數）預設為 `storage` 形式，並永久寫入區塊鏈；而在函示內宣告的變數是 `memory` 形式，當函示調用結束後，就會消失。

```
pragma solidity ^0.4.19;
import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
      require(msg.sender == zombieToOwner[_zombieId]);
      Zombie storage myZombie = zombies[_zombieId];
  }

}
```

## 第八章: 殭屍的DNA

```
pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

}
```

## 第九章: 函示可見性

* public
* external (外部)
* internal (內部)
* private

### internal 和 external

* internal 和 private 類似，不過，如果某個合約繼承自其父合約，這個合約即可以訪問父合約中定義的“內部”函數。
* external 與 public 類似，不過，這些函數只能在合約之外調用，它們不能被合約內的其他函示調用。

```
contract Sandwich {
  uint private sandwichesEaten = 0;

  function eat() internal {
    sandwichesEaten++;
  }
}

contract BLT is Sandwich {
  uint private baconSandwichesEaten = 0;

  function eatWithBacon() public returns (string) {
    baconSandwichesEaten++;
    // 因為eat() 是internal 的，所以我們能在這裡調用
    eat();
  }
}
```

## 第十章：殭屍吃什麼？

CryptoKitties

### 與其他合約的交互

```
pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

}
```

## 第十一章：使用 interface

```
pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);


  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

}
```

## 第十二章: 處理多回傳值

```
getKitty 是我們所看到的第一個返回多個值的函示。我們來看看是如何處理的：

function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // 這樣來做批量賦予值:
  (a, b, c) = multipleReturns();
}

// 或者如果我們只想返回其中一個變數:
function getLastReturnValue() external {
  uint c;
  // 可以對其他字段留空:
  (,,c) = multipleReturns();
}
```

### 拆解

```
KittyInterface kittyContract = KittyInterface(ckAddress);
```

```
uint kittyDna;
(,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
```

### 完整範例

```
pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
      uint kittyDna;
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      feedAndMultiply(_zombieId, kittyDna);
  }
}
```

## 第十三章：獎勵 Kitty 基因