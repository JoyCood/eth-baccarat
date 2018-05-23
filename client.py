import os, json, time
from web3 import Web3, HTTPProvider

ContractAddress = '0xc4da7fad8b3c07add729eb26b3fa56898ef2a7a0'
abiFile = "build/contracts/Baccarat.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)
w3 = Web3(HTTPProvider('http://localhost:8545'))
dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=dbAddress, abi=abiJson['abi'])
account = w3.eth.accounts[0]
"""
transaction = w3.eth.getTransaction('0x7157dc1b5037683504225c23bc372a50efc9657d94c47788dccd9e15105afc86')
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
print(w3.toHex(txHash))
"""
#begin shuffle
CARD_TOTAL = 52
while True:
    if CARD_TOTAL == 0 or CARD_TOTAL==52:
        contract.functions.shuffle(7).transact({
            'from': account,
            'gas': 3000000
        })        
        CARD_TOTAL = 52;
    #ask contract to get a card
    txHash = contract.functions.deal(7).transact({
        'from': account,
        'gas': 3000000
        })
    receipt = w3.eth.waitForTransactionReceipt(txHash)
    if receipt['status'] == 0:
        print("txHash:{}, status:{}".format(w3.toHex(receipt['transactionHash']), receipt['status']))
    print("CARD_TOTAL:{}".format(CARD_TOTAL))
    print("\n\n")
    #print(contract.events.Deal().processReceipt(receipt))
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
