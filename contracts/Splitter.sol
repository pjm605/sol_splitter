pragma solidity ^0.4.6;

contract Splitter {
    address     public owner;
    bool        public killed;
    
    mapping (address => uint) balances;
    
    event LogSendToReceivers (address sender, address receiver1, address receiver2, uint amount);
    event LogWithdraw (address withdrawTo, uint amount);

    function Splitter() {
        owner = msg.sender;
    }
    
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier isNotKilled () {
        require (!killed);
        _;
    }
    
    function sendToReceivers(address _receiver1, address _receiver2)
        isNotKilled()
        public
        payable
        returns (bool)
    {
        require(msg.value > 0);
        
        uint splitAmount = msg.value/2;
        
        balances[_receiver1] += splitAmount;
        balances[_receiver2] += splitAmount;
        
        // return any remaining wei from odd value, back for the caller
        if (msg.value % 2 != 0) {
            balances[msg.sender] += 1;
        }

        LogSendToReceivers (msg.sender, _receiver1, _receiver2, splitAmount);
        return true;
    }
    
    function withdraw () 
        public
        payable
        returns (bool)
    {
        require(balances[msg.sender] > 0);
        
        uint amount = balances[msg.sender];
        msg.sender.transfer(amount);
        balances[msg.sender] = 0;
        LogWithdraw(msg.sender, amount);
        return true;
    }
    
    
    
    function killContract()
        isNotKilled()
        isOwner()
    {
        killed = true;
    }
    
    function getBalance(address _address)
        isNotKilled()
        public
        returns (uint)
    {
        return balances[_address];
    }
}