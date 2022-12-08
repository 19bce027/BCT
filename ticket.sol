pragma solidity ^0.4.11;

contract Tickets {
    struct Ticket {
        bool paidFor;
        address owner;
    }

    mapping(bytes32 => Ticket) public tickets;
    mapping(address => uint256) public pendingTransactions;
    bool public releaseEther;
    uint256 public ticketPrice;
    address public venueOwner;
    string public name;
    event TicketKey(bytes32 ticketKey);
    event CanPurchase(bool canPurchase);
    event PaidFor(bool paid);

    modifier onlyOwner() {
        require(msg.sender == venueOwner);
        _;
    }

    modifier notOwner() {
        require(msg.sender != venueOwner);
        _;
    }

    modifier releaseTrue() {
        require(releaseEther);
        _;
    }

    function Tickets(uint256 price, string title) {
        ticketPrice = price;
        name = title;
        venueOwner = msg.sender;
        releaseEther = false;
    }

    function() {
        releaseEther = false;
    }

    function allowPurchase() onlyOwner {
        releaseEther = true;
        CanPurchase(releaseEther);
    }

    function lockPurchase() onlyOwner {
        releaseEther = false;
        CanPurchase(releaseEther);
    }

    function createTicket() payable notOwner {
        if (msg.value == ticketPrice) {
            pendingTransactions[msg.sender] = msg.value;
            bytes32 hash = sha3(msg.sender);
            tickets[hash] = Ticket(false, msg.sender);
            TicketKey(hash);
        }
    }

    function unlockEther(bytes32 hash) releaseTrue notOwner {
        uint256 amount = pendingTransactions[msg.sender];
        pendingTransactions[msg.sender] = 0;
        venueOwner.transfer(amount);
        tickets[hash].paidFor = true;
        PaidFor(true);
    }

    function checkPaidFor(bytes32 hash) constant returns (bool) {
        return tickets[hash].owner == msg.sender;
    }

    function getTransaction() constant returns (uint256) {
        return pendingTransactions[msg.sender];
    }

    function getOwner(bytes32 hash) constant returns (address) {
        return tickets[hash].owner;
    }

    function getPaidFor(bytes32 hash) constant returns (bool) {
        return tickets[hash].paidFor;
    }

    function getTicketPrice() constant returns (uint256) {
        return ticketPrice;
    }

    function getOwnerAddress() constant onlyOwner returns (address) {
        return venueOwner;
    }

    function getEventName() constant returns (string) {
        return name;
    }
}