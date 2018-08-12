# 第六章：應用前端和 Web3.js

喲，你都學到這裡來啦。

你真是個了不得的 CryptoZombie...

通過前五課的學習，相信你已經有了紮實的 Solidity 基礎.

但是若沒有一個互動界面讓用戶來使用，一個 DApp 就不能稱之為完整。

在這一課，我們將來學習如果用一個名為 `Web3.js` 的庫來為你的 DApp 創建一個基本的前端界面，和你的智能合約交互。

需要注意的是這個 APP 界面將使用 `JavaScript` 來寫，並不是 Solidity。因為我們的課程專注於 Ethereum / Solidity，我們就暫時假定你已經會用HTML, JavaScript(包括 `ES6 promises`)，以及 JQuery 寫網站了。因此我們不會花時間來介紹這些技術的基礎知識。

如果你還不會用 HTML/JavaScript 來寫網站，你應該先去學習一下這方面的基礎知識再來繼續接下來的課程。

少年，準備開始了嗎?

## 第1章：介紹 Web3.js

完成第五課以後，我們的殭屍 DApp 的 Solidity 合約部分就完成了。現在我們來做一個基本的網頁好讓你的用戶能玩它。 要做到這一點，我們將使用以太坊基金發佈的 JavaScript 庫 `Web3.js`.

### 什麼是 Web3.js?

還記得麼？以太坊網絡是由節點組成的，每一個節點都包含了區塊鏈的一份拷貝。當你想要調用一份智能合約的一個方法，你需要從其中一個節點中查找並告訴它:

1. 智能合約的地址
1. 你想調用的方法，以及
1. 你想傳入那個方法的參數

以太坊節點只能識別一種叫做 `JSON-RPC` 的語言。這種語言直接讀起來並不好懂。當你你想調用一個合約的方法的時候，需要發送的查詢語句將會是這樣的：

```
{
   "jsonrpc":"2.0",
   "method":"eth_sendTransaction",
   "params":[
      {
         "from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155",
         "to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567",
         "gas":"0x76c0",
         "gasPrice":"0x9184e72a000",
         "value":"0x9184e72a",
         "data":"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"
      }
   ],
   "id":1
}
```

幸運的是 Web3.js 把這些令人討厭的查詢語句都隱藏起來了，所以你只需要與方便易懂的 JavaScript 界面進行交互即可。

你不需要構建上面的查詢語句，在你的代碼中調用一個函數看起來將是這樣：

```js
CryptoZombies.methods.createRandomZombie("Vitalik Nakamoto 🤔")
  .send({ from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "3000000" })
```

我們將在接下來的幾章詳細解釋這些語句，不過首先我們來把 Web3.js 環境搭建起來。

### 準備好了麼？

取決於你的項目工作流程和你的愛好，你可以用一些常用工具把 Web3.js 添加進來：

```
// 用 NPM
npm install web3

// 用 Yarn
yarn add web3

// 用 Bower
bower install web3

// ...或者其他。
```

甚至，你可以從 `github` 直接下載壓縮後的 `.js` 文件 然後包含到你的項目文件中：

```html
<script language="javascript" type="text/javascript" src="web3.min.js"></script>
```

因為我們不想讓你花太多在項目環境搭建上，在本教程中我們將使用上面的 `script` 標籤來將 Web3.js 引入。

### 實戰演習

我們為你建立了一個HTML 項目空殼，`index.html`。假設在和 `index.html` 同個文件夾裡有一份 `web3.min.js`

1. 使用上面的 `script` 標籤代碼把 `web3.js` 添加進去以備接下來使用。

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
  </head>
  <body>

  </body>
</html>
```

## 第2章: Web3 提供者

太棒了。現在我們的項目中有了Web3.js, 來初始化它然後和區塊鏈對話吧。

首先我們需要 `Web3 Provider`.

要記住，以太坊是由共享同一份數據的相同拷貝的`節點`構成的。 在 Web3.js 裡設置 Web3 的 `Provider`（提供者）告訴我們的代碼應該和`哪個節點`交互來處理我們的讀寫。這就好像在傳統的 Web 應用程序中為你的 API 調用設置遠程 Web 服務器的網址。

你可以運行你自己的以太坊節點來作為 Provider。 不過，有一個第三方的服務，可以讓你的生活變得輕鬆點，讓你不必為了給你的用戶提供DApp而維護一個以太坊節點`Infura`.

### Infura

Infura 是一個服務，它維護了很多以太坊節點，並提供了一個緩存層來實現高速讀取。你可以用他們的 API 來免費訪問這個服務。 用 Infura 作為節點提供者，你可以不用自己運營節點就能很可靠地向以太坊發送、接收信息。

你可以通過這樣把 Infura 作為你的 Web3 節點提供者：

```js
var web3 = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));
```

不過，因為我們的 DApp 將被很多人使用，這些用戶不單會從區塊鏈讀取信息，還會向區塊鏈`寫`入信息，我們需要用一個方法讓用戶可以用他們的私鑰給事務簽名。

> 注意: 以太坊 (以及通常意義上的 blockchains )使用一個公鑰/私鑰對來對給事務做數字簽名。把它想成一個數字簽名的異常安全的密碼。這樣當我修改區塊鏈上的數據的時候，我可以用我的公鑰來**證明**我就是簽名的那個。但是因為沒人知道我的私鑰，所以沒人能偽造我的事務。

加密學非常複雜，所以除非你是個專家並且的確知道自己在做什麼，你最好不要在你應用的前端中管理你用戶的私鑰。

不過幸運的是，你並不需要，已經有可以幫你處理這件事的服務了：`Metamask`
