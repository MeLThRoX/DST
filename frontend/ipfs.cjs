const ipfs = require('ipfs-core')
const fs = require('fs')
const { join } = require('path')

function readFolder(path, filesArray) {
    let files = fs.readdirSync(path)
    filesArray = filesArray || []

    files.forEach(file => {
        const filePath = join(path, file)
        if (fs.statSync(filePath).isDirectory()) {
            filesArray = readFolder(filePath, filesArray)
        } else {
            const data = fs.readFileSync(filePath)
            filesArray.push({
                "path": "/" + filePath,
                "content": data
            })
        }
    })

    return filesArray
}

ipfs.create().then(async node => {
    for await (const result of node.addAll(readFolder("./build"))) {
        if (result.path === "build") {
            console.log(`ipfs://${result.cid.toString()}`)
            // const res = await node.name.publish(result.cid)
            // console.log(res.name)
        }
    }
})