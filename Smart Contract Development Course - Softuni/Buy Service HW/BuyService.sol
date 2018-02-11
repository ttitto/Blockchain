pragma solidity ^0.4.19;
contract BuyService{
    address owner;
    uint private servicePrice;
    uint private lastPurchaseTime;
    uint private lastOwnerWithdrawTime;
    uint private maxWithdrawAmount;
    
    event Purchase(address indexed from);
    
    function BuyService() public{
        owner = msg.sender;
        servicePrice = 1 ether;
        lastPurchaseTime = 0;
        lastOwnerWithdrawTime = 0;
        maxWithdrawAmount = 5 ether;
    }
    
    modifier AllowPauseBetweenBuys(uint period){
        require(now - lastPurchaseTime >= period);
        _;
    }
    
    modifier AllowOwnerWithdraw(uint period){
        require(msg.sender == owner);
        require(now - lastOwnerWithdrawTime >= period);
        _;
    }
    
    modifier EnoughBalance(uint requestedAmount){
        require(this.balance >= requestedAmount);
        _;
    }
    
    modifier Costs(uint somePrice){
        require(msg.value >=somePrice);
        _;
        if(msg.value > somePrice){
            msg.sender.transfer(msg.value - somePrice);
        }
    }
    
    function() public payable{
        
    }
    
    function getBalance() public view returns(uint){
        return this.balance;
    }
    
    function Buy() public payable AllowPauseBetweenBuys(2 minutes) Costs(servicePrice) {
        this.transfer(servicePrice);
        lastPurchaseTime = now;
        Purchase(msg.sender);
    }
    
    function withdraw(uint requestedAmount) public payable AllowOwnerWithdraw(1 hours) EnoughBalance(requestedAmount*(10**18)){
        requestedAmount = requestedAmount*(10**18);
        if(this.balance >= maxWithdrawAmount && requestedAmount > maxWithdrawAmount){
            owner.transfer(maxWithdrawAmount);
            lastOwnerWithdrawTime = now;
        }
        else if(this.balance >= requestedAmount){
            owner.transfer(requestedAmount);
            lastOwnerWithdrawTime = now;
        }
    }
}