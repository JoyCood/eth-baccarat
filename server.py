import os, json
from web3 import Web3, HTTPProvider
import time
from web3.utils.events import get_event_data

ContractAddress = '0x144ded71d8a9898e9ede59a2b9eef86e19cc9676'
abiFile = "build/contracts/Baccarat.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)
w3 = Web3(HTTPProvider('http://localhost:8545'))
dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=dbAddress, abi=abiJson['abi'])
#contract.functions.deal().transact({'from':w3.eth.accounts[0]})
#result = contract.functions.deal().call()
#print(result)

def handle_event(event):
    receipt = w3.eth.getTransactionReceipt(event['transactionHash'])
    receipt = contract.events.Deal().processReceipt(receipt)
    data = receipt[0]['args']
    print(w3.toHex(receipt[0]['transactionHash']))
    print("card value:{}, protocol:{}, upper:{}, random:{}, index:{}".format(data['value'], data['protocol'], data['upper'], data['random'], data['index']))
    print("\n\n")

def log_loop(event_filter, poll_interval):
    while True:
        #print(event_filter.__dict__)
        for event in event_filter.get_new_entries():
            handle_event(event)
        time.sleep(poll_interval)
#block_filter = w3.eth.filter({'fromBlock':'latest', 'address': ContractAddress})
block_filter = contract.events.Deal.createFilter(fromBlock='latest',
        argument_filters={'value':2});
#block_filter = contract.events.Deal();
#print(block_filter)
log_loop(block_filter, 2)

""" AttributeDict({
'transactionHash': HexBytes('0xc8a2e1574c9508ffdf8e8d6618e15a5aa3c8518b152c28a0799b64655b64691c'), 
'transactionIndex': 0, 
'blockHash': HexBytes('0x76e658d52a07fbd24bb7f3614da2b9269f1c74b0ad02502b23c6c5c5559b3ad6'), 
'blockNumber': 155, 
'gasUsed': 28886, 
'cumulativeGasUsed': 28886, 
'contractAddress': None, 
'logs': [AttributeDict({'logIndex': 0, 'transactionIndex': 0, 'transactionHash': HexBytes('0xc8a2e1574c9508ffdf8e8d6618e15a5aa3c8518b152c28a0799b64655b64691c'), 'blockHash': HexBytes('0x76e658d52a07fbd24bb7f3614da2b9269f1c74b0ad02502b23c6c5c5559b3ad6'), 'blockNumber': 155, 'address': '0xDd65C920a296f5Feeca6e92F86fCd641FE41D5c6', 'data': '0x00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000008', 'topics': [HexBytes('0x12da75c33a0f20c57336aa5cfab23d12f632305416f68a813758102a84aa181a')], 'type': 'mined'})], 
'status': 1, 
'logsBloom': HexBytes('0x00000000000000200000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000')})"""
