const hre = require("hardhat");
const { getSavedContractAddresses, saveContractAddress } = require('./utils')
const config = require('./config.json');

async function main() {

    const signerAddress = config.signerAddress;
    const amountPerWallet = config.amount;

    const Airdrop = await hre.ethers.getContractFactory("Airdrop");

    const airdrop = await Airdrop.deploy(signerAddress, amountPerWallet, getSavedContractAddresses()[hre.network.name]['PolylasticTokenV2']);
    await airdrop.deployed();
    console.log("Airdrop deployed to: ", airdrop.address);
    saveContractAddress(hre.network.name, 'Airdrop', airdrop.address);
}


main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
