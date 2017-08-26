const Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', (accounts) => {
	var contract; 
	var owner = accounts[0];
	var receiver1 = accounts[1];
	var receiver2 = accounts[2];

	beforeEach (() => {
		return Splitter.new(receiver1, receiver2, {from: owner})
		.then((instance) {
			contract = instance;
		});
	});

	it("odd amount", () => {
		var ownerBal = web3.eth.getBalance(owner);
		var receiver1Bal = web3.eth.getBalance(receiver1);
		var receiver2Bal = web3.eth.getBalance(receiver2);

		return contract.sendToReceivers(receiver1, receiver2, { from: ownder, value: 5 })
			.then((tx) => {
				var ownerAfterBal = web3.eth.getBalance(owner);
				var receiver1AfterBal = web3.eth.getBalance(receiver1);
				var receiver2AfterBal = web3.eth.getBalance(receiver2);

				assert.equal(receiver1Bal.plus(2).toString(10), receiver1AfterBal.toString(10), "Receiver 1 didn't get proper amount of money");
				assert.equal(receiver2Bal.plus(2).toString(10), receiver2AfterBal.toString(10), "Receiver 2 didn't get proper amount of money");
				assert.equal(owner.minus(4).toString(10), ownerAfterBal.toString(10), "Receiver 2 didn't get proper amount of money");
			})
		})
	})

	it("even amount", () => {
		var receiver1Bal = web3.eth.getBalance(receiver1);
		var receiver2Bal = web3.eth.getBalance(receiver2);

		return contract.sendToReceivers(receiver1, receiver2, { from: ownder, value: 10 })
			.then((tx) => {
				var receiver1AfterBal = web3.eth.getBalance(receiver1);
				var receiver2AfterBal = web3.eth.getBalance(receiver2);
				assert.equal(receiver1Bal.plus(5).toString(10), receiver1AfterBal.toString(10), "Receiver 1 didn't get proper amount of money");
				assert.equal(receiver2Bal.plus(5).toString(10), receiver2AfterBal.toString(10), "Receiver 2 didn't get proper amount of money");
			})
	})
})