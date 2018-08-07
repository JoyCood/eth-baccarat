pragma solidity ^0.4.21;

contract Baccarat {
	address private owner;
	uint256 seed;
	uint256 private random_counter = 0;

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
	
	event Deal_Card(
	    uint8 card,
	    uint16 card_left
	);
	
	event Random_Num(
	    uint16 index,
		uint16 upper,
		uint256 num,
		uint256 counter,
		uint256 _counter
	);

	event Hash_String(bytes hash_string);
    
	mapping(uint256 => uint8[]) private card_list;

	modifier onlyOwner() {
	    require(owner == msg.sender);
		_;
	}

	constructor() public {
	    owner = msg.sender;
	}

    /**
	 * @dev shuffle card.
	 * @param room_id (string) - game room id.
	 */
	function shuffle(uint256 room_id) public onlyOwner {
		delete card_list[room_id];
        card_list[room_id] = [
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,

			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,

			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,

			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,

			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,

			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,

			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D,

			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
	    ];	
	}

	function maxRandom(uint256 _counter) internal returns (uint256) {
	   bytes memory rand_string = abi.encodePacked(
				seed,
				blockhash(block.number - 1),
				now,
				block.coinbase,
				block.difficulty,
				random_counter,
				_counter
	 	    );

		emit Hash_String(rand_string);

	    seed = uint256(keccak256(rand_string));
        random_counter += 1; 
		return seed;
	}

	function random(uint16 upper, uint256 _counter) internal returns (uint16) {
	    uint256 num = maxRandom(_counter);
	    uint16 x = uint16(num % upper);
		emit Random_Num(x, upper, num, random_counter, _counter);
		return x;
	}

    function get_card(uint256 room_id, uint256 loop_counter) internal returns(uint8) {
        uint8 card = 0;
        
        if (card_list[room_id].length == 0) {
            return card;
        } else if (card_list[room_id].length == 1) { //avoid infinite loop to get a random number
            card = card_list[room_id][0];
            remove_card(room_id, 0);
            return 10;
        }
        
        uint16 upper = uint16(card_list[room_id].length);
        uint16 random_num = 0;
        while(random_num == 0) {
            random_num = random(upper, loop_counter);
        }
        
        uint16 index = random_num - 1;
        card = card_list[room_id][index];
        //emit Random_Num(random_num); 
        for(uint16 i=index; i<(upper-1); i++) {
			//emit Random_Num(i, upper);
           // card_list[room_id][i] = card_list[room_id][i+1];
        }
        
        remove_card(room_id, (upper-1));
        
        return card;
    }
    
    function remove_card(uint256 room_id, uint16 index) private {
        delete card_list[room_id][index];
        card_list[room_id].length--;
    }

    function deal_card(uint256 room_id) public onlyOwner returns (uint8) {
		/*
        uint8[] memory banker_cards = new uint8[](3);
        uint8[] memory player_cards = new uint8[](3);
        uint8 value = get_card(room_id);
        uint16 card_left = uint16(card_list[room_id].length);
        emit Deal_Card(value, card_left);
	   */
	    uint256 loop_counter = 0; 
        for(uint8 i=0; i<4; i++) {
			loop_counter += 1;
			get_card(room_id, loop_counter);
			/*
			emit Deal_Card(
				get_card(room_id),
			   	uint16(card_list[room_id].length)
			);
		   */
            //banker_cards[i] = get_card(room_id);
            //player_cards[i] = get_card(room_id);
        }
		return 0;
        
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
    
    function need_deal_card_again(uint8[] banker_cards, uint8[] player_cards) 
	    internal 
		pure 
		returns (uint8)
	{
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
    
    function get_last_card(uint8[] memory cards) internal pure returns (uint8) {
        for (uint256 i = cards.length; i<=0; i--) {
            if (cards[i] > 0) {
                return cards[i];
            }
        }
        return 0;
    }
    
    function compute_final_point(uint8[] cards) internal pure returns (uint8) {
        uint8 result = 0;
        for(uint8 i=0; i<cards.length; i++) {
            result += compute_card_point(cards[i]);
        }
        return result%10;
    }
    
    function compute_card_point(uint8 card) internal pure returns (uint8) {
        if ((card & 15) > 9) {
            return 0;
        } 
        return card & 15;
    }
    
    function compare_card(uint8[] memory banker_cards, uint8[] memory player_cards) 
	    internal 
		pure 
		returns (uint8) 
	{
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
