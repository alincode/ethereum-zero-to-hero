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