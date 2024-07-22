const { network, deployments } = require("hardhat")
const { developmentChains, INITIAL_ANSWER, DECIMALS } = require("../helper-hardhat-config")
const { Contract } = require("ethers")
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    if (developmentChains.includes(network.name)) {
        log("local network detected! Deploying mocks...")
        await deploy("MockV3Aggregator", {
            Contract: "MockV3Aggregator",
            from: deployer,
            log: true, 
            args:[DECIMALS, INITIAL_ANSWER]
        })
    }
}

module.exports.tags = ["all","mocks"]