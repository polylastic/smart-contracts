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

    const TokenSwap = await hre.ethers.getContractFactory('TokenSwapPortal');
    const tokenSwapPortal = await TokenSwap.deploy(
        getSavedContractAddresses()[hre.network.name]['PolylasticToken'],
        getSavedContractAddresses()[hre.network.name]['PolylasticTokenV2']
    )
    await tokenSwapPortal.deployed();
    console.log('TokenSwap portal is deployed to: ',tokenSwapPortal.address);
    saveContractAddress(hre.network.name, 'TokenSwapPortal', tokenSwapPortal.address)

    //TODO: NOT PRODUCTION USE, TEST ONLY, FUND THE AIRDROP PORTAL
    const tokenV2 = await hre.ethers.getContractAt('PolylasticTokenV2', getSavedContractAddresses()[hre.network.name]['PolylasticTokenV2']);
    await tokenV2.transfer(airdrop.address, "10000000000000000000000");

    //TODO: TokenSWAP ALSO
    await tokenV2.transfer(tokenSwapPortal.address, "100000000000000000000000");
}


main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
