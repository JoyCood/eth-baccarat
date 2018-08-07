pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Baccarat3.sol";

contract TestBaccarat3 {
    Baccarat3 baccarat = Baccarat3(DeployedAddresses.Baccarat3());

	function test_test() public {
	    uint256 result = baccarat.test();
		Assert.equal(1, result, 'result shoud equal 1');
	}

	function test_shuffle() public {
	    uint256 result = baccarat.shuffle(8, 1);
		Assert.equal(11, result, 'result should be 11');
	}
}
