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

abiFile = "../build/contracts/Baccarat5.json"
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

def player_need_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogDebugPlayerNeed().processReceipt(receipt)
    output_event_data(receipt)

def banker_need_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogDebugBankerNeed().processReceipt(receipt)
    #output_event_data(receipt)
    if receipt[0]['args']['bankerPoints'] == 6:
        logger.info(receipt[0]['args'])
        print('\n')

def pairs_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogDebugIsPairs().processReceipt(receipt)
    output_event_data(receipt)

def winner_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogWinner().processReceipt(receipt)
    output_event_data(receipt)

def log_loop(event_filter, handler):
    while True:
        for event in event_filter.get_new_entries():
            handler(event)
        time.sleep(2)

if __name__ == '__main__':
    #开牌结果测试
    block_filter = contract.events.LogWinner.createFilter(fromBlock='latest')
    threading.Thread(target=log_loop, args=(block_filter, winner_event)).start()

    #闲家博牌测试
    block_filter = contract.events.LogDebugPlayerNeed.createFilter(fromBlock='latest')
    #threading.Thread(target=log_loop, args=(block_filter, player_need_event)).start()

    #庄家博牌测试
    block_filter = contract.events.LogDebugBankerNeed.createFilter(fromBlock='latest')
    #threading.Thread(target=log_loop, args=(block_filter, banker_need_event)).start()

    #对子测试
    block_filter = contract.events.LogDebugIsPairs.createFilter(fromBlock='latest')
    #threading.Thread(target=log_loop, args=(block_filter, pairs_event)).start()

