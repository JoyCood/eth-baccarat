pragma solidity 0.4.24;

import "./Basic.sol";

contract Baccarat5 is Basic {
    uint8[][POKERS_NUM] private cards;    

	function shuffle()
	    private
		returns (bool)
   	{
	    cards = pokers;
		return true;
	}

	function dealCard()
	    public
	{
		uint8[] memory local_bankerCards = new uint8[](3);
		uint8[] memory local_playerCards = new uint8[](3);

		for (uint8 i=0; i<2; i++) {
			local_bankerCards[i] = getCard(); 
			local_playerCards[i] = getCard();
		}

	    bool need = playerNeedMore(local_playerCards);
		if (need) { //闲家需要博牌
		    local_playerCards[2] = getCard();
		}

		need = bankerNeedMore(local_playerCards, local_bankerCards);
		if (need) { //庄家需要博牌
		    local_bankerCards[2] = getCard();
		}

		Winner local_winner = detectWinner(local_bankerCards, local_playerCards);
		bool local_bankerPair = isPair(local_bankerCards);
		bool local_playerPair = isPair(local_playerCards);

		if (DEBUG) {
			/*
			emit LogDebugWinner(
				local_bankerCards,
				local_playerCards,
				points(local_bankerCards),
				points(local_playerCards),
				local_winner,
				local_bankerPair,
				local_playerPair
			);
		   */
		} else {
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
	}

	//随机抽取一张牌
	function getCard() 
	    internal
		returns(uint8) 
	{
		uint8 local_card;
        uint256 local_pokersNum;
	    
	    local_pokersNum = getPokersNum();	

        if (cards[local_pokersNum].length == 1) {
		    local_card = cards[local_pokersNum][0];
			removeCard(local_pokersNum, 0);
			return local_card;
		}

		uint8 local_upper = uint8(cards[local_pokersNum].length);
		uint256 local_randomNum = 0;
		uint256 local_seed = 0;

		while (local_randomNum == 0) {
	        local_randomNum = random(local_upper, local_seed);	
			local_seed += 1;
		}
        
        uint256 local_index = local_randomNum - 1;
        uint256 local_maxLoop = local_upper - 1;		

		local_card = cards[local_pokersNum][local_index];
        //将后面的牌往前移
		for (uint256 i=local_index; i<local_maxLoop; i++) {
	        cards[local_pokersNum][i] = cards[local_pokersNum][i+1];	
		}
        removeCard(local_pokersNum, local_maxLoop);
		return local_card;
	}

	//从数组中删除已抽出的牌
    function removeCard(uint256 _pokersNum, uint256 _index) 
	    private
		returns (bool)
	{
	    return super.removeCard(cards[_pokersNum], _index);
	}

	//随机选取一副牌
	function getPokersNum() 
	    private 
		returns (uint8) 
	{
	    (uint8[] memory local_pokers, uint8 local_index) = pokersAlive(cards);

		if (local_index == 0) {
			shuffle();
			local_index = POKERS_NUM;
		}

		return randomPoker(local_pokers, local_index);
	}
}
