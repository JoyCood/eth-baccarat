pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Baccarat.sol";

contract TestBaccarat {
    Baccarat baccarat = Baccarat(DeployedAddresses.Baccarat());

	function testInit() public {
        baccarat.init();	
	}

	function deal() public {
	    uint256 cardValue = baccarat.deal();
	}
}
