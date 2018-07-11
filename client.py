import logging
import os
import json
import time
from web3 import Web3, HTTPProvider

LEVEL = logging.ERROR
FORMAT = "[%(levelname)s]: %(asctime)-15s %(message)s"
DATEFMT = '%Y-%m-d %H:%M:%S'
logging.basicConfig(level=LEVEL, format=FORMAT, datefmt=DATEFMT)
logger = logging.getLogger()

ContractAddress = '0xd2fc6396a9ad8f922f9913f20319875d1e027679'
abiFile = "build/contracts/Baccarat.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)
w3 = Web3(HTTPProvider('http://localhost:8545'))
dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=dbAddress, abi=abiJson['abi'])
account = w3.eth.accounts[0]

def test():
    txHash = contract.functions.test().transact({
        'from': account,
        'gas': 3000000
    })
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    print(receipt)

#------------------------
def retry_send_transact(txHash):
    transaction = w3.eth.getTransaction(txHash)
    print(transaction['nonce'])
    transaction = {
            "from": transaction['from'],
            "to": transaction['to'],
            "gas": transaction['gas'],
            "gasPrice": transaction['gasPrice'],
            "value": transaction['value'],
            "data": transaction['input'],
            #"nonce": transaction['nonce']
    }
    txHash = w3.eth.sendTransaction(transaction)
    logger.info(w3.toHex(txHash))

#------------------------------

#洗牌
def shuffle(room_id):
    txHash = contract.functions.shuffle2(room_id).transact({
                 'from': account,
                 'gas': 3000000
             })
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    if receipt['status'] == 0:
        logger.error("shuffle failed,txHash: {}".format(
            w3.toHex(receipt['transactionHash'])
        ))
    else:
        logger.info("shuffle success,txHash: {}".format(
            w3.toHex(receipt['transactionHash'])
        ))

#发牌
def deal_card(room_id):
    txHash = contract.functions.deal_card(room_id).transact({
                 'from': account,
                 'gas': 3000000
             })
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    if receipt['status'] == 0:
        logger.error("deal card failed,txHash: {}".format(
            w3.toHex(receipt['transactionHash'])
        ))
    else:
        logger.info("deal card success,txHash: {}".format(
            w3.toHex(receipt['transactionHash'])
        ))

#begin shuffle
CARD_TOTAL = 416
ROOM_ID = 7
while True:
    if CARD_TOTAL == 0 or CARD_TOTAL==416:
        shuffle(ROOM_ID)
        CARD_TOTAL = 416;
    deal_card(ROOM_ID)
    CARD_TOTAL = CARD_TOTAL - 1
    time.sleep(1)

#res = contract.functions.deal(1).call()#transact({'from':w3.eth.accounts[0]})
#result = contract.functions.deal().call()
#print(result)

#tx_hash = contract.functions.deal().transact({'from':w3.eth.accounts[0]})
#receipt = w3.eth.getTransactionReceipt(tx_hash)
#print(receipt)
#result = contract.events.Deal().processReceipt(receipt)
#print(result)
#result = contract.functions.deal().call()
