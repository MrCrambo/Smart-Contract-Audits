# Summary

This is the report from a security audit performed on [Omnis_v2](https://drive.google.com/file/d/1OMN_WcIWpCvmtkOEcaDYhawwDTm1Qm1y/view) by [MrCrambo](https://github.com/MrCrambo).

The audit focused primarily on the security of Omnis_v2 smart contract.

# In scope

1. https://drive.google.com/file/d/1OMN_WcIWpCvmtkOEcaDYhawwDTm1Qm1y/view

# Findings
In total, **1 issue** was reported including:

- 0 high severity issues.

- 1 medium severity issues.

- 0 owner privilegies issues.

- 0 low severity issues.

- 0 notes.

## Security issues

### 1. Lost of all staked balance

#### Severity: medium

#### Description

If some address will get lot of transfers each of them will be added to his staked balance, but if he will `transfer`(line 384) or `transferFrom` (line 414) some amount of tokens he will lose all his staked balance. And even after he will receive this transfered value again, he will get only staked amount calculated using this amount. Look comments:
```solidity
if (staked[_from] != 0) staked[_from] = 0;  <- here he will lose all his staked amount
uint64 _now = uint64(now);
lastTransfer[_from] = transferInStruct(uint128(balances[_from]), _now);  <- here will be stored only last value, so in case he will transfer 1 wei, he will get almost nothing then

if (_from != _to) { //Prevent double stake

     if (uint(lastTransfer[_to].time) != 0) {
           uint nCoinSeconds = now.sub(uint(lastTransfer[_to].time));
           if (nCoinSeconds > stakeMaxAge) nCoinSeconds = stakeMaxAge;
           staked[_to] = staked[_to].add(uint(lastTransfer[_to].amount).mul(nCoinSeconds.div(1 days)));  <- in case someone will sent to us some value, there will be called this line and we will get 1 wei multiplied to the time, so we will lost all the staked before amount.
     }

     lastTransfer[_to] = transferInStruct(uint128(_value), _now);
}
```
Also same issue in function `claimAirdrop` in line 655.
 
## Conclusion

Smart contract contains medium severity issue.