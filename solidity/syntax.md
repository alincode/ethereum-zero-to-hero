# Solidity syntax

### Event

* [Technical Introduction to Events and Logs in Ethereum](https://media.consensys.net/technical-introduction-to-events-and-logs-in-ethereum-a074d65dd61e)

```js
pragma solidity ^0.4.20;
contract SimpleStorage {
    uint public data;
    event Set(address indexed _from, uint value);
    function set(uint x) public {
        data = x;
        Set(msg.sender, x);
    }
}
```

ABI

```json
[{
        "constant": true,
        "inputs": [],
        "name": "data",
        "outputs": [{"name": "","type": "uint256"}],
        "payable": false,
        "stateMutabㄒility": "view",
        "type": "function"
    },
    {
        "anonymous": false,
        "inputs": [{"indexed": true,"name": "_from","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],
        "name": "Set",
        "type": "event"
    },
    {
        "constant": false,
        "inputs": [{"name": "x","type": "uint256"}],
        "name": "set",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
}]
```