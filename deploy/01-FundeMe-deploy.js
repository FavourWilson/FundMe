const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network } = require("hardhat")
const {verify} = require("../utils/verify")
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let ethUsdPriceFeedAddress; 
    if (developmentChains.includes(network.name)) {
        const ethUsdPriceFeed = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdPriceFeed.address
        console.log("ethUsdPriceFeedAddress (dev):", ethUsdPriceFeedAddress);

    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
        console.log("ethUsdPriceFeedAddress (non-dev):", ethUsdPriceFeedAddress);

    }
   

    const args = [ethUsdPriceFeedAddress]

    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args,
        log: true
    })

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        await verify(fundMe.address, args)
    }
}

module.exports.tags = ["all","fundme"]