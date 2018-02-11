pragma solidity ^0.4.19;

contract Faucet{
    address owner;
    uint sendAmount;
    event Withdrawal(address indexed recipient, uint withdrawAmount );
    
    function Faucet() public{
        owner = msg.sender;
        sendAmount = 1 ether;
    }
    
    modifier OnlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    modifier EnoughBalance(uint balanceToWithdraw){
        require(this.balance >= balanceToWithdraw);
        _;
    }
    
    function() public payable{
        
    }
    
    function getBalance() public view returns(uint){
        return this.balance;
    }
    
    function changeSendAmount(uint newSendAmountInEther) public OnlyOwner{
        sendAmount = newSendAmountInEther*(10**18) ;
    }
    
    function withdraw() public {
       _transfer(this, sendAmount);
       Withdrawal(this, sendAmount);
    }
    
    function sendTo(address recipient) public {
        _transfer(recipient, sendAmount);
        Withdrawal(recipient, sendAmount);
    }
    
    function withdraw(uint amountInEther) public OnlyOwner{
        uint amount = amountInEther*(10**18);
        _transfer(owner, amount);
        Withdrawal(owner, amount);
    }
    
    function destroy() public OnlyOwner{
        selfdestruct(owner);
    }
    
    function _transfer(address recipient, uint amount) private EnoughBalance(amount){
        recipient.transfer(amount);
    }
}