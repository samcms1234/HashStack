# HashStack Assignment

1) Write a scalable multi-signature wallet contract, which requires a minimum of 60% authorization by the signatory wallets to perform a transaction. 


Contract Deployment Address(Goerli Testnet): ```shell
0x775caaa230db5a2ed32090cecaf515beda3957fb
```

2) Write an access registry contract that stores the signatories of this multi-sig wallet by address. This access registry contract will have its own admin. Further, the access registry contract must be capable of adding, revoking, renouncing, and transfer of signatory functionalities.

```
Contract Deployment Address(Goerli Testnet): ```shell
0x848e3d20a46a84929c746d582e59254453690995
```

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
