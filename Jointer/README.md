# Summary

This is the report from a security audit performed on [Jointer](https://github.com/mak2296/JntrToken) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Jointer smart contracts.

# In scope

1. https://github.com/mak2296/JntrToken/blob/master/ERC20.sol
2. https://github.com/mak2296/JntrToken/blob/master/MultiOwnable.sol
3. https://github.com/mak2296/JntrToken/blob/master/Ownable.sol
4. https://github.com/mak2296/JntrToken/blob/master/SafeMath.sol
5. https://github.com/mak2296/JntrToken/blob/master/StandardToken.sol
6. https://github.com/mak2296/JntrToken/blob/master/Token.sol
7. https://github.com/mak2296/JntrToken/blob/master/TokenUtil.sol
8. https://github.com/mak2296/JntrToken/blob/master/WhiteList.sol

# Findings
In total, **4 issues** were reported including:

- 1 critical severity issues.

- 0 high severity issues.

- 0 medium severity issues.

- 1 owner privilegies issues.

- 2 low severity issues.

## Security issues

### 1. Wrong modifier

#### Severity: low severity

#### Description

Modifier [`onlySystem`](https://github.com/mak2296/JntrToken/blob/master/MultiOwnable.sol#L41) should check only system address, not also owner address.

### 2. Zero address checking

#### Severity: low severity

#### Description

In function [`allowChangePrimaryOwner`](https://github.com/mak2296/JntrToken/blob/master/MultiOwnable.sol#L57), [`setWhiteListAddress`](https://github.com/mak2296/JntrToken/blob/master/Token.sol#L75),[`setUtilsAddress`](https://github.com/mak2296/JntrToken/blob/master/Token.sol#L79) 

### 3. Swap after burning

#### Severity: critical severity

#### Description

In function [`forceSwapWallet`](https://github.com/mak2296/JntrToken/blob/master/Token.sol#L169) there is swapping tokens after burning address's balance, so function [`token.swapForToken`](https://github.com/mak2296/JntrToken/blob/master/Token.sol#L177) will get 0 as user balance instead of getting his real balance.

#### Recommendation

There is two possibilities: 1) to burn after tokens swapped and 2) to use some local variable for holding users balance.

### 4. Owner prvivilegies

#### Severity: owner prvivilegies

#### Description

Owner can [change token price](https://github.com/mak2296/JntrToken/blob/master/TokenUtil.sol#L59) without any restrictions.

## Conclusion

Smart contracts contain critical severity issue and should be fixed before deploying.