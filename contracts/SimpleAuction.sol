pragma solidity ^0.4.24;

contract SimpleAuction {
  // constructor parameters
  address public beneficiary;
  uint public auctionEnd;

  // current state of the auction
  address public highestBidder;
  uint public highestBid;

  // allowed withdrawals
  mapping(address => uint) pendingReturns;

  // set to true to disallow further changes
  bool ended;

  // events in the system
  event HighestBidIncreased(address bidder, uint amount);
  event AuctionEnded(address winner, uint amount);

  /// Create a simple auction with `_biddingTime`
  /// seconds bidding time on behalf of the
  /// beneficiary address `_beneficiary`.
  constructor(
    address _beneficiary,
    uint _biddingTime
  ) public {
    beneficiary = _beneficiary;
    auctionEnd = now + _biddingTime;
  }

  /// Bid on the auction with the value sent
  /// together with this transaction.
  /// The value will only be refunded if the
  /// auction is not won.
  function bid() public payable{
    require(
      now < auctionEnd,
      "Auction already ended"
    );

    require(
      msg.value > highestBid, 
      "There is already a bid with a higher value."
      );

    if(highestBid != 0){
      pendingReturns[highestBidder] += highestBid;
    }

    highestBidder = msg.sender;
    highestBid = msg.value;

    emit HighestBidIncreased(highestBidder, highestBid);
  }

  /// Withdraw a bid that was overbid.
  function widthraw() public returns (bool) {
    uint amount = pendingReturns[msg.sender];

    if(amount > 0) {
      pendingReturns[msg.sender] = 0;

      if(!(msg.sender.transfer(amount))) {
        pendingReturns[msg.sender] = amount;
        return false;
      }
    }

    return true;
  }

  /// End the auction and send the highest bid
  /// to the beneficiary.
  function endAuction() public {
    // 1. Conditions
    require(
      now > auctionEnd, 
      "Auction still in progress"
      );

    require(
      !ended, 
      "The auction is alreday ended."
    );  

    // 2. Effects
    ended = true;
    emit AuctionEnded(highestBidder, highestBid);

    // 3. Interactions
    beneficiary.transfer(highestBid);
  }
}