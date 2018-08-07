pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Baccarat2.sol";

contract TestBaccarat2 {
    Baccarat2 baccarat = Baccarat2(DeployedAddresses.Baccarat2());

    uint256 roomId = 8;

	function test_shuffle() public {
	    uint256 result = baccarat.shuffle(roomId);
		Assert.equal(1, result, 'result shoud equal 1');
	}
/*
	function test_dealCard() public {
        uint256 result = baccarat.debug_dealCard(roomId);
	    Assert.equal(1, result, 'result shoud equal random number');	
	}
*/
}
