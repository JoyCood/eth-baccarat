var Baccarat = artifacts.require("Baccarat5");

module.exports = function(deployer) {
    deployer.deploy(Baccarat, '0x8cdaf0cd259887258bc13a92c0a6da92698644c0');
}
