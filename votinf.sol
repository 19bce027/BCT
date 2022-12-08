pragma solidity 0.6.0;

contract VotingSystem{

   //structure to candidate that can be added by owner.
   struct Candidate {
       string name;
       uint voteCount;
   }

   struct Voter {
       bool authorized;
       bool voted;
       uint vote;
   }

   //store address of owner.
   address payable public owner;
   string public electionName;
   mapping(address => Voter) public voters;
   Candidate[] public candidates;
   uint public totalVotes;

   //make modifier so that some changes are made by owner only
   //ex.. addCandidate , authoried , end of election.
   modifier ownerOnly() {
       require(msg.sender == owner , "You are not owner.");
       _; //remaining body of addCandidate to be executed
   }

   //fuction to start new election.
   function Election(string memory name) public {
       //set owner as caller of this function.
       owner = msg.sender;
       electionName = name;
   }

   //addCandidate by only owner.
   function addCandidate(string memory name) ownerOnly public {
       candidates.push(Candidate(name,0));
   }

   //get total number of Candidate.
   function getNumCandidate() public view returns(uint) {
       return candidates.length;
   }

   //authorization of voter by owner only.
   function authorize(address _person) ownerOnly public {
       voters[_person].authorized = true;
   }

function checkWinner() public view returns(string memory){
   uint winnerVote = 0;
   string memory winnerIndex;
   for(uint i=0; i<candidates.length;i++){
           if(winnerVote < candidates[i].voteCount){
           winnerIndex = candidates[i].name;
           winnerVote = candidates[i].voteCount;
           }
   }

return winnerIndex;   
}
   //voting fucntion to give vote on this plateform.
   function vote(uint _voteIndex) public {

       //check if voter allready give vote or not.
       require(!voters[msg.sender].voted , "You allready give your important vote. Not need to vote again !");
      
       //check voter is authorized or not.
       require(voters[msg.sender].authorized , "You are not authorized voter by owner.");

       //increment vote
       voters[msg.sender].vote = _voteIndex;
      
       //set voted variable to true because now this voter gives him/her vote.
       voters[msg.sender].voted = true;

       //add this voter to that election.
       candidates[_voteIndex].voteCount += 1;
       totalVotes += 1;
   }

   //close election by owner only.
   function end() ownerOnly public {
       selfdestruct(owner);
   }
}

