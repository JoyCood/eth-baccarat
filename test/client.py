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

abiFile = "../build/contracts/Baccarat6.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(IPCProvider(IPC_PATH))
w3.middleware_stack.inject(geth_poa_middleware, layer=0)

#w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545")) 

contractAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=contractAddress, abi=abiJson['abi'])

w3.eth.defaultAccount = w3.eth.accounts[0]

TOTAL_CARDS = 1
DEFAULT_ROOM_ID = 8

def output_transaction_result(fun, txHash):
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    logger.info(receipt)
    '''
    if receipt['status'] == 0:
        logger.info("{}: status={} txHash={}".format(
            fun,
            receipt,
            w3.toHex(txHash),
        ))
     '''
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
    i = 1
    while True:
        logger.info("deal times: {}".format(i))
        txHash = contract.functions.dealCard(room_id).transact({
            'gas': 4700000    
        })
        output_transaction_result('b3_dealCard', txHash)
        i += 1
        time.sleep(1)
    #result = contract.functions.dealCard(room_id).call()
    #logger.info(result)

def b5_dealCard():
    i = 1
    while True:
        logger.info("deal times: {}".format(i))
        txHash = contract.functions.dealCard().transact({
            'gas': 4700000    
        })
        output_transaction_result('b5_dealCard', txHash)
        i += 1
        time.sleep(1)

def bet():
    txHash = contract.functions.bet().transact({'gas': 4700000})
    output_transaction_result('bet', txHash)

def send_ether_to_account(address):
    transaction = {
        'from': w3.eth.defaultAccount,        
        'to': address,
        'value': 10000000000000000000 #转10个eth到address帐户
    }
    txHash = w3.eth.sendTransaction(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

if __name__ == '__main__':
    #shuffle_call()
    #assign_card()
    #b3_shuffle()
    #b3_dealCard()
    b5_dealCard()
    #bet()

