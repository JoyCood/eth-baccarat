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
	  development: {
	    host: '127.0.0.1',
		port: 8545,
		network_id: "2018",
		//gas: 4700000,
		//gasPrice: 99999999,
		from: "0x14CD5c014C56cd8464f871b0955Aa3B23EB78B5a"
	  }
	}
};
