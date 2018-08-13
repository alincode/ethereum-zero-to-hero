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

### 什麼是 Web3.js？

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

### Metamask

`Metamask` 是 Chrome 和 Firefox 的瀏覽器擴展， 它能讓用戶安全地維護他們的以太坊賬戶和私鑰， 並用他們的賬戶和使用 Web3.js 的網站互動（如果你還沒用過它，你肯定會想去安裝的，這樣你的瀏覽器就能使用 Web3.js 了，然後你就可以和任何與以太坊區塊鏈通信的網站交互了）

作為開發者，如果你想讓用戶從他們的瀏覽器裡通過網站和你的DApp交互（就像我們在 CryptoZombies 遊戲裡一樣），你肯定會想要兼容 Metamask 的。

> 注意: Metamask 默認使用 Infura 的服務器做為 web3 提供者。 就像我們上面做的那樣。不過它還為用戶提供了選擇他們自己 Web3 提供者的選項。所以使用 Metamask 的 web3 提供者，你就給了用戶選擇權，而自己無需操心這一塊。

### 使用 Metamask 的 web3 提供者

Metamask 把它的 web3 提供者注入到瀏覽器的全局 JavaScript對象`web3`中。所以你的應用可以檢查 `web3` 是否存在。若存在就使用 `web3.currentProvider` 作為它的提供者。

這裡是一些 Metamask 提供的示例代碼，用來檢查用戶是否安裝了 MetaMask，如果沒有安裝就告訴用戶需要安裝 MetaMask 來使用我們的應用。

```js
window.addEventListener('load', function() {

  // 檢查web3是否已經注入到(Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // 使用 Mist/MetaMask 的提供者
    web3js = new Web3(web3.currentProvider);
  } else {
    // 處理用戶沒安裝的情況， 比如顯示一個消息
    // 告訴他們要安裝 MetaMask 來使用我們的應用
  }

  // 現在你可以啟動你的應用並自由訪問 Web3.js:
  startApp()
})
```

你可以在你所有的應用中使用這段樣板代碼，好檢查用戶是否安裝以及告訴用戶安裝 MetaMask。

> 注意: 除了MetaMask，你的用戶也可能在使用其他他的私鑰管理應用，比如 `Mist` 瀏覽器。不過，它們都實現了相同的模式來注入 `web3` 變量。所以我這裡描述的方法對兩者是通用的。

### 實戰練習

我們在HTML文件中的 `</body>` 標籤前面放置了一個空的 `script` 標籤。可以把這節課的 JavaScript 代碼寫在裡面。

把上面用來檢測 MetaMask 是否安裝的模板代碼粘貼進來。請粘貼到以 `window.addEventListener` 開頭的代碼塊中。

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

    <script>
      window.addEventListener('load', function() {

      // 檢查web3是否已經注入到(Mist/MetaMask)
      if (typeof web3 !== 'undefined') {
        // 使用 Mist/MetaMask 的提供者
        web3js = new Web3(web3.currentProvider);
      } else {
        // 處理用戶沒安裝的情況， 比如顯示一個消息
        // 告訴他們要安裝 MetaMask 來使用我們的應用
      }

      // 現在你可以啟動你的應用並自由訪問 Web3.js:
      startApp()

    })
    </script>
  </body>
</html>
```

## 第3章: 和合約對話

現在，我們已經用 MetaMask 的 Web3 提供者初始化了 Web3.js。接下來就讓它和我們的智能合約對話吧。

Web3.js 需要兩個東西來和你的合約對話: 它的**地址**和它的**ABI**。

### 合約地址

在你寫完了你的智能合約後，你需要編譯它並把它部署到以太坊。我們將在下一課中詳述部署，因為它和寫代碼是截然不同的過程，所以我們決定打亂順序，先來講 Web3.js。

在你部署智能合約以後，它將獲得一個以太坊上的永久地址。如果你還記得第二課，CryptoKitties 在以太坊上的地址是 `0x06012c8cf97BEaD5deAe237070F9587f8E7A266d`。

你需要在部署後複製這個地址以來和你的智能合約對話。

### 合約 ABI

另一個 Web3.js 為了要和你的智能合約對話而需要的東西是**ABI**。

ABI 意為應用二進制接口（`Application Binary Interface`）。基本上，它是以 JSON 格式表示合約的方法，告訴 Web3.js 如何以合同理解的方式格式化函數調用。

當你編譯你的合約向以太坊部署時(我們將在第七課詳述)， Solidity 編譯器會給你 ABI，所以除了合約地址，你還需要把這個也複製下來。

因為我們這一課不會講述部署，所以現在我們已經幫你編譯了 ABI 並放在了名為 `cryptozombies_abi.js`，文件中，保存在一個名為 `cryptoZombiesABI` 的變量中。

如果我們將 `cryptozombies_abi.js` 包含進我們的項目，我們就能通過那個變量訪問 CryptoZombies ABI 。

### 實例化 Web3.js

一旦你有了合約的地址和 ABI，你可以像這樣來實例化 Web3.js。

```js
// 實例化 myContract
var myContract = new web3js.eth.Contract(myABI, myContractAddress);
```

### 實戰演習

1. 在文件的 `<head>` 標籤塊中，用 `script` 標籤引入`cryptozombies_abi.js`，好把 ABI 的定義引入項目。
1. 在 `<body>` 裡的 `<script>` 開頭，定義一個`var`，取名`cryptoZombies`， 不過不要對其賦值，稍後我們將用這個這個變量來存儲我們實例化合約。
1. 接下來，創建一個名為 `startApp()` 的 `function`。 接下來兩步來完成這個方法。
1. `startApp()` 裡應該做的第一件事是定義一個名為 `cryptoZombiesAddress` 的變量並賦值為「你的合約地址」 (這是你的合約在以太坊主網上的地址)。
1. 最後，來實例化我們的合約。模仿我們上面的代碼，將 `cryptoZombies` 賦值為 `new web3js.eth.Contract` (使用我們上面代碼中通過 `script` 引入的 `cryptoZombiesABI` 和 `cryptoZombiesAddress`)。

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>

    <script>
      var cryptoZombies;

      function startApp() {
        var cryptoZombiesAddress = "你的合约地址";
        cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);
      }

      window.addEventListener('load', function() {

        // Checking if Web3 has been injected by the browser (Mist/MetaMask)
        if (typeof web3 !== 'undefined') {
          // Use Mist/MetaMask's provider
          web3js = new Web3(web3.currentProvider);
        } else {
          // Handle the case where the user doesn't have Metamask installed
          // Probably show them a message prompting them to install Metamask
        }

        // Now you can start your app & access web3 freely:
        startApp()

      })
    </script>
  </body>
</html>
```

## 第4章: 調用和合約函數

我們的合約配置好了！現在來用 Web3.js 和它對話。

Web3.js 有兩個方法來調用我們合約的函數: `call` and `send`.

### Call

`call` 用來調用 `view` 和 `pure` 函數。它只運行在本地節點，不會在區塊鏈上創建事務。

> 複習: `view` 和 `pure` 函數是只讀，並不會改變區塊鏈的狀態。它們也不會消耗任何gas。用戶也不會被要求用MetaMask對事務簽名。

使用 Web3.js，你可以如下 `call` 一個名為`myMethod`的方法並傳入一個 `123` 作為參數：

```js
myContract.methods.myMethod(123).call();
```

### Send

`send` 將創建一個事務並改變區塊鏈上的數據。你需要用 `send` 來調用任何非 `view` 或者 `pure` 的函數。

> 注意: `send` 一個事務將要求用戶支付gas，並會要求彈出對話框請求用戶使用 Metamask 對事務簽名。在我們使用 Metamask 作為我們的 web3 提供者的時候，所有這一切都會在我們調用 `send()` 的時候自動發生。而我們自己無需在代碼中操心這一切，挺爽的吧。

使用 Web3.js, 你可以像這樣 `send` 一個事務調用 `myMethod` 並傳入 `123` 作為參數：

```js
myContract.methods.myMethod(123).send()
```

語法幾乎 `call()` 一模一樣。

### 獲取殭屍數據

來看一個使用 call 讀取我們合約數據的真實例子

回憶一下，我們定義我們的殭屍數組為 公開(public):

```
Zombie[] public zombies;
```

在 Solidity 裡，當你定義一個 `public` 變量的時候， 它將自動定義一個公開的 "getter" 同名方法， 所以如果你像要查看 id 為 `15` 的殭屍，你可以像一個函數一樣調用它： `zombies(15)`.

這是如何在外面的前端界面中寫一個 JavaScript 方法來傳入一個殭屍 id，在我們的合同中查詢那個殭屍並返回結果

> 注意: 本課中所有的示例代碼都使用 Web3.js 的 1.0 版，此版本使用的是 Promises 而不是回調函數。你在線上看到的其他教程可能還在使用老版的 Web3.js。在1.0版中，語法改變了不少。如果你從其他教程中複製代碼，先確保你們使用的是相同版本的Web3.js。

```js
function getZombieDetails(id) {
  return cryptoZombies.methods.zombies(id).call();
}

// 調用函數並做一些其他事情
getZombieDetails(15)
.then(function(result) {
  console.log("Zombie 15: " + JSON.stringify(result));
});
```

我們來看看這裡都做了什麼

`cryptoZombies.methods.zombies(id).call()` 將和 Web3 提供者節點通信，告訴它返回從我們的合約中的 `Zombie[] public zombies`，`id`為傳入參數的殭屍信息。

注意這是**異步的**，就像從外部服務器中調用API。所以 Web3 在這裡返回了一個 Promises. (如果你對 JavaScript的 Promises 不瞭解，最好先去學習一下這方面知識再繼續)。

一旦那個 `promise` 被 `resolve`，(意味著我們從 Web3 提供者那裡獲得了響應)，我們的例子代碼將執行 `then` 語句中的代碼，在控制台打出 `result`。

result 是一個像這樣的 JavaScript 對象：

```json
{
  "name": "H4XF13LD MORRIS'S COOLER OLDER BROTHER",
  "dna": "1337133713371337",
  "level": "9999",
  "readyTime": "1522498671",
  "winCount": "999999999",
  "lossCount": "0" // Obviously.
}
```

我們可以用一些前端邏輯代碼來解析這個對象並在前端界面友好展示。

### 實戰練習

我們已經幫你把 `getZombieDetails` 複製進了代碼。

* 先為 `zombieToOwner` 創建一個類似的函數。如果你還記得 `ZombieFactory.sol`，我們有一個長這樣的映射：

```
mapping (uint => address) public zombieToOwner;
```

定義一個 JavaScript 方法，取名為 `zombieToOwner`。和上面的 `getZombieDetails` 類似， 它將接收一個 `id` 作為參數，並返回一個 Web3.js `call` 我們合約裡的 `zombieToOwner`。

* 之後在下面，為 `getZombiesByOwner` 定義一個方法。如果你還能記起 `ZombieHelper.sol`，這個方法定義像這樣：

```js
function getZombiesByOwner(address _owner)
```

我們的 `getZombiesByOwner` 方法將接收 `owner` 作為參數，並返回一個對我們函數 `getZombiesByOwner` 的 Web3.js `call`

### 完整範例

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>

    <script>
      var cryptoZombies;

      function startApp() {
        var cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
        cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);
      }

      function getZombieDetails(id) {
        return cryptoZombies.methods.zombies(id).call()
      }

      function zombieToOwner(id) {
        return cryptoZombies.methods.zombieToOwner(id).call()
      }

      function getZombiesByOwner(owner) {
        return cryptoZombies.methods.getZombiesByOwner(owner).call()
      }

      window.addEventListener('load', function() {

        // Checking if Web3 has been injected by the browser (Mist/MetaMask)
        if (typeof web3 !== 'undefined') {
          // Use Mist/MetaMask's provider
          web3js = new Web3(web3.currentProvider);
        } else {
          // Handle the case where the user doesn't have Metamask installed
          // Probably show them a message prompting them to install Metamask
        }

        // Now you can start your app & access web3 freely:
        startApp()

      })
    </script>
  </body>
</html>
```

## 第5章: MetaMask 和賬戶

太棒了！你成功地寫了一些前端代碼來和你的第一個智能合約交互。

接下來我們綜合一下，比如我們想讓我們應用的首頁顯示用戶的整個殭屍大軍。

毫無疑問我們首先需要用 `getZombiesByOwner(owner)` 來查詢當前用戶的所有殭屍 ID。

但是我們的 Solidity 合約需要 `owner` 作為 Solidity `address`。我們如何能知道應用用戶的地址呢？

### 獲得 MetaMask中的用戶賬戶

MetaMask 允許用戶在擴展中管理多個賬戶。

我們可以通過這樣來獲取 `web3` 變量中激活的當前賬戶：

```js
var userAccount = web3.eth.accounts[0]
```

因為用戶可以隨時在 MetaMask 中切換賬戶，我們的應用需要監控這個變數，一旦改變就要相應更新界面。例如，若用戶的首頁展示它們的殭屍大軍，當他們在 MetaMask 中切換了賬號，我們就需要更新頁面來展示新選擇的賬戶的殭屍大軍。

我們可以通過 `setInterval` 方法來做:

```js
var accountInterval = setInterval(function() {
  // 檢查賬戶是否切換
  if (web3.eth.accounts[0] !== userAccount) {
    userAccount = web3.eth.accounts[0];
    // 調用一些方法來更新界面
    updateInterface();
  }
}, 100);
```

這段代碼做的是，每100毫秒檢查一次 `userAccount` 是否還等於 `web3.eth.accounts[0]` (比如：用戶是否還激活了那個賬戶)。若不等，則將當前激活用戶賦值給 `userAccount`，然後調用一個函數來更新界面。

### 實戰練習

我們來讓應用在頁面第一次加載的時候顯示用戶的殭屍大軍，監控當前 MetaMask 中的激活賬戶，並在賬戶發生改變的時候刷新顯示。

1. 定義一個名為`userAccount`的變量，不給任何初始值。
1. 在 `startApp()` 函數的最後，複製粘貼上面樣板代碼中的 `accountInterval` 方法進去。
1. 將 `updateInterface();` 替換成一個 `getZombiesByOwner` 的 `call` 函數，並傳入 userAccount。
1. 在 `getZombiesByOwner` 後面鏈式調用 `then` 語句，並將返回的結果傳入名為 `displayZombies` 的函數。 (語句像這樣: `.then(displayZombies);`).

我們還沒有 `displayZombies` 函數，將於下一章實現。

#### 完整範例

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>

    <script>
      var cryptoZombies;
      var userAccount;

      function startApp() {
        var cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
        cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);

        var accountInterval = setInterval(function() {
          // 檢查賬戶是否切換
          if (web3.eth.accounts[0] !== userAccount) {
            userAccount = web3.eth.accounts[0];
            // 調用一些方法來更新界面
            getZombiesByOwner(userAccount).then(displayZombies);
          }
        }, 100);
      }

      function getZombieDetails(id) {
        return cryptoZombies.methods.zombies(id).call()
      }

      function zombieToOwner(id) {
        return cryptoZombies.methods.zombieToOwner(id).call()
      }

      function getZombiesByOwner(owner) {
        return cryptoZombies.methods.getZombiesByOwner(owner).call()
      }

      window.addEventListener('load', function() {

        // Checking if Web3 has been injected by the browser (Mist/MetaMask)
        if (typeof web3 !== 'undefined') {
          // Use Mist/MetaMask's provider
          web3js = new Web3(web3.currentProvider);
        } else {
          // Handle the case where the user doesn't have Metamask installed
          // Probably show them a message prompting them to install Metamask
        }

        // Now you can start your app & access web3 freely:
        startApp()

      })
    </script>
  </body>
</html>
```

## 第6章：顯示殭屍大軍

如果我們不向你展示如何顯示你從合約獲取的數據，那這個教程就太不完整了。

在實際應用中，你肯定想要在應用中使用諸如 React 或 Vue.js 這樣的前端框架來讓你的前端開發變得輕鬆一些。不過要教授 React 或者 Vue.js 知識的話，就大大超出了本教程的範疇——它們本身就需要幾節課甚至一整個教程來教學。

所以為了讓 CryptoZombies.io 專注於以太坊和智能合約，我們將使用 JQuery 來做一個快速示例，展示如何解析和展示從智能合約中拿到的數據。

### 顯示殭屍數據：一個簡易的例子

我們已經在代碼中添加了一個空的代碼塊 `<div id="zombies"></div>`， 在 `displayZombies` 方法中也同樣有一個。

回憶一下在之前章節中我們在 `startApp()` 方法內部調用了 `displayZombies` 並傳入了 `call getZombiesByOwner` 獲得的結果，它將被傳入一個殭屍ID數組，像這樣：

```
[0, 13, 47]
```

因為我們想讓我們的 `displayZombies` 方法做這些事:

首先清除 `#zombies` 的內容以防裡面已經有什麼內容（這樣當用戶切換賬號的時候，之前賬號的殭屍大軍數據就會被清除）

循環遍歷 `id`，對每一個id調用 `getZombieDetails(id)`， 從我們的合約中獲得這個殭屍的數據。

將獲得的殭屍數據放進一個HTML模板中以格式化顯示，追加進 `#zombies` 裡面。

再次聲明，我們只用了 JQuery，沒有任何模板引擎，所以會非常醜。不過這只是一個如何展示殭屍數據的示例而已。

```js
// 在合約中查找殭屍數據，返回一個對象
getZombieDetails(id)
.then(function(zombie) {
  // 用 ES6 的模板語法來向HTML中注入變量
  // 把每一個都追加進 #zombies div
  $("#zombies").append(`<div class="zombie">
    <ul>
      <li>Name: ${zombie.name}</li>
      <li>DNA: ${zombie.dna}</li>
      <li>Level: ${zombie.level}</li>
      <li>Wins: ${zombie.winCount}</li>
      <li>Losses: ${zombie.lossCount}</li>
      <li>Ready Time: ${zombie.readyTime}</li>
    </ul>
  </div>`);
});
```

### 如何來展示殭屍元素呢？

在上面的例子中，我們只是簡單地用字符串來顯示 DNA。不過在你的 DApp 中，你將需要把 DNA 轉換成圖片來顯示你的殭屍。

我們通過把 DNA 字符串分割成小的字符串來做到這一點，每2位數字代表一個圖片，類似這樣：

```js
// 得到一個 1-7 的數字來表示殭屍的頭:
var head = parseInt(zombie.dna.substring(0, 2)) % 7 + 1

// 我們有7張頭部圖片：
var headSrc = "../assets/zombieparts/head-" + i + ".png"
每一個模塊都用 CSS 絕對定位來顯示，在一個上面疊加另外一個。
```

如果你想看我們的具體實現，我們將用來展示殭屍形象的 Vue.js 模塊開源了：[點擊這裡](https://github.com/loomnetwork/zombie-char-component).

不過，因為那個文件中有太多行代碼， 超出了本教程的討論範圍。我們依然還是使用上面超級簡單的 JQuery 實現，把美化殭屍的工作作為家庭作業留給你了😉

* [loomnetwork/zombie-char-component - Github](https://github.com/loomnetwork/zombie-char-component)

### 實戰練習

我們為你創建了一個空的 `displayZombies` 方法。來一起實現它。

1. 首先我們需要清空 `#zombies` 的內容。 用JQuery，你可以這樣做： `$("#zombies").empty();`。
1. 接下來，我們要循環遍歷所有的 id，循環這樣用： `for (id of ids) {`
1. 在循環內部，複製粘貼上面的代碼，對每一個id調用 `getZombieDetails(id)`，然後用 `$("#zombies").append(...)` 把內容追加進我們的 HTML 裡面。

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>
    <div id="zombies"></div>

    <script>
      var cryptoZombies;
      var userAccount;

      function startApp() {
        var cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
        cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);

        var accountInterval = setInterval(function() {
          // Check if account has changed
          if (web3.eth.accounts[0] !== userAccount) {
            userAccount = web3.eth.accounts[0];
            // Call a function to update the UI with the new account
            getZombiesByOwner(userAccount)
            .then(displayZombies);
          }
        }, 100);
      }

      function displayZombies(ids) {
        $("#zombies").empty();
        for (id of ids) {
          getZombieDetails(id)
          .then(function(zombie) {
            $("#zombies").append(`<div class="zombie">
            <ul>
              <li>Name: ${zombie.name}</li>
              <li>DNA: ${zombie.dna}</li>
              <li>Level: ${zombie.level}</li>
              <li>Wins: ${zombie.winCount}</li>
              <li>Losses: ${zombie.lossCount}</li>
              <li>Ready Time: ${zombie.readyTime}</li>
            </ul>
          </div>`);
          });
        }
      }

      function getZombieDetails(id) {
        return cryptoZombies.methods.zombies(id).call()
      }

      function zombieToOwner(id) {
        return cryptoZombies.methods.zombieToOwner(id).call()
      }

      function getZombiesByOwner(owner) {
        return cryptoZombies.methods.getZombiesByOwner(owner).call()
      }

      window.addEventListener('load', function() {

        // Checking if Web3 has been injected by the browser (Mist/MetaMask)
        if (typeof web3 !== 'undefined') {
          // Use Mist/MetaMask's provider
          web3js = new Web3(web3.currentProvider);
        } else {
          // Handle the case where the user doesn't have Metamask installed
          // Probably show them a message prompting them to install Metamask
        }

        // Now you can start your app & access web3 freely:
        startApp()

      })
    </script>
  </body>
</html>
```

## 第7章: 發送事務

這下我們的界面能檢測用戶的 MetaMask 賬戶，並自動在首頁顯示它們的殭屍大軍了，有沒有很棒？

現在我們來看看用 `send` 函數來修改我們智能合約裡面的數據。

相對 `call` 函數，`send` 函數有如下主要區別:

1. `send` 一個事務需要一個 `from` 地址來表明誰在調用這個函數（也就是你 Solidity 代碼裡的 `msg.sender` )。 我們需要這是我們 DApp 的用戶，這樣一來 MetaMask 才會彈出提示讓他們對事務簽名。
1. `send` 一個事務將花費 gas
1. 在用戶 `send` 一個事務到該事務對區塊鏈產生實際影響之間有一個不可忽略的延遲。這是因為我們必須等待事務被包含進一個區塊裡，以太坊上一個區塊的時間平均下來是15秒左右。如果當前在以太坊上有大量掛起事務或者用戶發送了過低的 gas 價格，我們的事務可能需要等待數個區塊才能被包含進去，往往可能花費數分鐘。

所以在我們的代碼中我們需要編寫邏輯來處理這部分異步特性。

### 生成一個殭屍

我們來看一個合約中一個新用戶將要調用的第一個函數: `createRandomZombie`.

作為複習，這裡是合約中的 Solidity 代碼：

```js
function createRandomZombie(string _name) public {
  require(ownerZombieCount[msg.sender] == 0);
  uint randDna = _generateRandomDna(_name);
  randDna = randDna - randDna % 100;
  _createZombie(_name, randDna);
}
```

這是如何在用 MetaMask 在 Web3.js 中調用這個函數的示例:

```js
function createRandomZombie(name) {
  // 這將需要一段時間，所以在界面中告訴用戶這一點
  // 事務被發送出去了
  $("#txStatus").text("正在區塊鏈上創建殭屍，這將需要一會兒...");
  // 把事務發送到我們的合約:
  return cryptoZombies.methods.createRandomZombie(name)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("成功生成了 " + name + "!");
    // 事務被區塊鏈接受了，重新渲染界面
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    // 告訴用戶合約失敗了
    $("#txStatus").text(error);
  });
}
```

我們的函數 `send` 一個事務到我們的 Web3 提供者，然後鏈式添加一些事件監聽:

* `receipt` 將在合約被包含進以太坊區塊上以後被觸發，這意味著殭屍被創建並保存進我們的合約了。
* `error` 將在事務未被成功包含進區塊後觸發，比如用戶未支付足夠的 gas。我們需要在界面中通知用戶事務失敗以便他們可以再次嘗試。
  
> 注意:你可以在調用 `send` 時選擇指定 `gas` 和 `gasPrice`，例如： `.send({ from: userAccount, gas: 3000000 })`。如果你不指定，MetaMask 將讓用戶自己選擇數值。

* [ethereum/web3.js - Github](https://github.com/ethereum/web3.js)

### 實戰練習

我們添加了一個`div`， 指定 ID 為 `txStatus`，這樣我們可以通過更新這個 div 來通知用戶事務的狀態。

1. 在 `displayZombies`下面， 複製粘貼上面 `createRandomZombie` 的代碼。
2. 我們來實現另外一個函數 `feedOnKitty`：

調用 `feedOnKitty` 的邏輯幾乎一樣，我們將發送一個事務來調用這個函數，並且成功的事務會為我們創建一個殭屍，所以我們希望在成功後重新繪製界面。

在 `createRandomZombie` 下面複製粘貼它的代碼，改動這些地方:

  1. 給其命名為 `feedOnKitty`， 它將接收兩個參數 `zombieId` 和 `kittyId`
  2. `#txStatus` 的文本內容將更新為: "正在吃貓咪，這將需要一會兒..."
  3. 讓其調用我們合約裡面的 `feedOnKitty` 函數並傳入相同的參數
  4. `#txStatus` 裡面的的成功信息應該是 "吃了一隻貓咪並生成了一隻新殭屍！"

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>
    <div id="txStatus"></div>
    <div id="zombies"></div>

    <script>
      var cryptoZombies;
      var userAccount;

      function startApp() {
        var cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
        cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);

        var accountInterval = setInterval(function() {
          // Check if account has changed
          if (web3.eth.accounts[0] !== userAccount) {
            userAccount = web3.eth.accounts[0];
            // Call a function to update the UI with the new account
            getZombiesByOwner(userAccount)
            .then(displayZombies);
          }
        }, 100);
      }

      function displayZombies(ids) {
        $("#zombies").empty();
        for (id of ids) {
          // Look up zombie details from our contract. Returns a `zombie` object
          getZombieDetails(id)
          .then(function(zombie) {
            // Using ES6's "template literals" to inject variables into the HTML.
            // Append each one to our #zombies div
            $("#zombies").append(`<div class="zombie">
              <ul>
                <li>Name: ${zombie.name}</li>
                <li>DNA: ${zombie.dna}</li>
                <li>Level: ${zombie.level}</li>
                <li>Wins: ${zombie.winCount}</li>
                <li>Losses: ${zombie.lossCount}</li>
                <li>Ready Time: ${zombie.readyTime}</li>
              </ul>
            </div>`);
          });
        }
      }

      function createRandomZombie(name) {
        // 這將需要一段時間，所以在界面中告訴用戶這一點
        // 事務被發送出去了
        $("#txStatus").text("正在区块链上创建僵尸，这将需要一会儿...");
        // 把事務發送到我們的合約:
        return cryptoZombies.methods.createRandomZombie(name)
        .send({ from: userAccount })
        .on("receipt", function(receipt) {
          $("#txStatus").text("成功生成了 " + name + "!");
          // 事務被區塊鏈接受了，重新渲染界面
          getZombiesByOwner(userAccount).then(displayZombies);
        })
        .on("error", function(error) {
          // 告訴用戶合約失敗了
          $("#txStatus").text(error);
        });
      }

      function feedOnKitty(zombieId, kittyId) {
        // 這將需要一段時間，所以在界面中告訴用戶這一點
        // 事務被發送出去了
        $("#txStatus").text("正在吃猫咪，这将需要一会儿...");
        // 把事務發送到我們的合約:
        return cryptoZombies.methods.feedOnKitty(zombieId, kittyId)
        .send({ from: userAccount })
        .on("receipt", function(receipt) {
          $("#txStatus").text("吃了一只猫咪并生成了一只新僵尸！");
          // 事務被區塊鏈接受了，重新渲染界面
          getZombiesByOwner(userAccount).then(displayZombies);
        })
        .on("error", function(error) {
          // 告訴用戶合約失敗了
          $("#txStatus").text(error);
        });
      }

      function getZombieDetails(id) {
        return cryptoZombies.methods.zombies(id).call()
      }

      function zombieToOwner(id) {
        return cryptoZombies.methods.zombieToOwner(id).call()
      }

      function getZombiesByOwner(owner) {
        return cryptoZombies.methods.getZombiesByOwner(owner).call()
      }

      window.addEventListener('load', function() {

        // Checking if Web3 has been injected by the browser (Mist/MetaMask)
        if (typeof web3 !== 'undefined') {
          // Use Mist/MetaMask's provider
          web3js = new Web3(web3.currentProvider);
        } else {
          // Handle the case where the user doesn't have Metamask installed
          // Probably show them a message prompting them to install Metamask
        }

        // Now you can start your app & access web3 freely:
        startApp()

      })
    </script>
  </body>
</html>
```

## 第8章: 調用 Payable 函數

`attack`, `changeName`, 以及 `changeDna` 的邏輯將非常雷同，所以本課將不會花時間在上面。

實際上，在調用這些函數的時候已經有了非常多的重複邏輯。所以最好是重構代碼把相同的代碼寫成一個函數。（並對`txStatus`使用模板系統——我們已經看到用類似 Vue.js 類的框架是多麼整潔）

我們來看看另外一種 Web3.js 中需要特殊對待的函數，`payable` 函數。

### 升級！

回憶一下在 `ZombieHelper` 裡面，我們添加了一個 payable 函數，用戶可以用來升級:

```js
function levelUp(uint _zombieId) external payable {
  require(msg.value == levelUpFee);
  zombies[_zombieId].level++;
}
```

和函數一起發送以太非常簡單，只有一點需要注意： 我們需要指定發送多少 wei，而不是以太。

### 啥是 Wei?

一個 `wei` 是以太的最小單位，`1 ether` 等於 `10^18` wei

太多0要數了，不過幸運的是 Web3.js 有一個轉換工具來幫我們做這件事：

```js
// 把 1 ETH 轉換成 Wei
web3js.utils.toWei("1", "ether");
```

在我們的 DApp 裡， 我們設置了 `levelUpFee = 0.001 ether`，所以調用 `levelUp` 方法的時候，我們可以讓用戶用以下的代碼同時發送 `0.001` 以太:

```
cryptoZombies.methods.levelUp(zombieId)
.send({ from: userAccount, value: web3js.utils.toWei("0.001","ether") })
```

### 實戰練習

在 `feedOnKitty` 下面添加一個 `levelUp` 方法。代碼和 `feedOnKitty` 將非常相似。不過：

1. 函數將接收一個參數, `zombieId`
1. 在發送事務之前，`txStatus` 的文本應該是`"正在升級您的殭屍..."`
1. 當它調用合約裡的`levelUp`時，它應該發送`"0.001"` ETH，並用 `toWei` 轉換，如同上面例子裡那樣。
1. 成功之後應該顯示 `"不得了了！殭屍成功升級啦！"`
1. 我們 `不` 需要在調用 `getZombiesByOwner` 後重新繪製界面，因為在這裡我們只是修改了殭屍的級別而已。

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>
    <div id="txStatus"></div>
    <div id="zombies"></div>

    <script>
      var cryptoZombies;
      var userAccount;

      function startApp() {
        var cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
        cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);

        var accountInterval = setInterval(function() {
          // Check if account has changed
          if (web3.eth.accounts[0] !== userAccount) {
            userAccount = web3.eth.accounts[0];
            // Call a function to update the UI with the new account
            getZombiesByOwner(userAccount)
            .then(displayZombies);
          }
        }, 100);
      }

      function displayZombies(ids) {
        $("#zombies").empty();
        for (id of ids) {
          // Look up zombie details from our contract. Returns a `zombie` object
          getZombieDetails(id)
          .then(function(zombie) {
            // Using ES6's "template literals" to inject variables into the HTML.
            // Append each one to our #zombies div
            $("#zombies").append(`<div class="zombie">
              <ul>
                <li>Name: ${zombie.name}</li>
                <li>DNA: ${zombie.dna}</li>
                <li>Level: ${zombie.level}</li>
                <li>Wins: ${zombie.winCount}</li>
                <li>Losses: ${zombie.lossCount}</li>
                <li>Ready Time: ${zombie.readyTime}</li>
              </ul>
            </div>`);
          });
        }
      }

      function createRandomZombie(name) {
        // This is going to take a while, so update the UI to let the user know
        // the transaction has been sent
        $("#txStatus").text("Creating new zombie on the blockchain. This may take a while...");
        // Send the tx to our contract:
        return cryptoZombies.methods.createRandomZombie(name)
        .send({ from: userAccount })
        .on("receipt", function(receipt) {
          $("#txStatus").text("Successfully created " + name + "!");
          // Transaction was accepted into the blockchain, let's redraw the UI
          getZombiesByOwner(userAccount).then(displayZombies);
        })
        .on("error", function(error) {
          // Do something to alert the user their transaction has failed
          $("#txStatus").text(error);
        });
      }

      function feedOnKitty(zombieId, kittyId) {
        $("#txStatus").text("Eating a kitty. This may take a while...");
        return cryptoZombies.methods.feedOnKitty(zombieId, kittyId)
        .send({ from: userAccount })
        .on("receipt", function(receipt) {
          $("#txStatus").text("Ate a kitty and spawned a new Zombie!");
          getZombiesByOwner(userAccount).then(displayZombies);
        })
        .on("error", function(error) {
          $("#txStatus").text(error);
        });
      }

      function levelUp(zombieId) {
        $("#txStatus").text("正在升级您的僵尸...");
        return cryptoZombies.methods.levelUp(zombieId)
        .send({ from: userAccount, value: web3js.utils.toWei("0.001", "ether") })
        .on("receipt", function(receipt) {
          $("#txStatus").text("不得了了！僵尸成功升级啦！");
        })
        .on("error", function(error) {
          $("#txStatus").text(error);
        });
      }

      function getZombieDetails(id) {
        return cryptoZombies.methods.zombies(id).call()
      }

      function zombieToOwner(id) {
        return cryptoZombies.methods.zombieToOwner(id).call()
      }

      function getZombiesByOwner(owner) {
        return cryptoZombies.methods.getZombiesByOwner(owner).call()
      }

      window.addEventListener('load', function() {

        // Checking if Web3 has been injected by the browser (Mist/MetaMask)
        if (typeof web3 !== 'undefined') {
          // Use Mist/MetaMask's provider
          web3js = new Web3(web3.currentProvider);
        } else {
          // Handle the case where the user doesn't have Metamask installed
          // Probably show them a message prompting them to install Metamask
        }

        // Now you can start your app & access web3 freely:
        startApp()

      })
    </script>
  </body>
</html>
```

## 第9章：訂閱事件

如你所見，通過 Web3.js 和合約交互非常簡單直接，一旦你的環境建立起來， `call` 函數和 `send` 事務和普通的網絡API並沒有多少不同。

還有一點東西我們想要講到，訂閱合約事件。

### 監聽新殭屍事件

如果你還記得 `zombiefactory.sol`，每次新建一個殭屍後，我們會觸發一個 `NewZombie` 事件：

```
event NewZombie(uint zombieId, string name, uint dna);
```

在 Web3.js裡， 你可以 `訂閱` 一個事件，這樣你的 Web3 提供者可以在每次事件發生後觸發你的一些代碼邏輯：

```js
cryptoZombies.events.NewZombie()
.on("data", function(event) {
  let zombie = event.returnValues;
  console.log("一個新殭屍誕生了！", zombie.zombieId, zombie.name, zombie.dna);
}).on('error', console.error);
```

注意這段代碼將在 `任何` 殭屍生成的時候激發一個警告信息，而不僅僅是當前用用戶的殭屍。如果我們只想對當前用戶發出提醒呢？

```
event NewZombie(uint zombieId, string name, uint dna);
```

### 使用 indexed

為了篩選僅和當前用戶相關的事件，我們的 Solidity 合約將必須使用 `indexed` 關鍵字，就像我們在 ERC721 實現中的 `Transfer` 事件中那樣：

```
event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
```

在這種情況下， 因為 `_from` 和 `_to` 都是 `indexed`，這就意味著我們可以在前端事件監聽中過濾事件

```js
cryptoZombies.events.Transfer({ filter: { _to: userAccount } })
.on("data", function(event) {
  let data = event.returnValues;
  // 當前用戶更新了一個殭屍！更新界面來顯示
}).on('error', console.error);
```

看到了吧， 使用 `event` 和 `indexed` 字段對於監聽合約中的更改，並將其反映到 DApp 的前端界面中是非常有用的做法。

### 查詢過去的事件

我們甚至可以用 `getPastEvents` 查詢過去的事件，並用過濾器 `fromBlock` 和 `toBlock` 給 Solidity 一個事件日誌的時間範圍("block" 在這裡代表以太坊區塊編號）：

```js
cryptoZombies.getPastEvents("NewZombie", { fromBlock: 0, toBlock: 'latest' })
.then(function(events) {
  // events 是可以用來遍歷的 `event` 對象 
  // 這段代碼將返回給我們從開始以來創建的殭屍列表
});
```

因為你可以用這個方法來查詢從最開始起的事件日誌，這就有了一個非常有趣的用例：**用事件來作為一種更便宜的存儲**。

若你還能記得，在區塊鏈上保存數據是 Solidity 中最貴的操作之一。但是用事件，就便宜太多太多了。

這裡的缺點是，事件不能從智能合約本身讀取。但是，如果你有一些數據需要永久性地記錄在區塊鏈中，以便可以在應用的前端中讀取，這將是一個很好的用例。這些數據不會影響智能合約向前的狀態。

舉個例子，我們可以用事件來作為殭屍戰鬥的歷史紀錄，我們可以在每次殭屍攻擊別人，以及有一方勝出的時候產生一個事件。智能合約不需要這些數據來計算任何接下來的事情，但是這對我們在前端向用戶展示來說是非常有用的東西。

### Web3.js 事件 和 MetaMask

上面的示例代碼是針對 Web3.js 最新版1.0的，此版本使用了 `WebSockets` 來訂閱事件。

但是，MetaMask 尚且不支持最新的事件 API (儘管如此，他們已經在實現這部分功能了，[點擊這裡](https://github.com/MetaMask/metamask-extension/issues/3642) 查看進度)

所以現在我們必須使用一個單獨 Web3 提供者，它針對事件提供了WebSockets支持。 我們可以用 Infura 來像實例化第二份拷貝：

```js
var web3Infura = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));
var czEvents = new web3Infura.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);
```

然後我們將使用 `czEvents.events.Transfer` 來監聽事件，而不再使用 `cryptoZombies.events.Transfer`。我們將繼續在課程的其他部分使用 `cryptoZombies.methods`。

將來，在 MetaMask 升級了 API 支持 Web3.js 後，我們就不用這麼做了。但是現在我們還是要這麼做，以使用 Web3.js 更好的最新語法來監聽事件。

* [Add Web3 1.0 &quot;subscription&quot; support with a polling subprovider · Issue #3642 · MetaMask/metamask-extension](https://github.com/MetaMask/metamask-extension/issues/3642)

### 放在一起

來添加一些代碼監聽 `Transfer` 事件，並在當前用戶獲得一個新殭屍的時候為他更新界面。

我們將需要在 `startApp` 底部添加代碼，以保證在添加事件監聽器之前 `cryptoZombies` 已經初始化了。

1. 在 `startApp()` 底部，為 `cryptoZombies.events.Transfer` 複製粘貼上面的2行事件監聽代碼塊
1. 複製監聽 `Transfer` 事件的代碼塊，並用 `_to: userAccount` 過濾。要記得把 `cryptoZombies` 換成 `czEvents` 好在這 裡使用 Infura 而不是 MetaMask 來作為提供者。
1. 用 `getZombiesByOwner(userAccount).then(displayZombies);` 來更新界面

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>
    <div id="txStatus"></div>
    <div id="zombies"></div>

    <script>
      var cryptoZombies;
      var userAccount;

      function startApp() {
        var cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
        cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);

        var accountInterval = setInterval(function() {
          // Check if account has changed
          if (web3.eth.accounts[0] !== userAccount) {
            userAccount = web3.eth.accounts[0];
            // Call a function to update the UI with the new account
            getZombiesByOwner(userAccount)
            .then(displayZombies);
          }
        }, 100);

        var web3Infura = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));
        var czEvents = new web3Infura.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);

        czEvents.events.Transfer({ filter: { _to: userAccount } })
        .on("data", function(event) {
          let data = event.returnValues;
          getZombiesByOwner(userAccount).then(displayZombies);
        }).on('error', console.error);

      }

      function displayZombies(ids) {
        $("#zombies").empty();
        for (id of ids) {
          // Look up zombie details from our contract. Returns a `zombie` object
          getZombieDetails(id)
          .then(function(zombie) {
            // Using ES6's "template literals" to inject variables into the HTML.
            // Append each one to our #zombies div
            $("#zombies").append(`<div class="zombie">
              <ul>
                <li>Name: ${zombie.name}</li>
                <li>DNA: ${zombie.dna}</li>
                <li>Level: ${zombie.level}</li>
                <li>Wins: ${zombie.winCount}</li>
                <li>Losses: ${zombie.lossCount}</li>
                <li>Ready Time: ${zombie.readyTime}</li>
              </ul>
            </div>`);
          });
        }
      }

      function createRandomZombie(name) {
        // This is going to take a while, so update the UI to let the user know
        // the transaction has been sent
        $("#txStatus").text("Creating new zombie on the blockchain. This may take a while...");
        // Send the tx to our contract:
        return cryptoZombies.methods.createRandomZombie(name)
        .send({ from: userAccount })
        .on("receipt", function(receipt) {
          $("#txStatus").text("Successfully created " + name + "!");
          // Transaction was accepted into the blockchain, let's redraw the UI
          getZombiesByOwner(userAccount).then(displayZombies);
        })
        .on("error", function(error) {
          // Do something to alert the user their transaction has failed
          $("#txStatus").text(error);
        });
      }

      function feedOnKitty(zombieId, kittyId) {
        $("#txStatus").text("Eating a kitty. This may take a while...");
        return cryptoZombies.methods.feedOnKitty(zombieId, kittyId)
        .send({ from: userAccount })
        .on("receipt", function(receipt) {
          $("#txStatus").text("Ate a kitty and spawned a new Zombie!");
          getZombiesByOwner(userAccount).then(displayZombies);
        })
        .on("error", function(error) {
          $("#txStatus").text(error);
        });
      }

      function levelUp(zombieId) {
        $("#txStatus").text("Leveling up your zombie...");
        return cryptoZombies.methods.levelUp(zombieId)
        .send({ from: userAccount, value: web3.utils.toWei("0.001", "ether") })
        .on("receipt", function(receipt) {
          $("#txStatus").text("Power overwhelming! Zombie successfully leveled up");
        })
        .on("error", function(error) {
          $("#txStatus").text(error);
        });
      }

      function getZombieDetails(id) {
        return cryptoZombies.methods.zombies(id).call()
      }

      function zombieToOwner(id) {
        return cryptoZombies.methods.zombieToOwner(id).call()
      }

      function getZombiesByOwner(owner) {
        return cryptoZombies.methods.getZombiesByOwner(owner).call()
      }

      window.addEventListener('load', function() {

        // Checking if Web3 has been injected by the browser (Mist/MetaMask)
        if (typeof web3 !== 'undefined') {
          // Use Mist/MetaMask's provider
          web3js = new Web3(web3.currentProvider);
        } else {
          // Handle the case where the user doesn't have Metamask installed
          // Probably show them a message prompting them to install Metamask
        }

        // Now you can start your app & access web3 freely:
        startApp()

      })
    </script>
  </body>
</html>
```

## 第10章: 放在一起

恭喜啊少年，你已經成功編寫了一個 Web3.js 前端界面來和你的智能合約交互

### 接下來的步驟

這節課的內容非常基礎。我們想要給你展示和智能合約交互的核心內容，而並不想用太多的時間來教你完整實現。我們也不想花太多時間在HTML/CSS上，因為大部分人都已經知道了。

所以我們把一些實現略去了。這裡是你要完整實現所需要完成的基本事項列表：

1. 為 `attack`, `changeName`, `changeDna` 以及 ERC721 函數 `transfer`, `ownerOf`, `balanceOf` 等實現前端函數。這些函數的實現將和我們講過的 `send` 事務的函數非常相似。
1. 實現一個“管理界面”，在那裡你可以調用 `setKittyContractAddress`, `setLevelUpFee`, 以及 `withdraw`。再次，在前端這塊沒有什麼特別的代碼——這些實現之間將非常相似。你應該保證從部署合同時候相同的以太坊地址調用這些函數，因為他們都有 `onlyOwner` 修飾符。
1. 在應用裡我們還應該實現一些其他的界面：
  1. 一個殭屍頁面，在那裡你可以查看一個特定殭屍的信息並可以分享它的鏈接。這個頁面應該渲染殭屍的外形，展示它的名字，它的所有者（以及用戶主頁的鏈接），它的輸贏次數，它的戰鬥記錄等等。
  2. 一個用戶界面，在那裡你可以查看用戶的殭屍大軍並分享它的鏈接。
  3. 一個主頁，就是用戶頁面的變體，可以展示當前用戶的殭屍大軍（正如我們在index.html）裡面實現的那樣。
1. 界面中的一些方法允許用戶用 CryptoKitties 喂食殭屍。我們可以給每一個殭屍添加一個按鈕，叫做“給我投食”，再給一個輸入框讓用戶輸入一個貓咪的ID（或者一個貓咪的網址，比如https://www.cryptokitties.co/kitty/578397），它將觸發我們的 feedOnKitty 函數。
1. 界面中的一些方法將讓用戶用來攻擊其他用戶的殭屍

實現這點的一個方法是，當用戶瀏覽其他用戶的頁面的時候，可以在對方殭屍旁邊顯示一個按鈕，叫做“攻擊這頭殭屍”。當用戶點擊的時候，可以彈出一個模塊，展示當前用戶的殭屍大軍並詢問用戶“你想用哪頭殭屍出戰？”

在用戶的主頁，也可以在每個殭屍旁邊顯示一個按鈕，叫做“攻擊一個殭屍”。當用戶點擊的時候，可以彈出一個模塊，展示一個搜索框，可以讓用戶輸入殭屍ID或者網址來搜索，或者也可以有一個按鈕叫做“隨機攻擊一頭殭屍”，將隨機搜索一頭殭屍來。

我們也建議你將在冷卻期的殭屍用特殊的顏色顯示，比如使其變成灰色。這樣界面就能告訴用戶不能用冷卻期的殭屍來進攻。

1. 在用戶的主頁，每一個殭屍也應該有選項可以更改名字、DNA、以及升級（通過付費）。若用戶等級不到，無法使用的選項應該標灰。
1. 對於新用戶，我們應該顯示一個歡迎信息，並讓其確認用 createRandomZombie()創建一個新殭屍。
1. 也可以為我們的智能合約添加一個包含indexed 的用戶地址屬性的 Attack 事件。這樣就可以創建實時通知了——我們可以在用戶的殭屍遭受攻擊的時候彈出一條通知，這樣他們可以看到誰在用什麼殭屍攻擊他們並做出報復。
1. 我們也許還想實現一些前端緩存層，這樣就不用總是為了相同的數據去訪問Infura。（在我們當前實現中，displayZombies 將在每次頁面刷新的時候為每一個殭屍調用 getZombieDetails，但是實際中我們將只需要為新加入的殭屍調用這個函數）
1. 一個實時聊天室，這樣你就可以在你擊潰別人的殭屍大軍的同時嘲諷他們？

因為這將需要大量的前端代碼來實現全部的界面（HTML， CSS， JavaScript 以及諸如 React 和 Vue.js 這樣的框架）。光實現一個這樣的前端界面也許會花費多達10節課，所以我們將這個光榮的任務交給你自己去完成。

注意：儘管智能合約是去中心化的。這個用來和DApp交互的前端界面依然需要放在我們中心化的網絡服務器上。不過，有了我們正在內測的Loom Network SDK，很快你就可以在應用自己的DApp鏈上運行前端界面而不是中心化的網絡服務器。這樣在以太坊和 Loom DApp 鏈上，你的整個應用都100%運行在區塊鏈上了。

## 總結

學完第六課。你現在有了編寫智能合約和前端界面來讓用戶交互的所需技能了。

在下一課。 我們將涉及這個歷程中最後缺失的一部分，將你的智能合約部署到以太坊。

知道你已經急不可耐了，點擊「下一章」領取你的獎勵吧。