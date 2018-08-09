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
cards = []
total = 0

right_cards = [       
  0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
  0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
  0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
  0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
]
def check_cards_num():
    global cards
    global right_cards
    for card in right_cards:
        logger.info("{} = {}".format(card, cards.count(card)))

def check_points(args):
    v = 0
    k = 0
    banker_points = 0
    player_points = 0
    equal_banker_points = False
    equal_player_points = False

    for x in args['bankerCards']:
        element = 0 if (x&15) > 9 else (x&15)
        v += element

    banker_points = v%10
    if banker_points == args['bankerPoints']:
        equal_banker_points = True

    for y in args['playerCards']:
        element = 0 if (y&15) > 9 else (y&15)
        k += element
    player_points = k%10
    if player_points == args['playerPoints']:
        equal_player_points = True
    
    if not equal_banker_points or not equal_player_points:
        logger.info("equal_banker_points={} banker_points={}, equal_player_points={} player_points={}".format(
                    equal_banker_points,
                    banker_points, 
                    equal_player_points,
                    player_points
                )
        )
        print("\n")
        
        

def get_receipt(txHash):
    return w3.eth.waitForTransactionReceipt(txHash)

def output_event_data(receipt):
    logger.info(receipt[0]['args'])
    #check_points(receipt[0]['args'])

    '''
    global cards
    cards += receipt[0]['args']['card']
    print(cards)
    logger.info("cards length: {}".format(len(cards)))
    print('\n')
    if len(cards) == 416:
        check_cards_num()
    '''

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

def need_more_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogNeedMore().processReceipt(receipt)
    output_event_data(receipt)

def test_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogTest().processReceipt(receipt)
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

    block_filter = contract.events.LogNeedMore.createFilter(fromBlock='latest')
    threading.Thread(target=log_loop, args=(block_filter, need_more_event)).start()

    block_filter = contract.events.LogTest.createFilter(fromBlock='latest')
    threading.Thread(target=log_loop, args=(block_filter, test_event)).start()
