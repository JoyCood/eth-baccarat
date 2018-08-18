pragma solidity ^0.4.24;

import "./openzeppelin/contracts/token/ERC20/StandardToken.sol";

contract PocketToken is StandardToken {
    string public constant name = "PocketToken";
	string public constant symbol = "PT";
	uint8 public constant decimals = 18;

	uint256 public constant INITIAL_SUPPLY = 10000;
    event LogTest(
	    address value
	);
	constructor() public {
	  totalSupply_ = INITIAL_SUPPLY;
	  balances[msg.sender] = INITIAL_SUPPLY;
	  emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
	}

	function test() public {
        emit LogTest(msg.sender);	
	}
}
