const ethers = require("ethers")
const { readFileSync, writeFileSync } = require("fs")
const config = require("./config.json")

const abi = require("/contract/abi.json")
const bytecode = "0x" + readFileSync("/contract/bytecode")

const provider = ethers.getDefaultProvider(process.env.PROVIDER || 'rinkeby')

if (process.env.PRIVATE_KEY === undefined) {
    console.error("No private key set!")
    process.exit(1)
}

const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider)
const factory = new ethers.ContractFactory(abi, bytecode, wallet)

factory.deploy().then(contract => {
    config.contract_address = contract.address
    const data = JSON.stringify(config)
    writeFileSync("./config.json", data)
})