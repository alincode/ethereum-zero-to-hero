pragma solidity ^0.4.0;

contract HelloWorld {
  uint8 public age;
  bool public done;
  string name = "alincode";
  string name2 = "alincode";
  
  function setAge(uint8 _age) public {
      age = _age;
  }
  
  function setDone(bool _done) public {
    done = _done;
  }

  function setName(string _name) public returns (string) {
    name = _name;
    return name;
  }

  function getName() public view returns (string) {
    return name;
  }
  
  function setNames(string _name, string _name2) public {
    name = _name;
    name2 = _name2;
  }

  function getName2() public view returns (string) {
    return name2;
  }
}