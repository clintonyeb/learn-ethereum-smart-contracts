pragma solidity ^0.4.24;

contract Ballot {
  
  struct Voter {
    uint weight;
    bool voted;
    address delegate;
    uint vote;
  }

  struct Proposal {
    bytes32 name;
    uint voteCount;
  }

  address public chairperson;
  mapping (address => Voter) public voters;
  Proposal[] public proposals;

  constructor(bytes32[] proposalNames) public {
    chairperson = msg.sender;
    voters[chairperson].weight = 1;

    for (uint i = 0; i < proposalNames.length; i++) {
      proposals.push(Proposal({
        name: proposalNames[i],
        voteCount: 0
      }));
    }
  }

  function giveRightToVote(address _voter) public {
    Voter storage voter = voters[_voter];

    require(
      msg.sender == chairperson,
      "Only chairperson can give right to vote"
    );

    require(
      voter.weight == 0, 
      "Voter already has right to vote"
    );

    voter.weight = 1;
  }

  function delegate(address to) public {
    
    Voter storage sender = voters[msg.sender];
    
    require(
      !sender.voted, 
      "You already voted"
    );
    require(
      to != msg.sender,
      "You cannot delegate vote to yourself"
    );

    address _delegate = to;

    while(voters[_delegate].delegate != address(0)){
      _delegate = voters[_delegate].delegate;

      require(
        _delegate != msg.sender,
        "Found cycle in delegation"
      );
    }

    sender.voted = true;
    sender.delegate = to;

    Voter storage delegate_ = voters[_delegate];

    if(delegate_.voted) {
      proposals[delegate_.vote].voteCount += sender.weight;
    } else {
      delegate_.weight += sender.weight;
    }
  }

  function vote(uint proposal) public {
    Voter storage sender = voters[msg.sender];
    require(
      !sender.voted, 
      "You already voted."
      );

    sender.voted = true;
    sender.vote = proposal;

    proposals[proposal].voteCount += sender.weight;
  }

  function winningProposal() view public returns (uint winningProposal_) {
    uint winningVoteCount = 0;
    for (uint p = 0; p < proposals.length; p++) {
      if (proposals[p].voteCount > winningVoteCount) {
        winningVoteCount = proposals[p].voteCount;
        winningProposal_ = p;
      }
    }
  }

  function winnerName() public view returns (bytes32 winnerName_) {
    winnerName_ = proposals[winningProposal()].name;
  }

}