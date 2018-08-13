pragma solidity 0.4.24;

import "./Basic.sol";

contract Baccarat4 is Basic {
    mapping(uint256 => uint8[][POKERS_NUM]) private cards;    

	//洗牌
	function shuffle(uint256 _roomId)
	    private
		returns (bool)
   	{
	    cards[_roomId] = pokers;
		return true;
	}

	//开牌
	function dealCard(uint256 _roomId)
	    public
	{
		uint8[] memory local_bankerCards = new uint8[](3);
		uint8[] memory local_playerCards = new uint8[](3);

		for (uint8 i=0; i<2; i++) {
			local_bankerCards[i] = getCard(_roomId); 
			local_playerCards[i] = getCard(_roomId);
		}
        
		//debugPlayeNeed(local_playerCards); //闲家博牌测试
		//debugPairs(local_playerCards); //闲家对子测试

	    bool need = playerNeedMore(local_playerCards);
		if (need) { //闲家需要博牌
		    local_playerCards[2] = getCard(_roomId);
		}

        //debugBankerNeed(local_playerCards, local_bankerCards); //庄家博牌测试
		//debugPairs(local_bankerCards); //庄家对子测试

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

	//随机抽取一张牌
	function getCard(uint256 _roomId) 
	    internal
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

		uint8 local_upper = uint8(cards[_roomId][local_pokersNum].length);
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
	    return super.removeCard(cards[_roomId][_pokersNum], _index);
	}

	//随机选取一副牌
	function getPokersNum(uint256 _roomId) 
	    private 
		returns (uint8) 
	{
	    (uint8[] memory local_pokers, uint8 local_index) = pokersAlive(cards[_roomId]);

		if (local_index == 0) {
			shuffle(_roomId);
			local_index = POKERS_NUM;
		}

		return randomPoker(local_pokers, local_index);
	}

	//检测闲家是否需要博牌
    function debugPlayeNeed(uint8[] _cards) private {
		bool local_need;
		uint8 local_points;

		local_points = points(_cards);
		local_need = playerNeedMore(_cards); 

		emit LogDebugPlayerNeed(
	        _cards,
			local_points,
			local_need
		);
	}

	//检测庄家是否需要博牌
	function debugBankerNeed(uint8[] _playerCards, uint8[] _bankerCards)
	    private
	{
	    bool local_need;
		uint8 local_playerLastCardPoints;
		uint8 local_bankerPoints;

		local_playerLastCardPoints = points(_playerCards[2]); //闲家一手牌的点数 
		local_bankerPoints = points(_bankerCards); //庄家2张牌的点数
        local_need = bankerNeedMore(_playerCards, _bankerCards);
		
		emit LogDebugBankerNeed(
			_playerCards,
		    _bankerCards,
			local_playerLastCardPoints,
			local_bankerPoints,
			local_need
		);
	}

	//检测是否是对子
	function debugPairs(uint8[] _cards)
	    private
	{
        bool local_isPairs = isPair(_cards);	
		emit LogDebugIsPairs(_cards, local_isPairs);
	}
}
