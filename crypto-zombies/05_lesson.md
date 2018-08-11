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