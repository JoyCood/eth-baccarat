pragma solidity 0.4.24;

import "./Basic2.sol";

contract Debug is Basic2 {

	event LogDebugPlayerNeed(
		uint8[] cards,
		uint8   points,
        bool    need
	);

	event LogDebugBankerNeed(
        uint8[] playerCards,
	    uint8[] bankerCards,	
		uint8   playerLastCardPoints,
		uint8   bankerPoints,
		bool    need
	);

	event LogDebugIsPairs(
        uint8[] cards,
	    bool    pairs	
	);

	//检测闲家是否需要博牌
    function debugPlayeNeed(uint8[] _cards) 
	    internal 
	{
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
	    internal
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
	    internal
	{
        bool local_isPairs = isPair(_cards);	
		emit LogDebugIsPairs(_cards, local_isPairs);
	}
}
