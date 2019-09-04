# Summary

This is the report from a security audit performed on [SymVerse](https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of SymVerse smart contract.

# In scope

1. https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol

# Findings
In total, **6 issues** were reported including:

- 0 high severity issues.

- 2 medium severity issues.

- 3 owner privilegies issues.

- 1 low severity issues.

## Security issues

### 1. Owner privilegies

#### Severity: owner privilegies

#### Description

1) Owner can [change](https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol#L151) `delegator` any time he wants and to any address.
2) Owner can [`lock`](https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol#L450) all transfers and all function calls.
3) Owner can [increase unlock amount](https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol#L408) to any address and decrease it from any address at any time.

### 2. Increasing allowance

#### Severity: medium

#### Description

In function [`increaseAllowance`](https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol#L229) if owner will call this function, he will mint himself extra tokens without any restrictions.

### 3. Owner minting

#### Severity: medium

#### Description

Owner can [increase](https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol#L368) circulation supply any time he wants and can [burn](https://github.com/symverse-lab/SmartContract/blob/master/SymToken.sol#L377) any amount of tokens at any time. This could be risky for investors, because all their holding tokens could become unvaluable if owner will increase circulating supply.

### 4. Known vulnerabilities of ERC-20 token

#### Severity: low

#### Description

1. It is possible to double withdrawal attack. More details [here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)
2. Lack of transaction handling mechanism issue. More details [here](https://docs.google.com/document/d/1Feh5sP6oQL1-1NHi-X1dbgT3ch2WdhbXRevDN681Jv4/edit)

#### Recommendation

Add into a function `transfer(address _to, ... )` following code:
```solidity
require( _to != address(this) );
```

## Conclusion

Smart contract contains medium severity issues.