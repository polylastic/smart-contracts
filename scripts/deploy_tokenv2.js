const hre = require("hardhat");

async function main() {
    const tokenName = "Polylastic";
    const symbol = "POLX";
    const totalSupply = "100000000000000000000000000000";
    const decimals = 18;

    const PolylasticTokenV2 = await hre.ethers.getContractFactory("PolylasticTokenV2");
    const token = await PolylasticTokenV2.deploy(tokenName, symbol, totalSupply, decimals);
    await token.deployed();
    console.log("PolylasticTokenV2 deployed to:", token.address);
}


main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
