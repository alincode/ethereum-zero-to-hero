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

