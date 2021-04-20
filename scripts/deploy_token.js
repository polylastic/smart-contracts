const hre = require("hardhat");

async function main() {
  const tokenName = "POLX Token";
  const symbol = "POLX";
  const totalSupply = "1000000000"; // Test-value

  const PolylasticToken = await hre.ethers.getContractFactory("PolylasticToken");
  const token = await PolylasticToken.deploy(tokenName, symbol, totalSupply);
  await token.deployed();
  console.log("Token deployed to:", token.address);
}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
