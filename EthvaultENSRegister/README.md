# Summary

This is the report from a security audit performed on [EthvaultENS](https://github.com/ethvault/ens-registrar-contract/blob/master/contracts/EthvaultENSRegistrar.sol) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of EthvaultENS smart contract.

# In scope

1. https://github.com/ethvault/ens-registrar-contract/blob/master/contracts/EthvaultENSRegistrar.sol

# Findings
In total, **2 issues** were reported including:

- 0 high severity issues.

- 1 medium severity issues.

- 0 owner privilegies issues.

- 0 low severity issues.

- 1 notes.

## Security issues

### 1. Any claimant can delete all others

#### Severity: medium

#### Description

Using function [`removeClaimants`](https://github.com/ethvault/ens-registrar-contract/blob/master/contracts/EthvaultENSRegistrar.sol#L47) some claimant can remove all other claimants and the contract owner from claimants array.

### 2. Extra checking

#### Severity: note

#### Description

Checking in [line 145](https://github.com/ethvault/ens-registrar-contract/blob/master/contracts/EthvaultENSRegistrar.sol#L145) has no meaning because there is after checking if `signer` is owner.

## Conclusion

Smart contract contains high severity issue.