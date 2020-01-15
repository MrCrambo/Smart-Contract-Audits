pragma solidity 0.5.9;
import './Constant.sol';

contract Ownable is Constant{
    
    address public primaryOwner = address(0);
    address public systemAddress = address(0);
    

    /**
    * @dev The Ownable constructor sets the `primaryOwner` and `systemAddress`
    * account.
    */
    constructor(address _systemAddress) public notOwnAddress(_systemAddress) notZeroAddress(_systemAddress){
        primaryOwner = msg.sender;
        systemAddress = _systemAddress;
    }
    
    event OwnershipTransferred(string ownerType,address indexed previousOwner, address indexed newOwner);
    
    
    modifier onlyOwner() {
        require(msg.sender == primaryOwner,ERR_ACTION_NOT_ALLOWED);
        _;
    }

    modifier onlySystem() {
        require(msg.sender == primaryOwner || msg.sender == systemAddress,ERR_ACTION_NOT_ALLOWED);
        _;
    }

    
    /**
    * @dev change primary ownership
    * @param _which The address to which is new owner address
    */
    function changePrimaryOwner(address _which) public onlyOwner notZeroAddress(_which) notOwnAddress(_which) returns(bool){
        emit OwnershipTransferred("PRIMARY_OWNER",primaryOwner,_which);
        primaryOwner = _which;
        return true;
    }

    
    /**
    * @dev change system address
    * @param _which The address to which is new system address
    */
    function changeSystemAddress(address _which) public onlyOwner notZeroAddress(_which) notOwnAddress(_which) returns(bool){
        emit OwnershipTransferred("SYSTEM_ADDRESS",systemAddress,_which);
        systemAddress = _which;
        return true;
    }
  
  


}