import logging
import os
import json
import time
from web3 import (
    IPCProvider,
    Web3,
)
from web3.middleware import(
    geth_poa_middleware,        
)
from config import (
    TokenContractAddress,        
    IPC_PATH,
)

LEVEL = logging.INFO
FORMAT = "[%(levelname)s]: %(asctime)-15s %(message)s"
DATEFMT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(level=LEVEL, format=FORMAT, datefmt=DATEFMT)
logger = logging.getLogger()

abiFile = "../build/contracts/PocketToken.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(IPCProvider(IPC_PATH))
w3.middleware_stack.inject(geth_poa_middleware, layer=0)

contractAddress = w3.toChecksumAddress(TokenContractAddress)
contract = w3.eth.contract(address=contractAddress, abi=abiJson['abi'])

w3.eth.defaultAccount = w3.eth.accounts[0]

def output_transaction_result(fun, txHash):
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    if receipt['status'] == 0:
        logger.info("{}: status={} txHash={}".format(
            fun,
            receipt,
            w3.toHex(txHash),
        ))

def balances(address):
    result = contract.functions.balanceOf(address).call()
    logger.info(result)

if __name__ == '__main__':
    balances(w3.eth.defaultAccount)
