var Splitter = artifacts.require("./Splitter.sol");

module.exports = function(deployer) {
  deployer.deploy(Splitter, "0xdd13f75aa319586005259d1523e842f32f788530", "0x8993d567d33fcd5f4d7b9ac18571147c596701f8");
};
