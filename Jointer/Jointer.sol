pragma solidity 0.5.11;
import './TokenUtils.sol';
import './ERC20.sol';


contract WhiteList{
    //whiteList functions
    function isWhiteListed(address _who) public view returns(bool);
    
    function canSentToken(address _which)public view returns (bool);
    
    function canReciveToken(address _which)public view returns (bool);
    
    function isTransferAllowed(address _who)public view returns(bool);
}

contract Tokens is TokenUtils{
    
   
    event WalletForcedSwaped(address indexed _whom,uint256 _burnedTokens,uint256 _thisTokenPrice,
                             address indexed _returnToken,uint256 _returnTokenAmount,uint256 _returnTokenPrice,
                             uint256 _time);
    
    constructor(string memory _name,
                string memory _symbol,
                address _systemAddress,
                address payable _tokenHolderWallet,
                uint256 reserveSupply,
                uint256 holdBackSupply,
                address _whiteListAddress) public  TokenUtils(_name,_symbol,
                                                            _systemAddress,
                                                            _tokenHolderWallet,
                                                            _whiteListAddress){
                                                    
        reserveSupply = reserveSupply * 10 ** uint256(decimals);
        holdBackSupply = holdBackSupply * 10 ** uint256(decimals);
        
        if(reserveSupply > 0)
            _mint(address(this),reserveSupply);
            
        if(holdBackSupply > 0 )
            _mint(_tokenHolderWallet,holdBackSupply);
    
    }

    
    /**
       * @dev checkBeforeTransfer is validation for trnasfer
    */
    function checkBeforeTransfer(address _from,address _to) internal view returns(bool){
        if(securityCheck && by_passed_address[msg.sender] == false){
            require(WhiteList(whiteListAddress).isWhiteListed(_from) && WhiteList(whiteListAddress).isWhiteListed(_to),ERR_TRANSFER_CHECK_WHITELIST);
            require(WhiteList(whiteListAddress).canSentToken(_from)&& WhiteList(whiteListAddress).canReciveToken(_to),ERR_TRANSFER_CHECK_BLOCK_WALLET);
            require(WhiteList(whiteListAddress).isTransferAllowed(_to) && !isTokenMature() && isHoldbackDaysOver(),ERR_ACTION_NOT_ALLOWED);
        }
        return true;
    }
    

    function transfer(address _to, uint256 _value) public returns (bool ok) {
        require(checkBeforeTransfer(msg.sender,_to));
        return super.transfer(_to,_value);
    }
    
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(checkBeforeTransfer(_from,_to));
        return super.transferFrom(_from,_to,_value);
    }
    
    
    /**
       * @dev Transfer tokens from this address to another
       * @param _to address The address which you want to transfer to
       * @param _value uint256 the amount of tokens to be transferred
    */
    function assignToken(address _to,uint256 _value) public onlySystem returns (bool){
        return _transfer(address(this),_to,_value);
    }
    
    /**
       * @dev TransferFrom tokens from this address to another  
       *    we need this function bcz forceswap with other equiatiy and note tokens 
       * @param _spender address The address which you want to transfer to
       * @param _value uint256 the amount of tokens to be transferred
    */
    function allowTrasferFrom(address _spender,uint256 _value) public onlySystem returns (bool){
        allowed[address(this)][_spender] = _value;
        emit Approval(address(this), _spender,0,_value);
        return true;
    }
    
    /**
       * @dev burn token from this address
       * @param _value uint256 the amount of tokens to be burned
    */
    function burnFromAccount(uint256 _value) public onlyOwner returns (bool){
        return _burn(address(this),_value);
    }
    
    /**
       * @dev burn token from this address
       * @param _value uint256 the amount of tokens to be burned
    */
    function burn(uint256 _value) public returns (bool){
        return _burn(msg.sender,_value);
    }
    
    
    /**
       * @dev mint more tokens 
       * @param _to address The address which you want to mint token
       * @param _value uint256 the amount of tokens to be mint
    */
    function mint(address _to,uint256 _value) public onlySystem returns (bool){
        if(preAuction && mintingFeesPercent > 0){
           uint256 mintingFee = safeDiv(safeMul(_value,mintingFeesPercent),100);
           require(tokenHolderWallet != address(0),ERR_ZERO_ADDRESS);
            _mint(_to,_value);
            return _mint(tokenHolderWallet,mintingFee);
        }else{
            return _mint(_to,_value);
        }

    }
    
    
    
    //In case if there is other tokens into contract
    function returnTokens(address _tokenAddress,address _to,uint256 _value) public notThisAddress(_tokenAddress) onlyOwner returns (bool){
        ERC20 tokens = ERC20(_tokenAddress);
        return tokens.transfer(_to,_value);
    }
    
    
    /**
       * @dev forceswap wallet with other equivalent tokens 
       * as we whitelist all user we can notify them before forceSwap 
       * to transfer any stable coin 
       * @param _to address which is swaped
       * @param _returnToken which user get behalf of this tokens
       * @param _thisTokenPrice current token price 
       * @param _from from which wallet token transferred
       * @param _returnAmount return token amount
       * @param _returnTokenPrice return token Price 
       * @return return true if successful
    */
    function forceSwapWallet(address _to,
                            address _returnToken,
                            uint256 _thisTokenPrice,
                            address _from,
                            uint256 _returnAmount,
                            uint256 _returnTokenPrice) public notThisAddress(_returnToken)  
                            notZeroAddress(_to) notZeroAddress(_returnToken) 
                            notZeroValue(_returnAmount) onlySystem returns (bool){
        
        require(ERC20(_returnToken).transferFrom(_from,_to,_returnAmount));
        uint256 _balance = balances[_to];
        require(_burn(_to,balances[_to]),ERR_TOKEN_SWAP_FAILED);
        emit WalletForcedSwaped(_to,_balance,_thisTokenPrice,_returnToken,_returnAmount,_returnTokenPrice,now);
        return true;
    }
    
    //in case there is ether in contarct 
    function finaliaze() public onlyOwner returns(bool){
        tokenHolderWallet.transfer(address(this).balance);
    }
    
    function() external notZeroValue(msg.value) notZeroValue(tokenPerEth) notZeroAddress(tokenHolderWallet) payable{
       uint256 transferToken = safeMul(msg.value,tokenPerEth);
       require(WhiteList(whiteListAddress).isWhiteListed(msg.sender) && WhiteList(whiteListAddress).canReciveToken(msg.sender),ERR_ACTION_NOT_ALLOWED);
       require(_transfer(address(this),msg.sender,transferToken));
       tokenHolderWallet.transfer(msg.value);
    }
    
}
