pragma solidity ^0.4.6;

contract Splitter {
    address     public owner;
    address     public receiver1;
    address     public receiver2;
    bool        public killed;
    
    function Splitter(address _receiver1, address _receiver2) {
        owner = msg.sender;
        receiver1 = _receiver1;
        receiver2 = _receiver2;
        killed = false;
    }
    
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier isNotKilled () {
        require (!killed);
        _;
    }

    function sendToReceivers()
        isNotKilled()
        isOwner()
        public
        payable
        returns(bool isSuccess)
    {
        if (msg.value <= 1) revert();
        uint realAmount = msg.value/2;
        if (!receiver1.send(realAmount)) revert();
        
        // for odd amounts, add truncated one to second receiver
        if (realAmount % 2 != 0) {
            realAmount += 1;
        }
        if (!receiver2.send(realAmount)) revert();
        return true;
    }
    
    function killContract()
        isNotKilled()
        isOwner()
    {
        killed = true;
    }
    
    function getOwnerBalance()
        constant
        returns (uint)
    {
        return owner.balance;
    }
    
    function getReceiver1Balance()
        constant
        returns (uint)
    {
        return receiver1.balance;
    }

    function getReceiver2Balance()
        constant
        returns (uint)
    {
        return receiver2.balance;
    }
    
    
}


