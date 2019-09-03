# Summary

This is the report from a security audit performed on [DarbFinance](https://etherscan.io/address/0xc224dfe42a5332a497334fadb8fed7e7aa4bdf13#contracts) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of DarbFinance smart contract.

# In scope

1. https://etherscan.io/address/0xc224dfe42a5332a497334fadb8fed7e7aa4bdf13#contracts

# Findings
In total, **6 issue** was reported including:

- 0 high severity issues.

- 1 medium severity issues.

- 1 owner privilegies issues.

- 4 low severity issues.

- 0 notes.

## Security issues

### 1. No `Transfer` event call

#### Severity: low

#### Description

In functions `burn` in line 63 and `mintFromTraded` in line 70 there are no event call, that funds transfered.

### 2. No `Approval` event call

#### Severity: low

#### Description

In function `transferFrom` there is no `Approval` event call after transfering from.

### 3. Transfer of Zero Value (ERC20 Compliance)

#### Severity: medium

#### Description

As per [ERC20 standard](https://eips.ethereum.org/EIPS/eip-20) `Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event` transfer function ignores transfers of zero value and throw, instead of threating it as normal transfers.

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

### 5. Owner privilegies

#### Severity: owner privilegies

#### Description

Owner can `pause` transfers any time without any restrictions.

### 6. Zero address checking

#### Severity: low

#### Description

There is no zero address checking in function `transferFrom` in line 124.

## Conclusion

Smart contract contains medium severity issue.