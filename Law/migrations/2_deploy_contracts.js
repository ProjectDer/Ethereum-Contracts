
var Members = artifacts.require("./Members.sol");
var Law = artifacts.require("./Law.sol");

module.exports = function(deployer, network, accounts) {
	if (network != "live") {
		deployer.deploy(Members, accounts[0])
			.then(() => Members.deployed())
			.then(() => deployer.deploy(Law, Members.address));
	} else {

	}
}
