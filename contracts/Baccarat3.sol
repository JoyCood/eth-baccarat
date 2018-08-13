pragma solidity 0.4.24;

contract Baccarat3 {
    uint8[][POKERS_NUM] private pokers = [
		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ],

		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ],
		
		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ],
		
		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ],

		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ],

		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ],

		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ],

		[
			0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,
			0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D,
			0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D,
			0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
        ]
	];

	enum Winner {TIE, BANKER, PLAYER, BANKER_PAIR, PLAYER_PAIR}

	uint8 private constant POKERS_NUM = 8;

	mapping(uint256 => uint8[][POKERS_NUM]) public cards;

	event LogWinner(
	    uint8[] bankerCards,
		uint8[] playerCards,
		uint8 bankerPoints,
		uint8 playerPoints,
		Winner winner,
		bool bankerPairs,
		bool playerPairs
	);

	function shuffle(uint256 _roomId) 
	    public 
		returns (bool) 
	{
    	cards[_roomId] = pokers;
		return true;
	}

	//下注
	function bet(Winner _win) 
	    public
		payable
		returns (bool)
	{
        return true;	
	}

	//开牌
	function dealCard(uint256 _roomId) 
	    public 
	{
		uint8[] memory local_bankerCards = new uint8[](3);
		uint8[] memory local_playerCards = new uint8[](3);

		for (uint256 i=0; i<2; i++) {
			local_bankerCards[i] = getCard(_roomId); 
			local_playerCards[i] = getCard(_roomId);
		}

	    bool need = playerNeedMore(local_playerCards);
		if (need) { //闲家需要博牌
		    local_playerCards[2] = getCard(_roomId);
		}

		need = bankerNeedMore(local_playerCards, local_bankerCards);
		if (need) { //庄家需要博牌
		    local_bankerCards[2] = getCard(_roomId);
		}

		Winner local_winner = detectWinner(local_bankerCards, local_playerCards);
		bool local_bankerPair = isPair(local_bankerCards);
		bool local_playerPair = isPair(local_playerCards);

		emit LogWinner(
		    local_bankerCards,
			local_playerCards,
			points(local_bankerCards),
			points(local_playerCards),
			local_winner,
			local_bankerPair,
			local_playerPair
		);
	}
    
	//闲家是否需要博牌
	function playerNeedMore(uint8[] _cards)
	    private
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
	    private
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

		if (local_bankerPoints == 4 && local_playerLastCardPoint <= 1 || local_playerLastCardPoint >= 8) {
		    return false;
		}

		if (local_bankerPoints == 5 && local_playerLastCardPoint <= 3 || local_playerLastCardPoint >= 8) {
		    return false;
		}

		if (local_bankerPoints == 6 && (local_playerLastCardPoint < 6 || local_playerLastCardPoint > 7)) {
		    return false;
		}

		return true;
	}

	//判断是否为对子
	function isPair(uint8[] _cards) 
	    private
		pure
		returns (bool)
	{
        uint256 local_length = cardsLength(_cards);
		if (local_length >= 2) {
	        return (_cards[0] & 0x0F) == (_cards[1] & 0x0F);	
		}

		return false;
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

	//获取一手牌的点数
	function points(uint8[] _cards)
	    private
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
    
	//获取单张牌的点数
	function points(uint8 _card)
	    private
		pure
		returns (uint8) 
	{
        return ((_card & 0x0F) > 0x09) ? 0 : (_card & 0x0F);	
	}

	//检测胜出玩家
	function detectWinner(uint8[] _bankerCards, uint8[] _playerCards)
	    private
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
    
	//随机抽取一张牌
	function getCard(uint256 _roomId) 
	    private 
		returns(uint8) 
	{
		uint8 local_card;
        uint256 local_pokersNum;
	    
	    local_pokersNum = getPokersNum(_roomId);	

        if (cards[_roomId][local_pokersNum].length == 1) {
		    local_card = cards[_roomId][local_pokersNum][0];
			removeCard(_roomId, local_pokersNum, 0);
			return local_card;
		}

		uint256 local_upper = cards[_roomId][local_pokersNum].length;
		uint256 local_randomNum = 0;
		uint256 local_seed = 0;

		while (local_randomNum == 0) {
	        local_randomNum = random(local_upper, local_seed);	
			local_seed += 1;
		}
        
        uint256 local_index = local_randomNum - 1;
        uint256 local_maxLoop = local_upper - 1;		

		local_card = cards[_roomId][local_pokersNum][local_index];
        //将后面的牌往前移
		for (uint256 i=local_index; i<local_maxLoop; i++) {
	        cards[_roomId][local_pokersNum][i] = cards[_roomId][local_pokersNum][i+1];	
		}
        removeCard(_roomId, local_pokersNum, local_maxLoop);
		return local_card;
	}

	//从数组中删除已抽出的牌
    function removeCard(uint256 _roomId, uint256 _pokersNum, uint256 _index) 
	    private
		returns (bool)
	{
        delete cards[_roomId][_pokersNum][_index];	
		cards[_roomId][_pokersNum].length--;

		return true;
	}

	//随机选取一副牌
	function getPokersNum(uint256 _roomId) 
	    private 
		returns (uint256) 
	{
        uint256[] memory local_pokers = new uint256[](POKERS_NUM);
        uint256 local_index = 0;

        for (uint256 i=0; i<POKERS_NUM; i++) {
	        if (cards[_roomId][i].length != 0) {
        	    local_pokers[local_index] = i;
				local_index += 1;
			}	
		}        
		if (local_index == 0) {
			shuffle(_roomId);
			local_index = POKERS_NUM;
		}
		uint256 local_key;
		if (local_index==1) {
		    local_key = 0;
		} else {
		   	local_key = random(local_index-1, 0);
		}
        
		return local_pokers[local_key];
	}

	//产生一个随机数
	function random(uint256 _upper, uint256 _seed)
	    private
		view
        returns (uint256 local_num)
	{
		bytes memory local_randSeed = abi.encodePacked(
			blockhash(block.number - 1),
			now,
			block.coinbase,
			block.difficulty,
			_seed
		);
        uint256 seed = uint256(keccak256(local_randSeed));    	
		local_num = (seed % _upper);
	}
}
