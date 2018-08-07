import os
import json
import logging
import threading
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
from web3.utils.events import get_event_data
from config import ContractAddress

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

def get_receipt(txHash):
    return w3.eth.waitForTransactionReceipt(txHash)

def output_event_data(receipt):
    logger.info(receipt[0]['args'])
    print('\n')

def get_one_card_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogGetOneCard().processReceipt(receipt)
    output_event_data(receipt)

def get_cards_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogCards().processReceipt(receipt)
    output_event_data(receipt)

def shuffle_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogShuffle().processReceipt(receipt)
    output_event_data(receipt)

def log_loop(event_filter, handler):
    while True:
        for event in event_filter.get_new_entries():
            handler(event)
        time.sleep(2)

if __name__ == '__main__':
    #block_filter = contract.events.LogGetOneCard.createFilter(fromBlock='latest')
    #threading.Thread(target=log_loop, args=(block_filter, get_one_card_event)).start()

    block_filter = contract.events.LogCards.createFilter(fromBlock='latest')
    threading.Thread(target=log_loop, args=(block_filter, get_cards_event)).start()

    block_filter = contract.events.LogShuffle.createFilter(fromBlock='latest')
    threading.Thread(target=log_loop, args=(block_filter, shuffle_event)).start()
