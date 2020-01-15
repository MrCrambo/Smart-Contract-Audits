pragma solidity 0.5.9;
import './StandardToken.sol';
import './Ownable.sol';


contract TokenUtils is StandardToken{
    
    // ActualPrice * 1000 
    // token price per token 
    uint public tokenPrice = 10;
    
    uint256 public tokenSaleStartDate = 0;
    
    // per ether token recived when fallback is called 
    uint public tokenPerEth = 10000;
    
    uint256 public tokenMaturityDays = 365;
    
    uint public tokenHoldBackDays = 90;
    
    uint public mintingFeesPercent = 2;
    
    bool public securityCheck = true;
    
    bool public preAuction = true;
    
    address payable public tokenHolderWallet = address(0);
    
    address public whiteListAddress = address(0);
    
    

    // Address which can perform action without any restrications
    mapping (address => bool) by_passed_address;
    
    // all value changed when contract deployed 
    constructor(string memory _name,
                string memory _symbol,
                address _systemAddress,
                address payable _tokenHolderWallet,
                address _whiteListAddress) public  notZeroAddress(_tokenHolderWallet) StandardToken(_name,_symbol,_systemAddress){
                    
        tokenHolderWallet = _tokenHolderWallet;
        tokenSaleStartDate = now;
        whiteListAddress = _whiteListAddress;
        by_passed_address[msg.sender] = true;
        by_passed_address[_systemAddress] = true;
        
    }

    event TokenPriceUpdated(uint _from,uint _to);
    event TokenPerEthUpdated(uint _from,uint _to);
    event TokenMintingFeeUpdated(uint _from,uint _to);
    event AddressByPassed(address indexed _which,bool _isPassed);
    event TokenHoldBackDaysUpdated(uint256 _from,uint256 _to);
    event TokenMaturityDaysUpdated(uint256 _from,uint256 _to);
    event TokenHolderWalletUpdated(address indexed _from,address indexed _to);
    event TokenReturnUpdated(address indexed _from,address indexed _to);
    event WhiteListAddressUpdated(address indexed _from,address indexed _to);
    
    function setTokenPrice(uint _tokenPrice) public onlySystem returns(bool){
        emit TokenPriceUpdated(tokenPrice,_tokenPrice);
        tokenPrice = _tokenPrice;
        return true;
    }
    
    
    function setTokenPerEth(uint _tokenPerEth) public onlySystem returns(bool){
        emit TokenPriceUpdated(tokenPerEth,_tokenPerEth);
        tokenPerEth = _tokenPerEth;
        return true;
    }
   
    function setByPassedAddress(address _which,bool _isPassed) public onlySystem returns(bool){
        by_passed_address[_which] = _isPassed;
        emit AddressByPassed(_which,_isPassed);
        return true;
    }
    
    function setWhiteListAddress(address _whiteListAddress)public onlySystem returns(bool){
        emit WhiteListAddressUpdated(whiteListAddress,_whiteListAddress);
        whiteListAddress = _whiteListAddress;
        return true;
    }
    
    
    function setTokenHoldBackDays(uint _holdBackDays) public onlyOwner returns(bool){
        emit TokenHoldBackDaysUpdated(tokenHoldBackDays,_holdBackDays);
        tokenHoldBackDays = _holdBackDays;
        return true;
    }
    
    function setTokenMaturityDays(uint256 _tokenMaturityDays) public onlyOwner returns(bool){
        emit TokenMaturityDaysUpdated(tokenMaturityDays,_tokenMaturityDays);
        tokenMaturityDays = _tokenMaturityDays;
        return true;
    }
    
    function setTokenHolderWallet(address payable _tokenHolderWallet) public onlyOwner returns(bool){
        emit TokenHolderWalletUpdated(tokenHolderWallet,_tokenHolderWallet);
        tokenHolderWallet = _tokenHolderWallet;
        return true;
    }
    
    
    function setPreAuction(bool _preAuction) public onlyOwner returns(bool){
        preAuction = _preAuction;
        return true;
    }
    
    function isTokenMature() public view returns(bool){
        if(tokenMaturityDays == 0)
            return false;
            
        uint256 tempDay = safeMul(86400,tokenMaturityDays);
        uint256 tempMature = safeAdd(tempDay,tokenSaleStartDate);
        if(now >= tempMature){
            return true;
        }
        return false;
    }
    
    function isHoldbackDaysOver() public view returns(bool){
        uint256 tempDay = safeMul(86400,tokenHoldBackDays);
        uint256 holdBackDaysEndDay = safeAdd(tempDay,tokenSaleStartDate);
        if(now >= holdBackDaysEndDay){
            return true;
        }
        return false;
    }
    
    
    
}