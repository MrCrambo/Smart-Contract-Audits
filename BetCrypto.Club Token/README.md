# Summary

This is the report from a security audit performed on [BetCrypto](https://etherscan.io/address/0xd0864e40a0a5f8c988a8b247b4d8d48249306546#code) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of BetCrypto smart contract.

# In scope

1. https://etherscan.io/address/0xd0864e40a0a5f8c988a8b247b4d8d48249306546#code

# Findings
In total, **2 issues** were reported including:

- 0 high severity issues.

- 0 medium severity issues.

- 0 owner privilegies issues.

- 1 low severity issues.

- 1 notes.

## Security issues

### 1. Known vulnerabilities of ERC-20 token

#### Severity: low

#### Description

It is possible to double withdrawal attack because in function `transferFrom` there is calling of `approve` function. More details [here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)

#### Recommendation

Add `decreaseApproval` function in `transferFrom` function instead of `approve`.

### 2. Extra function

#### Severity: note

#### Description

Function `_burnFrom` will never be used because it's internal.

## Conclusion

Smart contract contains only low severity issues.