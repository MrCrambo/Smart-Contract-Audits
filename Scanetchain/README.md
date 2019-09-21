# Summary

This is the report from a security audit performed on [Scanetchain](https://github.com/Scanetchain/Scanetchain-ERC20-Token/blob/master/Contracts/scanetchaintoken_new_final.sol) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Scanetchain smart contract.

# In scope

1. https://github.com/Scanetchain/Scanetchain-ERC20-Token/blob/master/Contracts/scanetchaintoken_new_final.sol

# Findings
In total, **2 issues** were reported including:

- 0 high severity issues.

- 0 medium severity issues.

- 1 owner privilegies issues.

- 1 low severity issues.

- 0 notes.

## Security issues

### 1. Owner privilegies

#### Severity: owner privilegies

#### Description

- Owner can [`pause`](https://github.com/Scanetchain/Scanetchain-ERC20-Token/blob/master/Contracts/scanetchaintoken_new_final.sol#L98) contract any time.

### 2. Known vulnerabilities of ERC-20 token

#### Severity: low

#### Description

Lack of transaction handling mechanism issue. More details [here](https://docs.google.com/document/d/1Feh5sP6oQL1-1NHi-X1dbgT3ch2WdhbXRevDN681Jv4/edit)

#### Recommendation

Add function to withdraw other contract tokens.

## Conclusion

Smart contract is free of issues.