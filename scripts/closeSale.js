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
        'function openSale(uint256 _rate, uint256 _cap) external',
        'function closeSale() external',
        'function isOpen() public view returns (bool)',
        'function rate() public view returns (uint256)',
        'function tokensSold() public view returns (uint256)',
        'function cap() public view returns (uint256)'

    ]

    const bigExp = (x, y) =>
    ethers.utils
        .bigNumberify(x)
        .mul(ethers.utils.bigNumberify(10).pow(ethers.utils.bigNumberify(y)))
    
    pct18 = (x) => bigExp(x, 18)

    let sale = new ethers.Contract(TOKENSALE_CONTRACT, abi, wallet)

    var closeSale = sale.closeSale();

    closeSale.then(function(transaction) {
        // The transaction has been delivered to the network (but not mined)
        console.log('Close Sale!');
        console.log(transaction);
        
    }).catch(function(error) {
        if (error.message === 'cancelled') {
            console.log('Transaction was declined by the user');
        } else {
            console.log('Unknown Error');
            console.log(error);
        }
    });
}

main()