pragma solidity ^0.4.21;

contract Baccarat {
	uint256 seed;
    uint8 constant private CARD_TOTAL = 52;
	//mapping(uint256 => Card[]) private cards; 

    event Deal(
		uint256 indexed value, 
		uint256 protocol, 
		uint256 upper,
		uint256 random,
		uint256 index
	);
	
	event Shuffle(
	    uint256 indexed value    
	);
	
	/*
	event Deal_Card(
	    uint8[] banker_cards,
	    uint8[] player_cards,
	    uint8   winner
	);
	*/
	event Test(
	    uint8 value    
	);
	
	event Deal_Card(
	    uint8 card,
	    uint16 card_left
	);
	
	event Random_Num(
	    uint16 num
	);
	
	struct Card {
	    bytes1 status;
		uint256 value;
	}
	
	int8[] x = [int8(10)];
	
	
	mapping(uint256 => uint8[]) private card_list;
/*
	function shuffle(uint256 roomId) internal {
		delete cards[roomId];
		emit Shuffle(roomId);

	    for(uint256 i=0; i<CARD_TOTAL; i++) {
			Card memory card;
			card.status = bytes1(0);
			card.value = i+1;
		    cards[roomId].push(card);	
		}
	}
*/
	
	function shuffle2(uint256 room_id) public returns(bool){
	    delete card_list[room_id];
	    card_list[room_id] = [
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	    
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	    
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	    
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	    
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	    
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	    
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	    
	        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
	        17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	        33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
	        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61
	    ];
	    
	    return true;
	}

	function maxRandom() internal returns (uint256) {
	    seed = uint256(keccak256(
		    seed,
			block.blockhash(block.number - 1),
			now,
			block.coinbase,
			block.difficulty
			
		));
		return seed;
	}

	function random(uint16 upper) internal returns (uint16) {
	    uint256 num = maxRandom();
	    return uint16(num % upper);
	}
/*
	function deal(uint256 roomId) internal returns(uint256) {
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
		
		uint16 upper = uint16(cards[roomId].length);
		uint8 _random = 0;
		while (_random == 0) {
		    _random = random(upper);
		}
        uint8 index = _random - 1;
		card  = cards[roomId][index];
		
		emit Deal(card.value, 2, upper, _random, index);
    
		for(uint256 i=index; i<(upper-1); i++) {
	        cards[roomId][i] = cards[roomId][i+1];
		}
		
		delete cards[roomId][upper-1];
		cards[roomId].length--;

		return card.value; 
	}
*/
    function get_card(uint256 room_id) internal returns(uint8) {
        uint8 card = 0;
        
        if (card_list[room_id].length == 0) {
            return card;
        } else if (card_list[room_id].length == 1) { //avoid infinite loop to get random number
            card = card_list[room_id][0];
            remove_card(room_id, 0);
            return card;
        }
        
        uint16 upper = uint16(card_list[room_id].length);
        uint16 random_num = 0;
        
        while(random_num == 0) {
            random_num = random(upper);
        }
        
        uint16 index = random_num - 1;
        card = card_list[room_id][index];
        
        for(uint16 i=index; i<(upper-1); i++) {
            card_list[room_id][i] = card_list[room_id][i+1];
        }
        
        remove_card(room_id, (upper-1));
        
        return card;
    }
    
    function remove_card(uint256 room_id, uint16 index) private {
        delete card_list[room_id][index];
        card_list[room_id].length--;
    }
    
    function test() public  {
        /*
        for(uint8 i=0; i<1; i++) {
            emit Test(uint8(1));
        }  
        */
        emit Test(uint8(x.length)); //this event not be executed success because of below reason: 
        x.length--; //decrement array's length before delete it's element will raise an exception
        delete x[0];
    }

    function deal_card(uint256 room_id) public returns(uint8){
        uint8[] memory banker_cards = new uint8[](3);
        uint8[] memory player_cards = new uint8[](3);
        uint8 value = get_card(room_id);
        uint16 card_left = uint16(card_list[room_id].length);
        emit Deal_Card(value, card_left);
        return value;
        //for(uint8 i=0; i<2; i++) {
        //    banker_cards[0] = get_card(room_id);
            //player_cards[0] = 11;//get_card(room_id);
        //}
        
        /*
        uint8 need_more_card = need_deal_card_again(banker_cards, player_cards);
        
        if (need_more_card == 1) { //banker need more one card
            banker_cards[2] = get_card(room_id);
            // after assign one card to the banker, detective again
            need_more_card = need_deal_card_again(banker_cards, player_cards);
            if(need_more_card == 2) {
                player_cards[2] = get_card(room_id);
            }
        } else if (need_more_card == 2) { //player need more one card
            player_cards[2] = get_card(room_id);
            // after assign one card to player, detective again
            need_more_card = need_deal_card_again(banker_cards, player_cards);
            if(need_more_card == 1) {
                banker_cards[2] = get_card(room_id);
            }
        }
        uint8 winner = compare_card(banker_cards, player_cards);
        
        emit Deal_Card(banker_cards, player_cards, winner);
        */
    }
    
    function need_deal_card_again(uint8[] banker_cards, uint8[] player_cards) internal pure returns(uint8){
        uint8 banker_cards_length = 0;
        uint8 player_cards_length = 0;
        uint8 banker_point = compute_final_point(banker_cards);
        uint8 player_point = compute_final_point(player_cards);
        uint8 player_last_card = get_last_card(player_cards);
        
        for(uint8 i=0; i<3; i++) {
            if (banker_cards[i] > 0) {
                banker_cards_length += 1;
            }
            if (player_cards[i] > 0) {
                player_cards_length += 1;
            }
        }
        if (banker_cards_length==3 && player_cards_length==3) {
            return 0;
        }
        
        if (
            banker_cards_length == 2 && 
            player_cards_length == 2 && 
            (
                (banker_point >= 8) || (player_point >= 8)
            )
        ) {
            return 0;
        } 
        
        if (
            player_cards_length == 2 && 
            player_point >= 6 &&
            banker_cards_length == 2 && 
            banker_point <= 5 
        ) {
            return 1;
        }
        // player need more one card
        if (
            player_cards_length == 2 &&
            player_point <= 5
        ) {
            return 2;
        }
        
        if (
            player_cards_length == 3 &&
            banker_point <= 2
        ) {
            return 1;
        }
        //banker need more one card
        if (
            player_cards_length == 3 &&
            banker_point == 3 &&
            player_last_card != 8
        ) {
            return 1;
        }
        
        if (
            player_cards_length == 3 &&
            banker_point == 4 && 
            player_last_card >= 2 &&
            player_last_card <= 7
        ) {
            return 1;
        }
        
        if (
            player_cards_length == 3 &&
            banker_point == 5 &&
            player_last_card >= 4 &&
            player_last_card <= 7
        ) {
            return 1;
        }
        
        if (
            player_cards_length == 3 &&
            banker_point == 6 &&
            player_last_card >= 6 &&
            player_last_card <= 7
        ) {
            return 1;
        }
        
        return 0;
    }
    
    function get_last_card(uint8[] memory cards) internal pure returns(uint8) {
        for (uint256 i = cards.length; i<=0; i--) {
            if (cards[i] > 0) {
                return cards[i];
            }
        }
        return 0;
    }
    
    function compute_final_point(uint8[] cards) internal pure returns(uint8) {
        uint8 result = 0;
        for(uint8 i=0; i<cards.length; i++) {
            result += compute_card_point(cards[i]);
        }
        return result%10;
    }
    
    function compute_card_point(uint8 card) internal pure returns(uint8) {
        if ((card & 15) > 9) {
            return 0;
        } 
        return card & 15;
    }
    
    function compare_card(
        uint8[] memory banker_cards, 
        uint8[] memory player_cards
    ) internal pure returns(uint8) {
        uint8 banker_point = compute_final_point(banker_cards);
        uint8 player_point = compute_final_point(player_cards);
        if (banker_point > player_point) { // banker win
           return 1; 
        }
        if (player_point > banker_point) { //player win
            return 2;
        } else { //tie
            return 0;
        }
    }
}
