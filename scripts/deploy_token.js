const hre = require("hardhat");

async function main() {
  const tokenName = "Polylastic";
  const symbol = "POLX";
  const totalSupply = "100000000000000000000000000000";
  const decimals = 18;

  const PolylasticToken = await hre.ethers.getContractFactory("PolylasticToken");

  const token = await PolylasticToken.deploy(tokenName, symbol, totalSupply, decimals);
  await token.deployed();
  console.log("Token deployed to:", token.address);
}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
