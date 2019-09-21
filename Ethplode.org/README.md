# Summary

This is the report from a security audit performed on [Ethplode](https://github.com/ETHplode/ETHplode-Source/blob/master/Token.sol) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Ethplode smart contract.

# In scope

1. https://github.com/ETHplode/ETHplode-Source/blob/master/Token.sol

# Findings
In total, **4 issues** were reported including:

- 2 high severity issues.

- 0 medium severity issues.

- 0 owner privilegies issues.

- 2 low severity issues.

- 0 notes.

## Security issues

### 1. Wrong burning

#### Severity: high

#### Description

In function [`transfer`](https://github.com/ETHplode/ETHplode-Source/blob/master/Token.sol#L122) there is burning from `owner` address after transfer, but in this case there will be subtrating of extra 0.5% tokens (in total 1%) and burning of only 0.5%.
Read comments in code below:
```solidity
        burn(owner, tokensBurn); // here is burning of 0.5% from total supply and subtracting 0.5% from owner balance
        
        balances[msg.sender] = safeSub(balances[msg.sender], _tokens); // here is the also subtracting of 0.5% tokens which are just disappear
        balances[to] = safeAdd(balances[to], readyTokens);
```
After each `transfer` there will be extra 0.5% of transferable tokens lost and total supply will be more than total tokens amount.
Also if `owner` will has no tokens, then `transfer` function will not work.

#### Recommendation

Burn tokens from `msg.sender` address and subtract `readyTokens` from `msg.sender` balance.
```solidity
        burn(msg.sender, tokensBurn);
        
        balances[msg.sender] = safeSub(balances[msg.sender], readyTokens);
        balances[to] = safeAdd(balances[to], readyTokens);
```

### 2. Zero address checking

#### Severity: low

#### Description

There is no zero address checking in functions [`transfer`](https://github.com/ETHplode/ETHplode-Source/blob/master/Token.sol#L122), [`transferFrom`](https://github.com/ETHplode/ETHplode-Source/blob/master/Token.sol#L158) and [`transferOwnership`](https://github.com/ETHplode/ETHplode-Source/blob/master/Token.sol#L158).

### 3. No token burning

#### Severity: high

#### Description

In function [`transferFrom`](https://github.com/ETHplode/ETHplode-Source/blob/master/Token.sol#L158) there is no 0.5% of tokens burning, but it should be by the logic of contract. So users will use this function instead of `transfer` for saving their 0.5% of tokens.

### 4. Known vulnerabilities of ERC-20 token

#### Severity: low

#### Description

1. It is possible to double withdrawal attack, because `increaseAllowance` and `decreaseAllowance` functions call inside of them approve function, but not add or decrease value. More details [here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)
2. Lack of transaction handling mechanism issue. More details [here](https://docs.google.com/document/d/1Feh5sP6oQL1-1NHi-X1dbgT3ch2WdhbXRevDN681Jv4/edit)

#### Recommendation

Add into a function `transfer(address _to, ... )` following code:
```solidity
require( _to != address(this) );
```

## Conclusion

Smart contract contains high severity issues.