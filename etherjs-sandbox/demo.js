const ethers = require('ethers');
const abi = require('./abi.json');

function getContract(address) {
  let provider = new ethers.providers.Web3Provider(web3.currentProvider);
  return new ethers.Contract(address, abi, provider.getSigner());
}

async function start(address) {
  const contract = getContract(address);
  // call
  let name = await contract.getName();
  console.log(name);

  // send
  // let tx = await contract.setName('Alin');
  // console.log(tx);
}

const address = '0x5fd885d4d375c2d6e92bc0bb2d29da0510648fff';

start(address);
