// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const [ owner1, owner2, owner3, owner4] = await ethers.getSigners();
  const owners = [owner1.address, owner2.address, owner3.address, owner4.address];

  const MultiSignatureWallet = await ethers.getContractFactory('MultiSignatureWallet');
  const multiSignatureWallet = await MultiSignatureWallet.deploy(
    owners,
    owner1.address,
  );
  await multiSignatureWallet.deployed();

  console.log(`Deployed MultiSignatureWallet Contract at: ${multiSignatureWallet.address}`)


  console.log(`Multi Signature Wallet Contract Deployed`);


  const AccessRegistryContract = await ethers.getContractFactory('AccessRegistryContract');
  const accessRegistryContract = await AccessRegistryContract.deploy(
    owners,
  );
  await accessRegistryContract.deployed();

  console.log(`Deployed AccessRegistryContract Contract at: ${accessRegistryContract.address}`)
  console.log(`Access Register Contract Deployed`);


  console.log('Finished.');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});