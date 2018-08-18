var Baccarat = artifacts.require("Baccarat5");

module.exports = function(deployer) {
    deployer.deploy(Baccarat, '0x7734aad5b3962eb369a7bc957532af2db1ef5971');
}
