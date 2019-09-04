# Summary

This is the report from a security audit performed on [Bills Of Exchange Factory](https://ropsten.etherscan.io/address/0x74eB4DBD3124D41B6775701FD1821571EAd5cf9A#contracts) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Bills Of Exchange Factory smart contract.

# In scope

1. https://ropsten.etherscan.io/address/0x74eB4DBD3124D41B6775701FD1821571EAd5cf9A#contracts

# Findings
In total, **4 issues** were reported including:

- 0 high severity issues.

- 1 medium severity issues.

- 1 owner privilegies issues.

- 2 low severity issues.

## Security issues

### 1. Wrong ERC223 implementation

#### Severity: medium

#### Description

Function `transfer(address _to, uint256 _value)` at line 250 doesn't call fallback function, but it should. Look the right realisation of ERC223 standard by [link](https://github.com/Dexaran/ERC223-token-standard/blob/master/token/ERC223/ERC223_token.sol#L38).

### 2. Zero address checking

#### Severity: low

#### Description

There are possibility of setting zero address in function `initToken` at line 187, in function `changeCryptonomicaVerificationContractAddress` at line 450, in function `signDisputeResolutionAgreementFor` at line 737, in function `initBillsOfExchange` at line 786, in function `setLegal` at line 851, in function `createBillsOfExchange` at line 981.

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

1) Owner can change price at any time, line 615.

## Conclusion

Smart contract contains medium severity issue.