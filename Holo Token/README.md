# Summary

This is the report from a security audit performed on [Holo](https://etherscan.io/address/0x6c6ee5e31d828de241282b9606c8e98ea48526e2#contracts) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Holo smart contracts.

# In scope

1. https://etherscan.io/address/0x6c6ee5e31d828de241282b9606c8e98ea48526e2#contracts

# Findings
In total, **3 issues** were reported including:

- 0 high severity issues.

- 0 medium severity issues.

- 1 owner privilegies issues.

- 2 low severity issues.

## Security issues

### 1. Zero addres checking

#### Severity: low

#### Description

There are no zero address checking in functions `setMinter` at line 239, `setDestroyer` at line 269 and `mint` at line 243.

### 2. Known vulnerabilities of ERC-20 token

#### Severity: low

#### Description

1. It is possible to double withdrawal attack. More details [here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)
2. Lack of transaction handling mechanism issue. More details [here](https://docs.google.com/document/d/1Feh5sP6oQL1-1NHi-X1dbgT3ch2WdhbXRevDN681Jv4/edit)

#### Recommendation

Add into a function `transfer(address _to, ... )` following code:
```solidity
require( _to != address(this) );
```

### 3. Owner privilegies

#### Severity: owner privilegies

#### Description

1) Owner can mint any amount of tokens and for a long period of time, because he can not finish minting and can set himself as minter.

## Conclusion

Smart contract contains only low severity issues.