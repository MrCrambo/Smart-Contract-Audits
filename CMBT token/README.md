# Summary

This is the report from a security audit performed on [CMBT](https://etherscan.io/address/0x3edd235c3e840c1f29286b2e39370a255c7b6fdb#code) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of CMBT smart contract.

# In scope

1. https://etherscan.io/address/0x3edd235c3e840c1f29286b2e39370a255c7b6fdb#code

# Findings
In total, **4 issues** were reported including:

- 0 high severity issues.

- 1 medium severity issues.

- 0 owner privilegies issues.

- 3 low severity issues.

- 0 notes.

## Security issues

### 1. No `Transfer` event call

#### Severity: low

#### Description

In function `constructor` in line 81 there are no event call, that funds transfered.

### 2. Transfer of Zero Value (ERC20 Compliance)

#### Severity: medium

#### Description

As per [ERC20 standard](https://eips.ethereum.org/EIPS/eip-20) `Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event` both `transfer` and `transferFrom` functions ignore transfers of zero value and throw, instead of threating it as normal transfers.

### 3. Zero address checking

#### Severity: low

#### Description

In functions `transfer` and `transferFrom` there are no zero address checking.

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

Smart contract contains medium severity issue.