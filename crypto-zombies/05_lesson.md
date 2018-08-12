# 第五章：ERC721 標準和加密收藏品

呼，遊戲變得越來越刺激啦...

在這一課，我們將接觸到一些更高級的東西。

我們將討論`代幣`, `ERC721 標準`, 以及`加密收集資產`.

換句話說，我們將讓你可以和你的朋友交易殭屍!

少年，準備開始了嗎?

## 第1章: 以太坊上的代幣

讓我們來聊聊`代幣`.

如果你對以太坊的世界有一些瞭解，你很可能聽過人們聊到代幣，尤其是 `ERC20 代幣`.

一個`代幣`在以太坊基本上就是一個遵循一些共同規則的智能合約，即它實現了所有其他代幣合約共享的一組標準函數，例如 `transfer(address _to, uint256 _value)` 和 `balanceOf(address _owner)`.

在智能合約內部，通常有一個映射， `mapping(address => uint256) balances`，用於追蹤每個地址還有多少餘額。

所以基本上一個代幣只是一個追蹤誰擁有多少該代幣的合約，和一些可以讓那些用戶將他們的代幣轉移到其他地址的函數。

### 它為什麼重要呢？

由於所有 ERC20 代幣共享具有相同名稱的同一組函數，它們都可以以相同的方式進行交互。

這意味著如果你構建的應用程序能夠與一個 ERC20 代幣進行交互，那麼它就也能夠與任何 ERC20 代幣進行交互。 這樣一來，將來你就可以輕鬆地將更多的代幣添加到你的應用中，而無需進行自定義編碼。 你可以簡單地插入新的代幣合約地址，然後嘩啦，你的應用程序有另一個它可以使用的代幣了。

其中一個例子就是交易所。當交易所添加一個新的 ERC20 代幣時，實際上它只需要添加與之對話的另一個智能合約。用戶可以讓那個合約將代幣發送到交易所的錢包地址，然後交易所可以讓合約在用戶要求取款時，將代幣發送回給他們。

交易所只需要實現這種轉移邏輯一次，然後當它想要添加一個新的 ERC20 代幣時，只需將新的合約地址添加到它的資料庫即可。

### 其他代幣標準

對於像貨幣一樣的代幣來說，ERC20 代幣非常酷。 但是要在我們殭屍遊戲中代表殭屍，就並不是特別有用。

首先，殭屍不像貨幣可以分割，我可以發給你 0.237 以太，但是轉移給你 0.237 的殭屍聽起來，就有些搞笑。

其次，並不是所有殭屍都是平等的。 你的2級殭屍"Steve"完全不能等同於我732級的殭屍"H4XF13LD MORRIS 💯💯😎💯💯"。（你差得遠呢，Steve）。

有另一個代幣標準更適合如 CryptoZombies 這樣的`加密收藏品`，它們被稱為`ERC721 代幣`.

**ERC721 代幣是不能互換的，因為每個代幣都被認為是唯一且不可分割的。 你只能以整個單位交易它們，並且每個單位都有唯一的 ID。 這些特性正好讓我們的殭屍可以用來交易。**

> 請注意，使用像 ERC721 這樣的標準的優勢就是，我們不必在我們的合約中實現拍賣或託管邏輯，這決定了玩家能夠如何交易／出售我們的殭屍。 如果我們符合規範，其他人可以為加密可交易的 ERC721 資產搭建一個交易所平台，我們的 ERC721 殭屍將可以在該平台上使用。 所以使用代幣標準相較於使用你自己的交易邏輯有明顯的好處。

### 實戰練習

```
pragma solidity ^0.4.19;

import "./zombieattack.sol";

contract ZombieOwnership is ZombieAttack {

}
```

## 第2章：ERC721 標準, 多重繼承

讓我們來看一看 `ERC721` 標準：

```
contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function transfer(address _to, uint256 _tokenId) public;
  function approve(address _to, uint256 _tokenId) public;
  function takeOwnership(uint256 _tokenId) public;
}
```

這是我們需要實現的方法列表，我們將在接下來的章節中逐個學習。

雖然看起來很多，但不要被嚇到了！我們在這裡就是準備帶著你一步一步瞭解它們的。

> 注意： `ERC721`目前是一個`草稿`，還沒有正式商定的實現。在本教程中，我們使用的是`OpenZeppelin`庫中的當前版本，但在未來正式發佈之前它可能會有更改。所以把這 一個`可能`的實現當作考慮，但不要把它作為 ERC721 代幣的官方標準。

### 實現一個代幣合約

在實現一個代幣合約的時候，我們首先要做的是將接口複製到它自己的 Solidity 文件並導入它，`import "./erc721.sol";`。 接著，讓我們的合約繼承它，然後我們用一個函數定義來重寫每個方法。

但等一下，`ZombieOwnership`已經繼承自`ZombieAttack`了，它如何能夠也繼承於`ERC721`呢？

幸運的是在Solidity，你的合約可以繼承自多個合約，參考如下：

```
contract SatoshiNakamoto is NickSzabo, HalFinney {

}
```

正如你所見，當使用多重繼承的時候，你只需要用逗號 `,` 來隔開幾個你想要繼承的合約。在上面的例子中，我們的合約繼承自 `NickSzabo` 和 `HalFinney。`

來試試吧。

### 實戰練習

我們已經在上面為你創建了帶著接口的 `erc721.sol`

1. 將 `erc721.sol` 導入到 `zombieownership.sol`
1. 聲明 `ZombieOwnership` 繼承自 `ZombieAttack` 和 `ERC721`

```
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

}
```

## 第3章：balanceOf 和 ownerOf

太棒了，我們來深入討論一下 ERC721 的實現。

我們已經把所有你需要在本課中實現的函數的空殼複製好了。

在本章節，我們將實現頭兩個方法： `balanceOf` 和 `ownerOf`。

### balanceOf

```
  function balanceOf(address _owner) public view returns (uint256 _balance);
```

這個函數只需要一個傳入 `address` 參數，然後返回這個 `address` 擁有多少代幣。

在我們的例子中，我們的「代幣」是殭屍。你還記得在我們 DApp 的哪裡存儲了一個主人擁有多少隻殭屍嗎？

### ownerOf

```
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
```

這個函數需要傳入一個代幣 ID 作為參數 (我們的情況就是一個殭屍 ID)，然後返回該代幣擁有者的 `address`。

同樣的，因為在我們的 DApp 裡已經有一個 `mapping` (映射) 存儲了這個信息，所以對我們來說這個實現非常直接清晰。我們可以只用一行 `return` 語句來實現這個函數。

> 注意：要記得，`uint256` 等同於 `uint`。我們從課程的開始一直在代碼中使用 `uint`，但從現在開始我們將在這裡用 `uint256`，因為我們直接從規範中複製粘貼。

### 實戰演習

我將讓你來決定如何實現這兩個函數。

每個函數的代碼都應該只有1行 `return` 語句。看看我們在之前課程中寫的代碼，想想我們都把這個數據存儲在哪。如果你覺得有困難，你可以點“我要看答案”的按鈕來獲得幫助。

1. 實現 `balanceOf` 來返回 `_owner` 擁有的殭屍數量。
1. 實現 `ownerOf` 來返回擁有 ID 為 `_tokenId` 殭屍的所有者的地址。

```
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  function transfer(address _to, uint256 _tokenId) public {

  }

  function approve(address _to, uint256 _tokenId) public {

  }

  function takeOwnership(uint256 _tokenId) public {

  }
}
```

## 第4章: 重構

嘿嘿！我們剛剛的代碼中其實有個錯誤，以至於其根本無法通過編譯，你發現了沒？

在前一個章節我們定義了一個叫 `ownerOf` 的函數。但如果你還記得第4課的內容，我們同樣在 `zombiefeeding.sol` 裡以 `ownerOf` 命名創建了一個 `modifier`（修飾符）。

如果你嘗試編譯這段代碼，編譯器會給你一個錯誤說你不能有相同名稱的修飾符和函數。

所以我們應該把在 `ZombieOwnership` 裡的函數名稱改成別的嗎？

不，我們不能那樣做！！！要記得，我們正在用 ERC721 代幣標準，意味著其他合約將期望我們的合約以這些確切的名稱來定義函數。這就是這些標準實用的原因。如果另一個合約知道我們的合約符合 ERC721 標準，它可以直接與我們交互，而無需瞭解任何關於我們內部如何實現的細節。

所以，那意味著我們將必須重構我們第4課中的代碼，將 `modifier` 的名稱換成別的。

### 實戰練習

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

  modifier onlyOwnerOf(uint _zombieId) {
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

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId) {
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

## 第5章：ERC721 轉移標準

好了，我們將衝突修復了！

**現在我們將通過學習把所有權從一個人轉移給另一個人來繼續我們的 ERC721 規範的實現。**

注意 ERC721 規範有兩種不同的方法來轉移代幣：

```
function transfer(address _to, uint256 _tokenId) public;
function approve(address _to, uint256 _tokenId) public;
function takeOwnership(uint256 _tokenId) public;
```

1. 第一種方法是代幣的擁有者調用 `transfer` 方法，傳入他想轉移到的 `address` 和他想轉移的代幣的 `_tokenId`。
1. 第二種方法是代幣擁有者首先調用 `approve`，然後傳入與以上相同的參數。接著，該合約會存儲誰被允許提取代幣，通常存儲到一個 `mapping (uint256 => address)` 裡。然後，當有人調用 `takeOwnership` 時，合約會檢查 `msg.sender` 是否得到擁有者的批准來提取代幣，如果是，則將代幣轉移給他。

你注意到了嗎，`transfer` 和 `takeOwnership` 都將包含相同的轉移邏輯，只是以相反的順序。 （一種情況是代幣的發送者調用函數；另一種情況是代幣的接收者調用它）。

所以我們把這個邏輯抽象成它自己的私有函數 `_transfer`，然後由這兩個函數來調用它。 這樣我們就不用寫重複的代碼了。

### 實戰演習

讓我們來定義 `_transfer` 的邏輯。

1. 定義一個名為 `_transfer` 的函數。它會需要3個參數：`address _from`、`address _to`和`uint256 _tokenId`。它應該是一個`私有`函數。
1. 我們有2個 mapping 會在所有權改變的時候改變： `ownerZombieCount` （記錄一個所有者有多少隻殭屍）和 `zombieToOwner` （記錄殭屍被誰擁有）。我們的函數需要做的第一件事是為`接收`殭屍的人`address _to`增加 `ownerZombieCount`。使用 `++` 來增加。
1. 接下來，我們將需要為 發送`殭屍的人`（address _from）減少 `ownerZombieCount`。使用`--`來扣減。
1. 最後，我們將改變這個 `_tokenId` 的 `zombieToOwner` 映射，這樣它現在就會指向 `_to`。
1. 騙你的，那不是最後一步。我們還需要再做一件事情。

`ERC721`規範包含了一個 `Transfer` 事件。這個函數的最後一行應該用正確的參數觸發 `Transfer` ——查看 `erc721.sol` 看它期望傳入的參數並在這裡實現。

```
contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function transfer(address _to, uint256 _tokenId) public;
  function approve(address _to, uint256 _tokenId) public;
  function takeOwnership(uint256 _tokenId) public;
}
```

```
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
      ownerZombieCount[_to]++;
      ownerZombieCount[_from]--;
      zombieToOwner[_tokenId] = _to;
      Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public {

  }

  function approve(address _to, uint256 _tokenId) public {

  }

  function takeOwnership(uint256 _tokenId) public {

  }
}
```

## 第6章：ERC721: 轉移-續

太好了！剛才那是最難的部分，現在實現 public 的 `transfer` 函數應該十分容易，因為我們的 `_transfer` 函數幾乎已經把所有的重活都幹完了。

### 實戰練習

我們想確保只有代幣或殭屍的所有者可以轉移它。還記得我們如何限制只有所有者才能訪問某個功能嗎？

沒錯，我們已經有一個修飾符能夠完成這個任務了。所以將修飾符 `onlyOwnerOf` 添加到這個函數中。

現在該函數的正文只需要一行代碼。它只需要調用 `_transfer`。

記得把 `msg.sender` 作為參數傳遞進 address `_from`。

```
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId){
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public {

  }

  function takeOwnership(uint256 _tokenId) public {

  }
}
```

## 第7章：ERC721: 批准

現在，讓我們來實現 `approve`。

記住，使用 `approve` 或者 `takeOwnership` 的時候，轉移有2個步驟：

1. 你，作為所有者，用新主人的 `address` 和你希望他獲取的 `_tokenId` 來調用 `approve`
1. 新主人用 `_tokenId` 來調用 `takeOwnership`，合約會檢查確保他獲得了批准，然後把代幣轉移給他。

因為這發生在2個函數的調用中，所以在函數調用之間，我們需要一個數據結構來存儲什麼人被批准獲取什麼。

### 實戰演習

1. 首先，讓我們來定義一個映射 `zombieApprovals`。它應該將一個 `uint` 映射到一個 `address`。這樣一來，當有人用一個 `_tokenId` 調用 `takeOwnership` 時，我們可以用這個映射來快速查找誰被批准獲取那個代幣。
1. 在函數 `approve` 上， 我們想要確保只有代幣所有者可以批准某人來獲取代幣。所以我們需要添加修飾符 `onlyOwnerOf` 到 `approve`。
1. 函數的正文部分，將 `_tokenId` 的 `zombieApprovals` 設置為和 _to 相等。
1. 最後，在 `ERC721` 規範裡有一個 `Approval` 事件。所以我們應該在這個函數的最後觸發這個事件。（參考 `erc721.sol` 來確認傳入的參數，並確保 `_owner` 是 `msg.sender`）

```
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {

  }
}
```

## 第8章: ERC721: takeOwnership

太棒了，現在讓我們完成最後一個函數來結束 ERC721 的實現。（別擔心，這後面我們還會講更多內容😉）

最後一個函數 `takeOwnership`， 應該只是簡單地檢查以確保 `msg.sender` 已經被批准來提取這個代幣或者殭屍。若確認，就調用 `_transfer`；

### 實戰練習

1. 首先，我們要用一個 `require` 句式來檢查 `_tokenId` 的 `zombieApprovals` 和 `msg.sender` 相等。這樣如果 `msg.sender` 未被授權來提取這個代幣，將拋出一個錯誤。
1. 為了調用 `_transfer`，我們需要知道代幣所有者的地址（它需要一個 `_from` 來作為參數）。幸運的是我們可以在我們的 `ownerOf` 函數中來找到這個參數。所以，定義一個名為 `owner` 的 `address` 變量，並使其等於 `ownerOf(_tokenId)`。
1. 最後，調用 `_transfer`, 並傳入所有必須的參數。（在這裡你可以用 `msg.sender` 作為 `_to`， 因為代幣正是要發送給調用這個函數的人）。

注意： 我們完全可以用一行代碼來實現第2、3兩步。但是分開寫會讓代碼更易讀。一點個人建議 :)

```
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(zombieApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
```

## 第9章: 預防溢出

恭喜你，我們完成了 ERC721 的實現。

並不是很複雜，對吧？很多類似的以太坊概念，當你只聽人們談論它們的時候，會覺得很複雜。所以最簡單的理解方式就是你自己來實現它。

不過要記住那只是最簡單的實現。還有很多的特性我們也許想加入到我們的實現中來，比如一些額外的檢查，來確保用戶不會不小心把他們的殭屍轉移給`0`地址（這被稱作 “燒幣”, 基本上就是把代幣轉移到一個誰也沒有私鑰的地址，讓這個代幣永遠也無法恢復）。 或者在 DApp 中加入一些基本的拍賣邏輯。（你能想出一些實現的方法麼？）

但是為了讓我們的課程不至於離題太遠，所以我們只專注於一些基礎實現。如果你想學習一些更深層次的實現，可以在這個教程結束後，去看看 OpenZeppelin 的 ERC721 合約。

### 合約安全增強: 溢出和下溢

我們將來學習你在編寫智能合約的時候需要注意的一個主要的安全特性：防止溢出和下溢。

#### 什麼是 溢出 (overflow)?

假設我們有一個 `uint8`, 只能存儲8 bit數據。這意味著我們能存儲的最大數字就是二進制 `11111111` (或者說十進制的 2^8 - 1 = 255).

來看看下面的代碼。最後 `number` 將會是什麼值？

```
uint8 number = 255;
number++;
```

在這個例子中，我們導致了溢出，雖然我們加了 `1`， 但是 `number` 出乎意料地等於 `0` 了。 (如果你給二進制 `11111111` 加`1`, 它將被重置為 `00000000`，就像鐘錶從 `23:59` 走向 `00:00`)。

下溢(`underflow`)也類似，如果你從一個等於 `0` 的 `uint8` 減去 `1`, 它將變成 `255` (因為 `uint` 是無符號的，其不能等於負數)。

雖然我們在這裡不使用 `uint8`，而且每次給一個 `uint256` 加 `1` 也不太可能溢出 (2^256 真的是一個很大的數了)，在我們的合約中添加一些保護機制依然是非常有必要的，以防我們的 DApp 以後出現什麼異常情況。

### 使用 SafeMath

為了防止這些情況，OpenZeppelin 建立了一個叫做 SafeMath 的`函式庫(library)`，默認情況下可以防止這些問題。

不過在我們使用之前，什麼叫做函式庫?

一個 `library` 是 Solidity 中一種特殊的合約。其中一個有用的功能是**給原始數據類型增加一些方法**。

比如，使用 SafeMath 庫的時候，我們將使用 `using SafeMath for uint256` 這樣的語法。 SafeMath 庫有四個方法，`add`、`sub`、`mul`，以及 `div`。現在我們可以這樣來讓 `uint256` 調用這些方法：

```
using SafeMath for uint256;

uint256 a = 5;
uint256 b = a.add(3); // 5 + 3 = 8
uint256 c = a.mul(2); // 5 * 2 = 10
```

我們將在下一章來學習這些方法，不過現在我們先將 SafeMath 庫添加進我們的合約。

### 實戰練習

我們已經幫你把 OpenZeppelin 的 `SafeMath` 庫包含進 `safemath.sol` 了，如果你想看一下代碼的話，現在可以看看，不過我們下一章將深入進去。

首先我們來告訴我們的合約要使用 SafeMath。我們將在我們的 `ZombieFactory` 裡調用，這是我們的基礎合約 — 這樣其他所有繼承出去的子合約都可以使用這個庫了。

1. 將 `safemath.sol` 引入到 `zombiefactory.sol`
1. 添加定義： `using SafeMath for uint256;`.

```
pragma solidity ^0.4.18;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

```

```
pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract ZombieFactory is Ownable {

  using safemath for uint256;

}
```