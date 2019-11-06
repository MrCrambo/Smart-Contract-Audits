# Summary

This is the report from a security audit performed on [UCOIN](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of UCOIN smart contracts.

# In scope

1. https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol

# Findings
In total, **10 issues** were reported including:

- 1 high severity issues.

- 1 medium severity issues.

- 3 owner privilegies issues.

- 4 low severity issues.

- 1 notes.

## Security issues

### 1. Contract name

#### Severity: note

#### Description

Contract name should start with upper case in contract [`owner`](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol#L8)

### 2. Zero address checking

#### Severity: low

#### Description

There is no zero address checking in fucntion [`transferOwnership`](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol#L20)

### 3. No event call

#### Severity: low

#### Description

There is no `Transfer` event call in [`constructor`](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol#L50)

### 4. Known vulnerabilities of ERC-20 token

#### Severity: low

#### Description

It is possible to double withdrawal attack because in function [`transferFrom`](https://github.com/cryptomillionsofficial/CREATE_ERC20_CPM1_V2/blob/master/ERC20_CPM1_Token_v2.sol#L94) there is calling of `approve` function. More details [here](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)

#### Recommendation

Add `decreaseApproval` function in `transferFrom` function instead of `approve`.

### 5. Integer overflow possibility

#### Severity: medium

#### Description

There is integer overflow possiblity in function [`mintToken`](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol#L210).

#### Recommendation

Use `SafeMath` library.

### 6. Owner privilegies

#### Severity: owner privilegies

#### Description

- Owner can [`freeze`](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol#L220) any address without restrictions.
- Owner can [`change prizes`](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol#L228) any time.
- Owner can mint any amount of tokens and without any time restrictions,it could be risky for users.

### 7. Division

#### Severity: low

#### Description

In function [`buy`](https://github.com/ucoincurrency/UCOIN/blob/master/UCOIN_Smart_Contract.sol#L234) there is possibility of tokens lose because of division.

### 7. Buy/Sell

#### Severity: high

#### Description

The buy and sell price is set by two variables that do not contain nominator and denominator information, meaning that for example the sell price set to a minimum will be 1 wei making the price of 1 token that is sold to the contract equal to 1 ether since the decimals are equal to 18.

Developers should be aware that this will not give them any flexibility to set the token sell and buy prices, meaning that the buy price for 1 token should be higher than 1 ether (please note that following this logic more than 5 billions ether are needed to buy all the tokens buy the investors).

## Conclusion

Smart contract contains medium and high severity issues.