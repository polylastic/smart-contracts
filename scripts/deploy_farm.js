const hre = require("hardhat");
const { getSavedContractAddresses, saveContractAddress } = require('./utils')
const { ethers, web3 } = hre
const BigNumber = ethers.BigNumber

async function main() {

    const contracts = getSavedContractAddresses()[hre.network.name];

    const startSecond = 1622815800;

    const rewardsPerSecond = ethers.utils.parseEther("126.84");

    const allocPoints = {
        lp: 60,
        polx: 40,
        placeHolder: 300
    };

    const Farm = await hre.ethers.getContractFactory('Farm');


    const farm = await Farm.deploy(
        contracts["PolylasticTokenV2"],
        rewardsPerSecond,
        startSecond
    );
    await farm.deployed();
    console.log('Farm deployed: ', farm.address);
    saveContractAddress(hre.network.name, 'Farm', farm.address);

    // await farm.add(allocPoints.lp, contracts['LpToken'], true);
    // await farm.add(allocPoints.polx, contracts['PolylasticTokenV2'], true);
    // await farm.add(allocPoints.placeHolder, contracts['DevToken'], true);
    //
    // const polx = await hre.ethers.getContractAt('PolylasticTokenV2', contracts['PolylasticTokenV2']);
    // const devToken = await hre.ethers.getContractAt('DevToken', contracts['DevToken']);
    //
    // let totalRewards = ethers.utils.parseEther("500000");
    // await polx.approve(farm.address, totalRewards);
    // console.log('Approval for farm done properly.');
    //
    // const totalSupplyDevToken = ethers.utils.parseEther('10000');
    // await devToken.approve(farm.address, totalSupplyDevToken);
    // console.log('Dev token successfully approved.');
    //
    // await farm.deposit(2, totalSupplyDevToken);
    // console.log('Dev token deposited amount: ', totalSupplyDevToken);

    // await farmingXava.fund(totalRewards);
    // console.log('Funded farm.');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
