pragma solidity 0.5.9;
import './SafeMath.sol';
import './ERC20.sol';
import './Ownable.sol';

contract StandardToken is ERC20,SafeMath,Ownable{
    
    string public name;
    
    string public symbol;
    
    uint256 public totalSupply = 0 ;
    
    uint public constant decimals = 18;
    
    mapping(address => uint256) balances;
    
    mapping (address => mapping (address => uint256)) allowed;
    
 
    event TokneMinted(address indexed _to,uint256 value);
    event TokenBurned(address indexed _from,uint256 value);
    event TransferFrom(address indexed spender,address indexed _from,address indexed _to);
    
    constructor(string memory _name,string memory _symbol,address _systemAddress) public Ownable(_systemAddress){
        name = _name;
        symbol = _symbol;
    }
    
    
    function _transfer(address _from,address _to,uint256 _value) internal notZeroValue(_value) notThisAddress(_to) notZeroAddress(_to) returns (bool) {
        uint256 senderBalance = balances[_from];
        require(senderBalance >= _value,ERR_NOT_ENOUGH_BALANCE);
        senderBalance = safeSub(senderBalance, _value);
        balances[_from] = senderBalance;
        balances[_to] = safeAdd(balances[_to],_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    
    function _burn(address _from,uint256 _value) internal notZeroAddress(_from) returns (bool){
        uint256 senderBalance = balances[_from];
        require(senderBalance >= _value,ERR_NOT_ENOUGH_BALANCE);
        senderBalance = safeSub(senderBalance, _value);
        balances[_from] = senderBalance;
        totalSupply = safeSub(totalSupply, _value);
        emit TokenBurned(_from,_value);
        emit Transfer(_from, address(0), _value);
        return true;
    }

    function _mint(address _to,uint256 _value) internal notZeroAddress(_to) returns(bool){
        balances[_to] = safeAdd(balances[_to],_value);
        totalSupply = safeAdd(totalSupply, _value);
        emit TokneMinted(_to,_value);
        emit Transfer(address(0),_to, _value);
        return true;
    }
    
    /**
    * @dev Gets the balance of the specified address.
    * @param _who The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }
    
    /**
      * @dev transfer token for a specified address
      * @param _to The address to transfer to.
      * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool ok) {
        return _transfer(msg.sender,_to,_value);
    }
    
    /**
      * @dev `msg.sender` approves `spender` to spend `value` tokens
      * @param _spender The address of the account able to transfer the tokens
      * @param _currentValue prevent double spend
      * @param _value The amount of wei to be approved for transfer
      * @return Whether the approval was successful or not
    */
    function approve(address _spender,uint256 _currentValue , uint256 _value) public notZeroAddress(_spender) returns(bool ok) {
        require(allowed[msg.sender][_spender] == _currentValue,ERR_ACTION_NOT_ALLOWED);
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender,_currentValue,_value);
        return true;
    }
    
    /**
      * @dev to check allowed token for transferFrom
      * @param _owner The address of the account owning tokens
      * @param _spender The address of the account able to transfer the tokens
      * @return Amount of remaining tokens allowed to spent
    */
    function allowance(address _owner, address _spender) public view returns (uint) {
        return allowed[_owner][_spender];
    }
    
    /**
       * @dev Transfer tokens from one address to another
       * @param _from address The address which you want to send tokens from
       * @param _to address The address which you want to transfer tokens
       * @param _value uint256 the amount of tokens to be transferred
   */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(allowed[_from][msg.sender] >= _value ,ERR_NOT_ENOUGH_BALANCE);
        require(_transfer(_from,_to,_value));
        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
        emit TransferFrom(msg.sender,_from,_to);
        return true;
    }
    
    
    
}