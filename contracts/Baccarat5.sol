pragma solidity 0.4.24;

import "./Basic.sol";
import "./Token.sol";
import "./openzeppelin/contracts/math/SafeMath.sol";

//单机版(无房间概念)
contract Baccarat5 is Basic {
	using SafeMath for uint256;

    PocketToken public token;

    uint8[][POKERS_NUM] private cards;    

	constructor(PocketToken _token) public {
	    token = _token;
	}

    function bet(uint256[5] _values) 
	  public
	{
        uint256 local_value;	
		uint8 local_tie = uint8(Winner.TIE);
		uint8 local_banker = uint8(Winner.BANKER);
		uint8 local_player = uint8(Winner.PLAYER);
		uint8 local_bPairs = uint8(Winner.BANKER_PAIRS);
		uint8 local_pPairs = uint8(Winner.PLAYER_PAIRS);
	
		(uint8 local_winner, bool local_bankerPairs, bool local_playerPairs) = dealCard();

		//和局
		if (local_winner == local_tie && (_values[local_tie] > 0)) { //1赔8 + 本金 	
			local_value = local_value.add(_values[local_tie].mul(9)); 
		} else if (local_winner == local_banker && (_values[local_banker] > 0)) { //庄赢 2倍 = (本金 + 1赔1)
			local_value = local_value.add(_values[local_banker].mul(2)); 
		} else if (local_winner == local_player && (_values[local_player]) > 0) { //闲赢 2倍 = (本金 + 1赔1)
		    local_value = local_value.add(_values[local_player].mul(2)); 
		}

		if (local_bankerPairs && (_values[local_bPairs] > 0)) { //庄对 1赔11 + 本金 
	        local_value = local_value.add(_values[local_pPairs].mul(12));	
		} 

		if (local_playerPairs && (_values[local_pPairs] > 0)) { //闲对 1赔11 + 本金
		    local_value = local_value.add(_values[local_pPairs].mul(12));
		}
/*
		if (local_value > 0) { 
		    token.transfer(msg.sender, local_value);
		} else if (local_value != 0) {
		    token.transferFrom(msg.sender, address(this), local_value);
		}
	   */
	}

	//洗牌
	function shuffle()
	    private
		returns (bool)
   	{
	    cards = pokers;
		return true;
	}

	//开牌
	function dealCard()
	    public
		returns (uint8, bool, bool)
	{
		uint8[] memory local_bankerCards = new uint8[](3);
		uint8[] memory local_playerCards = new uint8[](3);

		for (uint8 i=0; i<2; i++) {
			local_bankerCards[i] = getCard(); 
			local_playerCards[i] = getCard();
		}
        
		//debugPlayeNeed(local_playerCards); //闲家博牌测试
		//debugPairs(local_playerCards); //闲家对子测试

	    bool need = playerNeedMore(local_playerCards);
		if (need) { //闲家需要博牌
		    local_playerCards[2] = getCard();
		}

        //debugBankerNeed(local_playerCards, local_bankerCards); //庄家博牌测试
		//debugPairs(local_bankerCards); //庄家对子测试

		need = bankerNeedMore(local_playerCards, local_bankerCards);
		if (need) { //庄家需要博牌
		    local_bankerCards[2] = getCard();
		}

		Winner local_winner = detectWinner(local_bankerCards, local_playerCards);
		bool local_bankerPairs = isPair(local_bankerCards);
		bool local_playerPairs = isPair(local_playerCards);
		emit LogWinner(
			local_bankerCards,
			local_playerCards,
			points(local_bankerCards),
			points(local_playerCards),
			local_winner,
			local_bankerPairs,
			local_playerPairs
		);

		return (uint8(local_winner), local_bankerPairs, local_playerPairs);
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
