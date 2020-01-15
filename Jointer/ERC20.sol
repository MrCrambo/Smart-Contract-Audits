pragma solidity 0.5.9;

// accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
/*
 * ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
 
contract ERC20  {
    
  uint public totalSupply;
  
  function balanceOf(address _who) public view returns (uint);
  
  function allowance(address _owner, address _spender) public view returns (uint);

  function transfer(address _to, uint256 _value) public returns (bool ok);
  
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok);
  
  function approve(address _spender,uint256 _currentValue, uint256 _value) public returns (bool ok);
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  
  event Approval(address indexed owner, address indexed spender,uint256 oldValue  ,uint256 value);
  

}