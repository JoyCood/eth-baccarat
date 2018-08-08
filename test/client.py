import logging
import os
import json
import time
from web3 import (
    IPCProvider,
    Web3,
)
from web3.middleware import (
    geth_poa_middleware,        
)
from config import (
    ContractAddress,
    IPC_PATH,
)

LEVEL = logging.INFO
FORMAT = "[%(levelname)s]: %(asctime)-15s %(message)s"
DATEFMT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(level=LEVEL, format=FORMAT, datefmt=DATEFMT)
logger = logging.getLogger()

abiFile = "../build/contracts/Baccarat3.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(IPCProvider(IPC_PATH))
w3.middleware_stack.inject(geth_poa_middleware, layer=0)

contractAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=contractAddress, abi=abiJson['abi'])

w3.eth.defaultAccount = w3.eth.accounts[0]

TOTAL_CARDS = 104
DEFAULT_ROOM_ID = 8

def output_transaction_result(fun, txHash):
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    if receipt['status'] == 0:
        logger.info("{}: status={} txHash={}".format(
            fun,
            receipt,
            w3.toHex(txHash),
        ))

def shuffle(room_id=DEFAULT_ROOM_ID):
    global TOTAL_CARDS
    TOTAL_CARDS = 416
    txHash = contract.functions.shuffle(room_id).transact({
        'gas': 999999        
    })
    output_transaction_result('shuffle', txHash)

def shuffle_call(room_id=DEFAULT_ROOM_ID):
    result = contract.functions.shuffle(room_id).call()
    logger.info(result)

def deal_card(room_id=DEFAULT_ROOM_ID):
    txHash = contract.functions.dealCard(room_id).transact({
        'gas': 4700000 
    })
    output_transaction_result('deal_card', txHash)

def assign_card():
    global TOTAL_CARDS
    while True:
        if TOTAL_CARDS<2:
            logger.info("card left: {}".format(TOTAL_CARDS))
        if TOTAL_CARDS == 0 or TOTAL_CARDS==416:
            shuffle()
        deal_card()
        TOTAL_CARDS -= 1
        time.sleep(1)

def b3_shuffle(room_id=DEFAULT_ROOM_ID):
    txHash = contract.functions.shuffle(room_id).transact({
        'gas': 4700000
    })
    output_transaction_result('b3_shuffle', txHash)
    result = contract.functions.shuffle(room_id).call()
    logger.info(result)

def b3_dealCard(room_id=DEFAULT_ROOM_ID):
    global TOTAL_CARDS
    while True:
        if TOTAL_CARDS < 1:
            TOTAL_CARDS = 104
            break
        if TOTAL_CARDS == 104:
            logger.info("card leave:{}".format(TOTAL_CARDS))
        txHash = contract.functions.dealCard(room_id).transact({
            'gas': 4700000    
        })
        output_transaction_result('b3_dealCard', txHash)
        TOTAL_CARDS -= 1
        time.sleep(1)
    #result = contract.functions.dealCard(room_id).call()
    #logger.info(result)

if __name__ == '__main__':
    #shuffle_call()
    #assign_card()
    #b3_shuffle()
    b3_dealCard()
