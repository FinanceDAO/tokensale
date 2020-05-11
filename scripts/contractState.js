let ethers = require('ethers')
const BigNumber = require('bignumber.js');


const main = async () => {
    const url = "http://localhost:8545";
    const privateKey = '0xa8a54b2d8197bc0b19bb8a084031be71835580a01e70a45a13babd16c9bc1563'
    const TOKENSALE_CONTRACT = '0x8f1cf28dcd72f5cf75091e61bf99f7ac2edb9dac'
    const provider = new ethers.providers.JsonRpcProvider(url);
    let wallet = new ethers.Wallet(privateKey, provider)
    wallet = wallet.connect(provider)

    let abi = [
        'function isOpen() public view returns (bool)',
        'function rate() public view returns (uint256)',
        'function tokensSold() public view returns (uint256)',
        'function cap() public view returns (uint256)'

    ]

    let sale = new ethers.Contract(TOKENSALE_CONTRACT, abi, wallet)
    let open = await sale.isOpen()
    console.log(`sale open:    ${open}`)
    console.log('tokens sold: ', + BigNumber(await sale.tokensSold()).toString())
    console.log('tokens cap:  ', + BigNumber(await sale.cap()).toString())
    console.log('tokens rate: ', + BigNumber(await sale.rate()).toString())
}

main()