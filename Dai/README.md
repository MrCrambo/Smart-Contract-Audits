# Summary

This is the report from a security audit performed on [Dai](https://etherscan.io/address/0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359#code) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Dai smart contract.

# In scope

1. https://etherscan.io/address/0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359#code

# Findings
In total, **5 issues** were reported including:

- 0 high severity issues.

- 0 medium severity issues.

- 2 owner privilegies issues.

- 2 low severity issues.

- 1 notes.

## Security issues

### 1. Zero address checking

#### Severity: low

#### Description

In functions `setOwner(address owner_)` in line 129, `transferFrom(address src, address dst, uint wad)` in line 321 there are no zero address checking.

### 2. No `Transfer` event

#### Severity: note

#### Description

In `DSTokenBase(uint supply)` function in line 302 there is no `Transfer` event call after setting all total supply to the owner balance.

### 3. Known vulnerabilities of ERC-20 token

#### Severity: low

#### Description

1. It is possible to double withdrawal attack. More details [here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)
2. Lack of transaction handling mechanism issue. More details [here](https://docs.google.com/document/d/1Feh5sP6oQL1-1NHi-X1dbgT3ch2WdhbXRevDN681Jv4/edit)

#### Recommendation

Add into a function `transfer(address _to, ... )` following code:
```solidity
require( _to != address(this) );
```

### 4. Owner privilegies

#### Severity: owner privilegies

#### Description

1) Owner can stop contract any time.
2) Owner can change smart contract name any time.

## Conclusion

Smart contract contains only low severity issues.