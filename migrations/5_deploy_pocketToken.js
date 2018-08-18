var PocketToken = artifacts.require('PocketToken');

module.exports = function(deployer) {
    deployer.deploy(PocketToken);
}
