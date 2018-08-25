module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
    solc: {
	  optimizer: {
	    enabled: true,
	    runs: 200
	  }
    },
	networks: {
		/*
	  development: {
	    host: '127.0.0.1',
		port: 8545,
		network_id: "2018",
		gas: 4800000,
		//gasPrice: 99999999,
		//from: "0x14CD5c014C56cd8464f871b0955Aa3B23EB78B5a"
		from: "0x07ca5e2235e3ebd0b6a60de8d6c0df82b11bae0f"
	  },
	  */
	  development: {
	      host: '127.0.0.1',
		  port: 8545,
		  network_id: '2018',
		  gas: 4700000,
		  from: '0x07ca5e2235e3ebd0b6a60de8d6c0df82b11bae0f'
		  //from: '0x627306090abab3a6e1400e9345bc60c78a8bef57'
	  }
	}
};
