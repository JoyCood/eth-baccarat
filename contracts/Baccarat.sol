pragma solidity ^0.4.21;

contract Baccarat {
	uint256 _seed;
    uint8 constant private CARD_TOTAL = 52;
	mapping(uint256 => Card[]) private cards; 

    event Deal(
		uint256 indexed value, 
		uint256 protocol, 
		uint256 upper,
		uint256 random,
		uint256 index
	);
	struct Card {
	    bytes1 status;
		uint256 value;
	}

	function shuffle(uint256 roomId) public {
		delete cards[roomId];

	    for(uint256 i=0; i<CARD_TOTAL; i++) {
			Card memory card;
			card.status = bytes1(0);
			card.value = i+1;
		    cards[roomId].push(card);	
		}
	}

	function maxRandom() public returns (uint256 randomNumber) {
	    _seed = uint256(keccak256(
		    _seed,
			block.blockhash(block.number - 1),
			now,
			block.coinbase,
			block.difficulty
			
		));
		return _seed;
	}

	function random(uint256 upper) public returns (uint256 randomNumber) {
	    uint256  num = maxRandom();
	    return num % upper;
	}

	function deal(uint256 roomId) public returns(uint256) {
	    Card memory card;
		if(cards[roomId].length == 0) {
			emit Deal(0, 88, 0, 0, 0);
			return;
		}else if (cards[roomId].length == 1) {
		    card = cards[roomId][0];
		    emit Deal(card.value, 100, 1, 0, 0);
		    delete cards[roomId][0];
		    cards[roomId].length--;
		    return card.value;
		}
		
		uint256 upper = cards[roomId].length;
		uint256 _random = 0;
		while (_random == 0) {
		    _random = random(upper);
		}
        uint256 index = _random - 1;
		card  = cards[roomId][index];
		
		emit Deal(card.value, 2, upper, _random, index);
    
		for(uint256 i=index; i<(upper-1); i++) {
	        cards[roomId][i] = cards[roomId][i+1];
		}
		delete cards[roomId][upper-1];
		cards[roomId].length--;

		return card.value; 
	}

}

