pragma solidity ^0.4.24;

contract Coin {
  address public minter;
  mapping (address => uint) public balances;

  constructor() public {
    minter = msg.sender;
  }

  event Sent(address from, address to, uint amount);

  function mint(address receiver, uint amount) public {
    assert(msg.sender == minter);
    balances[receiver] += amount;
    emit Sent(msg.sender, receiver, amount);
  }

  function send(address receiver, uint amount) public returns (bool) {
    assert(msg.sender == minter);
    assert(balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;
    balances[receiver] += amount;
    emit Sent(msg.sender, receiver, amount);
    return true;
  }

  // function sendFrom(address from, address receiver, uint amount) public {
  //   assert(balances[from] >= amount);
  //   balances[from] -= amount;
  //   balances[receiver] += amount;
  //   emit Sent(from, receiver, amount);
  // }
}