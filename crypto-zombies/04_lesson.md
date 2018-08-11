# 第四章：殭屍作戰系統

## 第1章：可支付

截至目前，我們只接觸到很少的 函數修飾符。 要記住所有的東西很難，所以我們來個概覽：

我們有決定函數何時和被誰調用的可見性修飾符：

* private：意味著它只能被合約內部調用
* internal：就像 private 但是也能被繼承的合約調用
* external：只能從合約外部調用
* public：可以在任何地方調用，不管是內部還是外部。

我們也有狀態修飾符， 告訴我們函數如何和區塊鏈交互：

* view 告訴我們運行這個函數不會更改和保存任何變數
* pure 告訴我們這個函數不但不會往區塊鏈寫數據，它甚至不從區塊鏈讀取涮。

這兩種在被從合約外部調用的時候都不花費任何 gas（但是它們在被內部其他函數調用的時候將會耗費gas）。

然後我們有了自定義的 `modifiers`，例如在第三課學習的: `onlyOwner` 和 `aboveLevel`。 對於這些修飾符我們可以自定義其對函數的約束邏輯。

這些修飾符可以同時作用於一個函數定義上：

```
function test() external view onlyOwner anotherModifier { /* ... */ }
```

### payable 修飾符

`payable` 方法是讓 Solidity 和以太坊變得如此酷的一部分，它們是一種可以接收以太的特殊函數。

先放一下。當你在調用一個普通網站服務器上的 API 函數的時候，你無法用你的函數傳送美元，你也不能傳送比特幣。

但是在以太坊中， 因為錢 (以太), 數據 (事務負載)， 以及合約代碼本身都存在於以太坊。你可以在同時調用函數 並付錢給另外一個合約。

這就允許出現很多有趣的邏輯，比如向一個合約要求支付一定的錢來運行一個函數。

### 來看個例子

```
contract OnlineStore {
  function buySomething() external payable {

    // 檢查以確定0.001以太發送出去來運行函數
    require(msg.value == 0.001 ether);

    // 如果為真，一些用來向函數調用者發送數字內容的邏輯
    transferThing(msg.sender);
  }
}
```

在這裡，`msg.value` 是一種可以查看向合約發送了多少以太的方法，另外 `ether` 是一個內建單位。

這裡發生的邏輯是一些人會從 web3.js 調用這個函數 (從DApp的前端)，像這樣：

```
// 假設 OnlineStore 在以太坊上指向你的合約
OnlineStore.buySomething().send(from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001))
```

注意這個 value 字段， JavaScript 調用來指定發送多少(0.001)以太。如果把事務想像成一個信封，你發送到函數的參數就是信的內容。 添加一個 `value` 很像在信封裡面放錢，信件內容和錢同時發送給了接收者。

注意： 如果一個函數沒標記為 `payable`， 而你嘗試利用上面的方法發送以太，函數將拒絕你的事務。

### 實戰練習

我們來在殭屍遊戲裡面建立一個 `payable` 函數。

假定在我們的遊戲中，玩家可以通過支付 ETH 來升級他們的殭屍。ETH 將存儲在你擁有的合約中，一個簡單明瞭的例子，向你展示你可以通過自己的遊戲賺錢。

1. 定義一個 `uint` ，命名為 `levelUpFee`, 將值設定為 0.001 ether。
1. 定義一個名為 `levelUp` 的函數。 它將接收一個 `uint` 參數 `_zombieId`。 函數應該修飾為 `external` 以及 `payable`。
1. 這個函數首先應該 `require` 確保 `msg.value` 等於 `levelUpFee`。
1. 然後它應該增加殭屍的 level: `zombies[_zombieId].level++`。

#### highlight

```
uint levelUpFee = 0.001 ether;
```

```
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }
```

#### 完整

```
pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
```

## 第2章：提現

在上一章，我們學習了如何向合約發送以太，那麼在發送之後會發生什麼呢？

在你發送以太之後，它將被存儲進以合約的以太坊賬戶中，並凍結在哪裡，除非你添加一個函數來從合約中把以太提現。

你可以寫一個函數來從合約中提現以太，類似這樣：

```
contract GetPaid is Ownable {
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
}
```

注意我們使用 `Ownable` 合約中的 `owner` 和 `onlyOwner`，假定它已經被引入了。

你可以通過 `transfer` 函數向一個地址發送以太， 然後 `this.balance` 將返回當前合約存儲了多少以太。 所以如果 100 個用戶每人向我們支付 1 以太，`this.balance` 將是 100 以太。

你可以通過 `transfer` 向任何以太坊地址付錢。 比如，你可以有一個函數在 `msg.sender` 超額付款的時候給他們退錢：

```
uint itemFee = 0.001 ether;
msg.sender.transfer(msg.value - itemFee);
```

或者在一個有賣家和賣家的合約中， 你可以把賣家的地址存儲起來， 當有人買了它的東西的時候，把買家支付的錢發送給它 `seller.transfer(msg.value)`。

有很多例子來展示什麼讓以太坊編程如此之酷，你可以擁有一個不被任何人控制的去中心化市場。

### 實戰練習

```
  uint levelUpFee = 0.001 ether;

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }
```

#### 完整範例

```
pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
```

## 第3章：殭屍戰鬥

在我們學習了可支付函數和合約餘額之後，是時候為殭屍戰鬥添加功能了。

遵循上一章的格式，我們新建一個攻擊功能合約，並將代碼放進新的文件中，引入上一個合約。

### 實戰練習

```
pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {

}
```

## 第4章：隨機數

### 用 keccak256 來製造隨機數

```
// 生成一個0到100的隨機數:
uint randNonce = 0;
uint random = uint(keccak256(now, msg.sender, randNonce)) % 100;
randNonce++;
uint random2 = uint(keccak256(now, msg.sender, randNonce)) % 100;
```

這個方法首先拿到 now 的時間戳、msg.sender、以及一個自增數 nonce （一個僅會被使用一次的數，這樣我們就不會對相同的輸入值調用一次以上哈希函數了）。

然後利用 keccak 把輸入的值轉變為一個哈希值，再將哈希值轉換為 uint，然後利用 % 100 來取最後兩位，就生成了一個0到100之間隨機數了。

### 這個方法很容易被不誠實的節點攻擊

在以太坊上，當你在和一個合約上調用函數的時候，你會把它廣播給一個節點或者在網絡上的 transaction 節點們。網絡上的節點將收集很多事務，試著成為第一個解決計算密集型數學問題的人，作為「工作證明」，然後將「工作證明」(Proof of Work, PoW)和事務一起作為一個 block 發佈在網絡上。

一旦一個節點解決了一個 `PoW`，其他節點就會停止嘗試解決這個 `PoW`，並驗證其他節點的事務列表是有效的，然後接受這個節點轉而嘗試解決下一個節點。

**這就讓我們的隨機數函數變得可利用了**

我們假設我們有一個硬幣翻轉合約——正面你贏雙倍錢，反面你輸掉所有的錢。假如它使用上面的方法來決定是正面還是反面 (random >= 50 算正面, random < 50 算反面)。

如果我正運行一個節點，我可以只對我自己的節點發佈一個事務，且不分享它。 我可以運行硬幣翻轉方法來偷窺我的輸贏，如果我輸了，我就不把這個事務包含進我要解決的下一個區塊中去。我可以一直運行這個方法，直到我贏得了硬幣翻轉，並解決了下一個區塊，然後獲利。

### 所以我們該如何在以太坊上安全地生成隨機數呢

因為區塊鏈的全部內容對所有參與者來說是透明的， 這就讓這個問題變得很難，它的解決方法不在本課程討論範圍，你可以閱讀這個[StackOverflow 上的討論](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract)來獲得一些主意。 一個方法是利用 `oracle` 來訪問以太坊區塊鏈之外的隨機數函數。

當然， 因為網絡上成千上萬的以太坊節點都在競爭解決下一個區塊，我能成功解決下一個區塊的幾率非常之低。這將花費我們巨大的計算資源來開發這個獲利方法，但是如果獎勵異常地高(比如我可以在硬幣翻轉函數中贏得 1個億)， 那就很值得去攻擊了。

所以儘管這個方法在以太坊上不安全，在實際中，除非我們的隨機函數有一大筆錢在上面，你遊戲的用戶一般是沒有足夠的資源去攻擊的。

因為在這個教程中，我們只是在編寫一個簡單的遊戲來做演示，也沒有真正的錢在裡面，所以我們決定接受這個不足之處，使用這個簡單的隨機數生成函數。但是要謹記它是不安全的。

### 實戰練習

```
pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }
}
```

## 第5章：殭屍對戰

我們的合約已經有了一些隨機性的來源，可以用進我們的殭屍戰鬥中去計算結果。

我們的殭屍戰鬥看起來將是這個流程：

* 你選擇一個自己的殭屍，然後選擇一個對手的殭屍去攻擊。
* 如果你是攻擊方，你將有70%的幾率獲勝，防守方將有30%的幾率獲勝。
* 所有的殭屍（攻守雙方）都將有一個 winCount 和一個 lossCount，這兩個值都將根據戰鬥結果增長。
* 若攻擊方獲勝，這個殭屍將升級並產生一個新殭屍。
* 如果攻擊方失敗，除了失敗次數將加一外，什麼都不會發生。
* 無論輸贏，當前殭屍的冷卻時間都將被激活。
* 這有一大堆的邏輯需要處理，我們將把這些步驟分解到接下來的課程中去。

### 實戰練習

```
pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external {
    
  }
}
```

## 第6章：重構通用邏輯

不管誰調用我們的 `attack` 函數，我們想確保用戶的確擁有他們用來攻擊的殭屍。如果你能用其他人的殭屍來攻擊將是一個很大的安全問題。

你想一想，我們要如何添加一個檢查步驟，來看看調用這個函數的人，就是他們傳入的 _zombieId 的擁有者，看看你能不能自己找到一些答案。

花點時間…… 參考我們前面課程的代碼來獲得靈感。

答案在下面，在你有一些想法之前不要繼續閱讀。

答案

我們在前面的課程裡面已經做過很多次這樣的檢查了。 在 `changeName()`, `changeDna()`, 和 `feedAndMultiply()` 裡，我們做過這樣的檢查：

```
require(msg.sender == zombieToOwner[_zombieId]);
```

這和我們 `attack` 函數將要用到的檢查邏輯是相同的。 正因我們要多次調用這個檢查邏輯，讓我們把它移到它自己的 modifier 中來清理代碼，並避免重複編碼。

### 實戰練習

```
  modifier ownerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal ownerOf(_zombieId) {
  }
```

#### 完整範例

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

  modifier ownerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
```

## 第7章：更多重構

在 `zombiehelper.sol` 裡有幾處地方，需要我們實現我們新的 modifier `ownerOf`。

### 實戰演習

```
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
      zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
      zombies[_zombieId].dna = _newDna;
  }
```

* 修改 `changeName()` 使其使用 `ownerOf`
* 修改 `changeDna()` 使其使用 `ownerOf`

```
pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
      zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
      zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
```

## 第8章：回到攻擊

重構完成了，回到 `zombieattack.sol`。

繼續來完善我們的 `attack` 函數， 現在我們有了 `ownerOf` 修飾符來用了。

### 實戰演習

1. 將 `ownerOf` 修飾符添加到 `attack` 來確保調用者擁有 `_zombieId`
2. 我們的函數所需要做的第一件事就是獲得一個雙方殭屍的 `storage` 指針， 這樣我們才能很方便和它們交互：
  * 定義一個 `Zombie storage` 命名為 `myZombie`，使其值等於 `zombies[_zombieId]`。
  * 定義一個 `Zombie storage` 命名為 `enemyZombie`， 使其值等於 `zombies[_targetId]`。
3. 我們將用一個 0 到 100 的隨機數來確定我們的戰鬥結果。 定義一個 `uint`，命名為 `rand`，設定其值等於 `randMod` 函數的返回值，此函數傳入 100 作為參數。

### 實戰練習

```
pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
  }
}
```

## 第9章：殭屍的輸贏

對我們的殭屍遊戲來說，我們將要追蹤我們的殭屍輸贏了多少場。有了這個我們可以在遊戲裡維護一個「殭屍排行榜」。

有多種方法在我們的 DApp 裡面保存一個數值，作為一個單獨的 mapping，作為一個「排行榜」結構體，或者保存在 `Zombie` 結構體內。

每個方法都有其優缺點，取決於我們打算如何和這些數據打交道。在這個教程中，簡單起見我們將這個狀態保存在 `Zombie` 結構體中，將其命名為 `winCount` 和 `lossCount。`

我們跳回 `zombiefactory.sol`, 將這些屬性添加進 `Zombie` 結構體。

### 實戰練習

1. 修改 Zombie 結構體，添加兩個屬性:
  * winCount, 一個 uint16
  * lossCount, 也是一個 uint16
  * 注意： 記住, 因為我們能在結構體中包裝uint, 我們打算用適合我們的最小的 uint。 一個 uint8 太小了， 因為 2^8 = 256 —— 如果我們的殭屍每天都作戰，不到一年就溢出了。但是 2^16 = 65536 （uint16）—— 除非一個殭屍連續179年每天作戰，否則我們就是安全的。
1. 現在我們的 Zombie 結構體有了新的屬性， 我們需要修改 _createZombie() 中的函數定義。修改殭屍生成定義，讓每個新殭屍都有 0 贏和 0 輸。

```
  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  function _createZombie(string _name, uint _dna) internal {
    uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender]++;
    NewZombie(id, _name, _dna);
  }
```

### 完整範例

```
pragma solidity ^0.4.19;

import "./ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
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

## 第10章：殭屍勝利了 😄

有了 `winCount` 和 `lossCount`，我們可以根據殭屍哪個殭屍贏了戰鬥來更新它們了。

在第六章我們計算出來一個 0 到 100 的隨機數。現在讓我們用那個數來決定那誰贏了戰鬥，並以此更新我們的狀態。

### 實戰練習

1. 創建一個 if 語句來檢查 `rand` 是不是 小於或者等於 `attackVictoryProbability。`
1. 如果以上條件為 true， 我們的殭屍就贏了！所以：
  1. 增加 `myZombie` 的 `winCount。`
  1. 增加 `myZombie` 的 `level`。
  1. 增加 `enemyZombie` 的 `lossCount`.
  1. 運行 `feedAndMultiply` 函數。 在 `zombiefeeding.sol` 裡查看調用它的語句。 對於第三個參數 (_species)，傳入字符串 "zombie". （現在它實際上什麼都不做，不過在稍後， 如果我們願意，可以添加額外的方法，用來製造殭屍變的殭屍）。

```
pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
        myZombie.winCount++;
        myZombie.level++;
        enemyZombie.lossCount++;
        feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    }
  }
}
```

## 第11章: 殭屍失敗 😞

我們已經編寫了你的殭屍贏了之後會發生什麼， 該看看 輸了 的時候要怎麼做了。

在我們的遊戲中，殭屍輸了後並不會降級 —— 只是簡單地給 `lossCount` 加一，並觸發冷卻，等待一天後才能再次參戰。

要實現這個邏輯，我們需要一個 `else` 語句。

else 語句和 JavaScript 以及很多其他語言的 else 語句一樣。

```
if (zombieCoins[msg.sender] > 100000000) {
  // 你好有錢!!!
} else {
  // 我們需要更多的殭屍幣...
}
```

### 實戰練習

1. 添加一個 else 語句。 若我們的殭屍輸了：
  1. 增加 myZombie 的 lossCount。
  1. 增加 enemyZombie 的 winCount。
1. 在 else 最後， 對 myZombie 運行 _triggerCooldown 方法。這讓每個殭屍每天只能參戰一次。

```
pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } else {
      myZombie.lossCount++;
      enemyZombie.winCount++;
      _triggerCooldown(myZombie);
    }
  }
}
```

## 第12章：放在一起

恭喜你啊，又完成了第四課。

在右邊測試你的戰鬥函數把。

### 認領你的戰利品

在贏了戰鬥之後：

1. 你的殭屍將會升級
1. 你殭屍的 winCount 將會增加
1. 你將為你的殭屍大軍獲得一個新的殭屍

繼續測試戰鬥，玩夠了以後點擊下一章來完成本課。