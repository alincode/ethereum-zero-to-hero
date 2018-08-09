# 第三課：高級 Solidity 理論

智能協議的所有權，Gas的花費，代碼優化，和代碼安全

## 第1章：智能協議的永固性

智能協議傳上以太坊之後，它就變得不可更改, 這種永固性意味著你的代碼永遠不能被調整或更新。
如果你的智能協議有任何漏洞，即使你發現了也無法補救。你只能讓你的用戶們放棄這個智能協議，然後轉移到一個新的修復後的合約上。

### 外部依賴關係

我們在 DApp 的代碼中用“硬編碼”的方式指定了加密小貓的地址，如果這個根據地址找不到小貓，我們的殭屍也就吃不到小貓了

因此我們不能寫 hard code，而要採用「函示」，以便於 DApp 的關鍵部分可以以參數的形式修改。

### 完整範例

將原本的 `ckAddress` hard code 抽離，由外部傳入。

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

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external {
    kittyContract = KittyInterface(_address);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
```

## 第2章：Ownable Contracts

### 智能合約審查服務商

* OpenZeppelin
  * [Truffle Suite | Tutorials | Building Robust Smart Contracts with OpenZeppelin](https://truffleframework.com/tutorials/robust-smart-contracts-with-openzeppelin)
  * [OpenZeppelin/openzeppelin-solidity](https://github.com/OpenZeppelin/openzeppelin-solidity): OpenZeppelin, a framework to build secure smart contracts on Ethereum
* Quantstamp


```
ownable.sol


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

```


```
zombiefeeling.sol


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

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external {
    kittyContract = KittyInterface(_address);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
```

下面有沒有您沒學過的東東？

* 構造函數：function Ownable()是一個 constructor (構造函數)，構造函數不是必須的，它與合約同名，構造函數一生中唯一的一次執行，就是在合約最初被創建的時候。

```
contract Ownable {
  address public owner;

  function Ownable() public {
    owner = msg.sender;
  }
}
```

* 函數修飾符：modifier onlyOwner()。 修飾符跟函數很類似，不過是用來修飾其他已有函數用的， 在其他語句執行前，為它檢查下先驗條件。 在這個例子中，我們就可以寫個修飾符 onlyOwner 檢查下調用者，確保只有合約的主人才能運行本函數。我們下一章中會詳細講述修飾符，以及那個奇怪的_;。

```
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
```

```
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

```

* indexed 關鍵字：別擔心，我們還用不到它。

### 實戰練習

```
pragma solidity ^0.4.19;

import "./ownable.sol";

contract ZombieFactory is Ownable {

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

    function _createZombie(string _name, uint _dna) internal {
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
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
```

## 第3章：onlyOwner 函數修飾符 (modifier)

函數修飾符看起來跟函數沒什麼不同，不過關鍵字 `modifier` 告訴編譯器，這是個 `modifier` (修飾符)，而不是個 `function` (函數)。它不能像函數那樣被直接調用，只能被添加到函數定義的末尾，用以改變函數的行為。

```
modifier onlyOwner() {
  require(msg.sender == owner);
  _;
}
```

```
contract MyContract is Ownable {
  event LaughManiacally(string laughter);

  function likeABoss() external onlyOwner {
    LaughManiacally("Muahahahaha");
  }
}
```

注意 `likeABoss` 函數上的 `onlyOwner` 修飾符。 當你調用 `likeABoss` 時，首先執行 `onlyOwner` 中的代碼， 執行到 `onlyOwner` 中的 `_;` 語句時，程序再返回並執行 `likeABoss` 中的代碼。

可見，儘管函數修飾符也可以應用到各種場合，但最常見的還是放在函數執行之前添加快速的 `require` 檢查。

注意：主人對合約享有的特權當然是正當的，不過也可能被惡意使用。比如，萬一，主人添加了個後門，允許他偷走別人的殭屍呢？

所以非常重要的是，部署在以太坊上的 DApp，並不能保證它真正做到去中心，你需要閱讀並理解它的源代碼，才能防止其中沒有被部署者惡意植入後門；作為開發人員，如何做到既要給自己留下修復 bug 的餘地，又要儘量地放權給使用者，以便讓他們放心你，從而願意把數據放在你的 DApp 中，這確實需要個微妙的平衡。

### 實戰練習

```
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }
```

## 第4章：Gas

Solidity 中，你的用戶想要每次執行你的 DApp 都需要支付一定的 gas，gas 可以用以太幣購買，因此，用戶每次跑 DApp 都得花費以太幣。

一個 DApp 收取多少 gas 取決於功能邏輯的複雜程度。每個操作背後，都在計算完成這個操作所需要的計算資源，（譬如，儲存資料，就比做加法運算貴許多）， 一次操作所需要花費的 gas 等於這個操作背後的所有運算開銷的總和。

由於執行你的程序需要花費用戶的以太幣，所以在以太坊中代碼的編程語言，比其他任何編程語言都更強調「優化」。同樣的功能，使用笨拙的代碼開發的程序，跟經過精巧優化的代碼比，執行花費更高，這顯然會給成千上萬的用戶帶來大量不必要的開銷。

### 為什麼要用 gas 來驅動？

以太坊就像一個巨大、緩慢、但非常安全的電腦。當你運行一個程序的時候，網絡上的每一個節點都在進行相同的運算，以驗證它的輸出 —— 這就是所謂的”去中心化“ 由於數以千計的節點同時在驗證著每個功能的運行，這可以確保它的數據不會被被監控，或者被刻意修改。

可能會有用戶用無限循環堵塞網絡，抑或用密集運算來佔用大量的網絡資源，為了防止這種事情的發生，以太坊的創建者為以太坊上的資源制定了價格，想要在以太坊上運算或者存儲，你需要先付費。

注意：如果你使用側鏈，倒是不一定需要付費，比如咱們在 Loom Network 上構建的 CryptoZombies 就免費。你不會想要在以太坊主網上玩兒“魔獸世界”吧？ - 所需要的 gas 可能會買到你破產。但是你可以找個算法理念不同的側鏈來玩它。我們將在以後的課程中咱們會討論到，什麼樣的 DApp 應該部署在太坊主鏈上，什麼又最好放在側鏈。

### 省 gas 的招數：結構封裝 （Struct packing）

在第1課中，我們提到除了基本版的 uint 外，還有其他變種 uint：uint8，uint16，uint32等。

通常情況下我們不會考慮使用 uint 變種，因為無論如何定義 uint的大小，Solidity 為它保留256位的存儲空間。例如，使用 uint8 而不是uint（uint256）不會為你節省任何 gas。

除非，把 uint 綁定到 struct 裡面。

如果一個 struct 中有多個 uint，則儘可能使用較小的 uint, Solidity 會將這些 uint 打包在一起，從而佔用較少的存儲空間。例如：

```
struct NormalStruct {
  uint a;
  uint b;
  uint c;
}

struct MiniMe {
  uint32 a;
  uint32 b;
  uint c;
}
```

// 因為使用了結構打包，`mini` 比 `normal` 佔用的空間更少

```
NormalStruct normal = NormalStruct(10, 20, 30);
MiniMe mini = MiniMe(10, 20, 30);
```

所以，當 uint 定義在一個 struct 中的時候，儘量使用最小的整數子類型以節約空間。 並且把同樣類型的變數放一起（即在 struct 中將把變量按照類型依次放置），這樣 Solidity 可以將存儲空間最小化。例如，有兩個 struct：

```
uint c;
uint32 a;
uint32 b;
```

和

```
uint32 a;
uint c;
uint32 b;
```

前者比後者需要的 gas 更少，因為前者把 uint32 放一起了。

### 實戰練習

```
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }
```

## 第5章：時間單位

Solidity 使用自己的本地時間單位。

變量 now 將返回當前的 unix ㄋ時間戳（自1970年1月1日以來經過的秒數），例如 1515527488ㄋ

注意：Unix 時間傳統用一個32位的整數進行存儲。這會導致“2038年”問題，當這個32位的 unix 時間戳不夠用，產生溢出，使用這個時間的遺留系統就麻煩了。所以，如果我們想讓我們的 DApp 跑夠 20 年，我們可以使用 64 位整數表示時間，但為此我們的用戶又得支付更多的 gas。真是個兩難的設計啊！

Solidity 還包含秒(seconds)，分鐘(minutes)，小時(hours)，天(days)，周(weeks) 和 年(years) 等時間單位。它們都會轉換成對應的秒數放入 uint 中。所以 1分鐘 就是 60，1小時是 3600（60秒×60分鐘），1天是86400（24小時×60分鐘×60秒），以此類推。

### 實用範例

```
uint lastUpdated;

// 將「上次更新時間」設置為 「現在」
function updateTimestamp() public {
  lastUpdated = now;
}

// 如果到上次 updateTimestamp 超過5分鐘，返回 true
// 不到 5 分鐘返回 false
function fiveMinutesHavePassed() public view returns (bool) {
  return (now >= (lastUpdated + 5 minutes));
}
```

### 實戰練習