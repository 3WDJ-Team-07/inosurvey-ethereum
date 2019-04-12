const Migrations = artifacts.require("SurveyCore");

module.exports = function(deployer) {
    deployer.deploy(Migrations);
}
