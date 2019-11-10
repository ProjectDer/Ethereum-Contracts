
var Basic = artifacts.require("./Basic.sol");
var Members = artifacts.require("./Members.sol");
var Law = artifacts.require("./Law.sol");

module.exports = function(deployer, network, accounts) {
	deployer.deploy(Members, accounts[0]) 
		.then(() => deployer.deploy(Law, Members.address))
		.then(() => Members.deployed())
		.then((instance) => {
			instance.addMember(Law.address)
		});
}
