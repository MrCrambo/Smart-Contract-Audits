# Summary

This is the report from a security audit performed on [Techruption](https://pastebin.com/Bp6P9XZ0) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Techruption smart contract.

# In scope

1. https://pastebin.com/Bp6P9XZ0

# Findings
In total, **2 issues** were reported including:

- 1 high severity issues.

- 0 medium severity issues.

- 0 owner privilegies issues.

- 1 low severity issues.

- 0 notes.

## Security issues

### 1. Zero address checking

#### Severity: low

#### Description

In functions `set(address a, uint v)` in line 28, `updateGovernorUpdate(address _governor)` in line 38, `updateGovernorExecute(address _governor)` in line 43, `set(address a, uint v)` in line 70, `transferStorage(address newOwner)` in line 50 there are no zero address checking.

### 2. `tx.origin` exploit

#### Severity: high

#### Description

`tx.origin` should never be used for authorization, contract contains a modifier in line 158 that checks if tx.orign is the owner of smart contract contract. The same modifier is used in multiple functions to grant access to them and it can be exploited using a proxy contract to do multiple actions. 

If the victim is lured to call the attacker contract, the victim address will be equal to `tx.orgin` thus any external call from the attacker contract using the same transaction will grant access to most sensible functions of smart contract.

## Conclusion

Smart contract contains high severity issue.