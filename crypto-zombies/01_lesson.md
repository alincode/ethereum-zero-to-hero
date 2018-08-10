# 第一課：建立殭屍工廠

## 第二章：合約

```
pragma solidity ^0.4.19;

contract ZombieFactory {


}
```

## 第三章：狀態變數和整數

狀態變數是被永久地保存在合約中。也就是說它們被寫入以太幣區塊鏈中. 想像成寫入一個資料庫。

uint 實際上是 uint256

```
pragma solidity ^0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
}

```

## 第四章：數學運算

除了一般的數學運作，Solidity 還支持次方操作 (如：x 的 y次方），例如:5 ** 2 = 25

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

}
```

### 第五章：struct

```
struct Person {
  uint age;
  string name;
}
```

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    } 
}
```


## 第六章：陣列

```
// 固定長度為2的靜態陣列:
uint[2] fixedArray;

// 固定長度為5的string類型的靜態陣列:
string[5] stringArray;

// 動態陣列，長度不固定，可以動態添加元素:
uint[] dynamicArray;

Person[] people;
```

### Public

定義 public 陣列, Solidity 會自動建立 getter 方法

```
Person[] public people;
```

其它的合約可以從這個陣列讀取資料（但不能寫入資料），所以這在合約中是一個有用的保存公共資料的模式。

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

}
```

## 第七章：宣告函數

ps. 習慣上函數裡的變量都是以(_)開頭 (但不是硬性規定) 以區別全局變量。我們整個教程都會沿用這個習慣。

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function createZombie(string _name, uint _dna) {
        
    }

}
```

## 第八章：使用 struct 和陣列

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    
    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function createZombie(string _name, uint _dna) {
        zombies.push(Zombie(_name, _dna));
    }

}
```

## 第九章：private / public 函數
Solidity 定義的函數的屬性默認為公共。 這就意味著任何一方 (或其它合約) 都可以調用你合約裡的函數。
private function 意味著只有我們合約中的其它函數才能夠調用這個函數，給 numbers 數組添加新成員。

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

}
```

## 第十章：函數得更多屬性

### return

回傳值

```
string greeting = "What's up dog";

function sayHello() public returns (string) {
  return greeting;
}
```

### view

實際上沒有改變 Solidity 裡的狀態，即它沒有改變或寫入任何值。這種情況下，我們可以把函數定義為 view, 意味著它只能讀取資料不能更改資料。

```
string greeting = "What's up dog";

function sayHello() public view returns (string) {
  return greeting;
}
```

### pure

函數甚至都不能讀取程式裡面的狀態，它的返回值完全取決於它的輸入參數，在這種情況下我們把函數定義為 pure.

```
function _multiply(uint a, uint b) private pure returns (uint) {
  return a * b;
}
```

ps. 是 `returns`

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string _str) private view returns (uint) {

    }

}
```

## 第十一章：Keccak256 和類型轉換

keccak256：Ethereum 的內建函數，它用了SHA3版本，函數基本上就是把一個字符串轉換為一個256位的16進制數字。字串的一個微小的變化都會引起數字變化。

### 轉型

```
uint8 a = 5;
uint b = 6;
// 將會拋出錯誤，因為 a * b 返回 uint, 而不是 uint8:
uint8 c = a * b;
// 我們需要將 b 轉換為 uint8:
uint8 c = a * uint8(b);
```


```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }
}
```

## 第十二章: 整合

```
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
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

## 第十三章：事件

```
YourContract.NewZombie(function(error, result){

});
```

```
pragma solidity ^0.4.19;

contract ZombieFactory {

	  // 宣告事件
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
			// 觸發事件
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


## 第14章：Web3.js

透過 Web3.js 與發佈的合約交互

```
// 下面是調用合約的方式:
var abi = /* abi是由編譯器生成的 */
var ZombieFactoryContract = web3.eth.contract(abi)
var contractAddress = /* 發佈之後在以太坊上生成的合約地址 */
var ZombieFactory = ZombieFactoryContract.at(contractAddress)
// `ZombieFactory` 能訪問公共的函數以及事件

// 某個監聽文本輸入的監聽器:
$("#ourButton").click(function(e) {
  var name = $("#nameInput").val()
  //調用合約的 `createRandomZombie` 函數:
  ZombieFactory.createRandomZombie(name)
})

// 監聽 `NewZombie` 事件, 並且更新UI
var event = ZombieFactory.NewZombie(function(error, result) {
  if (error) return
  generateZombie(result.zombieId, result.name, result.dna)
})

// 獲取 Zombie 的 dna, 更新圖像
function generateZombie(id, name, dna) {
  let dnaStr = String(dna)
  // 如果dna少於16位,在它前面用0補上
  while (dnaStr.length < 16)
    dnaStr = "0" + dnaStr

  let zombieDetails = {
    // 前兩位數構成頭部.我們可能有7種頭部, 所以 % 7
    // 得到的數在0-6,再加上1,數的範圍變成1-7
    // 通過這樣計算：
    headChoice: dnaStr.substring(0, 2) % 7 + 1，
    // 我們得到的圖片名稱從head1.png 到 head7.png

    // 接下來的兩位數構成眼睛, 眼睛變化就對11取模:
    eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
    // 再接下來的兩位數構成衣服，衣服變化就對6取模:
    shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
    //最後6位控制顏色. 用css選擇器: hue-rotate來更新
    // 360度:
    skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
    clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
    zombieName: name,
    zombieDescription: "A Level 1 CryptoZombie",
  }
  return zombieDetails
}
```

我們的 JavaScript 所做的就是獲取由zombieDetails 產生的數據, 並且利用瀏覽器裡的 JavaScript 神奇功能 (我們用 Vue.js)，置換出圖像以及使用CSS過濾器。在後面的課程中，你可以看到全部的代碼。