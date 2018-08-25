pragma solidity ^0.4.24;

contract Basic2 {
    uint8[] internal pokers = [
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
	];

	uint8 internal constant POKERS_NUM = 8;
	uint256 internal seed;

	enum Winner {TIE, BANKER, PLAYER, BANKER_PAIRS, PLAYER_PAIRS}
/*	
	event LogWinner(
	    uint8[] bankerCards,
		uint8[] playerCards,
		uint8 bankerPoints,
		uint8 playerPoints,
		Winner winner,
		bool bankerPairs,
		bool playerPairs
	);
*/
	//闲家是否需要博牌
	function playerNeedMore(uint8[] _cards)
	    internal 
		pure
		returns (bool)
	{
        uint256 local_length = cardsLength(_cards);	
		if (local_length > 2) {
		    return false;
		}

		uint8 local_points = points(_cards);
		if (local_points > 5 ) {
		    return false;
		}

		return true; 
	}

	//庄家是否需要博牌
	function bankerNeedMore(uint8[] _playerCards, uint8[] _bankerCards)
	    internal 
		pure
		returns (bool)
	{
        uint256 local_bankerLength = cardsLength(_bankerCards);	
		if (local_bankerLength > 2) { //已发3张牌，无需博牌
		    return false;
		}

		uint8 local_bankerPoints = points(_bankerCards);
		if (local_bankerPoints < 3 ) { //点数<3点，博牌
		    return true;
		}

		if (local_bankerPoints > 6) { //点数>6点，无需博牌
		    return false;
		}
        
		uint256 local_playerLength = cardsLength(_playerCards);
        if (local_playerLength < 3) {
		    return false;
		}
        //闲家最后一张牌的点数
		uint256 local_playerLastCardPoint = points(_playerCards[2]);

		if (local_bankerPoints == 3 && local_playerLastCardPoint == 8) {
		    return false;
		}

		if (local_bankerPoints == 4 && (local_playerLastCardPoint <= 1 || local_playerLastCardPoint >= 8)) {
		    return false;
		}

		if (local_bankerPoints == 5 && (local_playerLastCardPoint <= 3 || local_playerLastCardPoint >= 8)) {
		    return false;
		}

		if (local_bankerPoints == 6 && (local_playerLastCardPoint < 6 || local_playerLastCardPoint > 7)) {
		    return false;
		}

		return true;
	}

	//判断是否为对子
	function isPair(uint8[] _cards) 
	    internal 
		pure
		returns (bool)
	{
        uint256 local_length = cardsLength(_cards);
		if (local_length >= 2) {
	        return (_cards[0] & 0x0F) == (_cards[1] & 0x0F);	
		}

		return false;
	}

	//检测胜出玩家
	function detectWinner(uint8[] _bankerCards, uint8[] _playerCards)
	    internal 
		pure
		returns (Winner)
	{
        uint8 local_bankerPoints = points(_bankerCards);	
		uint8 local_playerPoints = points(_playerCards);

		if (local_bankerPoints > local_playerPoints) {
		   return Winner.BANKER;
		}

		if (local_bankerPoints < local_playerPoints) {
		    return Winner.PLAYER;
		}

		return Winner.TIE;
	}


	//检测手上有几张牌
	function cardsLength(uint8[] _cards) 
	    private
		pure
		returns (uint256 local_length) 
	{
	    for (uint256 i=0; i<_cards.length; i++) {
	        if (_cards[i]>0) {
			    local_length += 1;
			}	
		}
	}

    function points(uint8 _card)
	    internal
		pure
		returns (uint8)
	{
	    return ((_card & 0x0F) > 0x09) ? 0 : (_card & 0x0F);
	}

	//获取一手牌的点数
	function points(uint8[] _cards)
	    internal
		pure
		returns (uint8)
	{
        uint8 local_points = 0;	
		uint256 local_length = cardsLength(_cards);

		for (uint256 i=0; i<local_length; i++) {
			if (_cards[i] > 0) {
		        local_points += points(_cards[i]);    
			}
		}

		return local_points % 0x0A;
	}

	//删除已抽取的牌
	function removeCard(uint8[] storage _cards, uint256 _index)
	    internal
		returns (bool)
	{
        delete _cards[_index];
	    _cards.length--;

	    return true;	
	}


	//产生一个随机数
	function random(uint8 _upper, uint256 _seed)
	    internal
		returns (uint8 local_num)
	{
	    bytes memory local_randSeed = abi.encodePacked(
		    blockhash(block.number - 1),
			now,
			block.coinbase,
			block.difficulty,
			_seed,
			seed
		);
		seed = uint256(keccak256(local_randSeed));
		local_num = uint8(seed % _upper);
	}

}
