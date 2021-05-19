const hre = require("hardhat");
const { getSavedContractAddresses, saveContractAddress } = require('./utils')

async function main() {
    const tokenName = "Polylastic";
    const symbol = "POLX";
    const totalSupply = "100000000000000000000000000000";
    const decimals = 18;
    const treasury = '0x10AbD2aF6ebcc1b9b1bD19A6f4F33815d2856Cab';

    const PolylasticTokenV2 = await hre.ethers.getContractFactory("PolylasticTokenV2");
    const token = await PolylasticTokenV2.deploy(tokenName, symbol, totalSupply, decimals, treasury);
    await token.deployed();
    console.log("PolylasticTokenV2 deployed to:", token.address);
    saveContractAddress(hre.network.name, 'PolylasticTokenV2', token.address);
}


main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
