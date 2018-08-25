pragma solidity 0.4.24;

import "./Basic2.sol";
import "./Token.sol";
import "./openzeppelin/contracts/math/SafeMath.sol";

//单机版(无房间概念)
contract Baccarat6 is Basic2 {
	using SafeMath for uint256;

    PocketToken private token;

    uint8[] private cards; //牌列表    
	mapping(uint8 => uint8) private leftover; //每张牌剩余数量

	event LogWinner(
	    uint8[] bankerCards,
		uint8[] playerCards,
		uint8 bankerPoints,
		uint8 playerPoints,
		Winner winner,
		bool bankerPairs,
		bool playerPairs
	);
    
	constructor(PocketToken _token) public {
	    token = _token;
	}

	//下注开牌
    function bet(uint256[5] _values) 
	    external  
	{
        uint256 local_winValue; //赢多少钱	
		uint256 local_loseValue; //输多少钱
		uint8 local_tie = uint8(Winner.TIE); // 和局
		uint8 local_banker = uint8(Winner.BANKER); //庄赢
		uint8 local_player = uint8(Winner.PLAYER); //闲赢
		uint8 local_bPairs = uint8(Winner.BANKER_PAIRS); //庄对子 
		uint8 local_pPairs = uint8(Winner.PLAYER_PAIRS); //闲对子
	
		(uint8 local_winner, bool local_bankerPairs, bool local_playerPairs) = dealCard();

		for (uint8 i=0; i<3; i++) {
		    if (i==local_winner && _values[i]>0 ) { //押对了
				if(local_winner == local_tie) { //和局 //1赔8 + 本金
			        local_winValue = local_winValue.add(_values[i].mul(9)); 
				} else if (local_winner == local_banker) {  //庄赢 2倍 = (本金 + 1赔1)
			        local_winValue = local_winValue.add(_values[i].mul(2));	
				} else if (local_winner == local_player) {  //闲赢 2倍 = (本金 + 1赔1)
				    local_winValue = local_winValue.add(_values[i].mul(2));
				}
			} else if (_values[i] > 0) { //押错了
		        local_loseValue = local_loseValue.add(_values[i]);	
			}
		}

		if (local_bankerPairs && (_values[local_bPairs] > 0) ) {//庄对子 1赔11 + 本金 
		    local_winValue = local_winValue.add(_values[local_bPairs].mul(12));
		} else if (_values[local_bPairs] > 0 ) { //庄没有对子，扣除对应筹码
		    local_loseValue = local_loseValue.add(_values[local_bPairs]);
		}

		if (local_playerPairs && (_values[local_pPairs] > 0) ) {//闲对子 1赔11 + 本金 
		    local_winValue = local_winValue.add(_values[local_pPairs].mul(12));
		} else if (_values[local_pPairs] > 0 ) { //闲没有对子，扣除对应筹码
		    local_loseValue = local_loseValue.add(_values[local_pPairs]);
		}

		if (local_winValue.sub(local_loseValue) > 0) { //赢钱了 
		    token.transfer(msg.sender, local_winValue.sub(local_loseValue));
		} else if (local_loseValue.sub(local_winValue ) > 0) { //输钱了
		    token.transferFrom(msg.sender, address(this), local_loseValue.sub(local_winValue));
		}
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
		returns (uint8)
	{
        uint8 local_card;
		shuffle();

	    if (cards.length == 1) {
		    local_card = cards[0];
			if (subtract(0) == 0) {
			    removeCard(0);
			}
			return local_card;
		}

		uint8 local_upper = uint8(cards.length);
		uint256 local_randomNum = 0;
		uint256 local_seed = 0;

		while (local_randomNum == 0) {
		    local_randomNum = random(local_upper, local_seed);
			local_seed += 1;
		}

		uint256 local_index = local_randomNum - 1;
		uint256 local_maxLoop = local_upper - 1;

		local_card = cards[local_index];
		if (subtract(local_index) == 0) {
		    for (uint256 i=local_index; i<local_maxLoop; i++) {
			    cards[i] = cards[i+1];
			}
			removeCard(cards, local_maxLoop);
		}
		return local_card;
	}

	//洗牌
	function shuffle()
	    private
		returns (bool)
   	{
		if (cards.length == 0) {
			cards = pokers;
			for (uint8 i=0; i<52; i++) {
				uint8 local_card = cards[i];	
				leftover[local_card] = POKERS_NUM;
			}
		}
		return true;
	}

	//记录某张牌剩余数量
	function subtract(uint256 _index)
	    private 
		returns (uint8)
   	{
	   uint8 local_card = cards[_index]; 
	   if (leftover[local_card] - 1 >= 0) {
	       leftover[local_card] -= 1;
	   }
	   return leftover[local_card];
	}

	//从数组中删除已抽出的牌
    function removeCard(uint256 _index) 
	    private
		returns (bool)
	{
	    return super.removeCard(cards, _index);	
	}
}
