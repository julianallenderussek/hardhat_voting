
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract VotingTokenERC20 {
    string public constant name = "VotingBasic";
    string public constant symbol = "VTK";
    uint public constant electionEnd = 0;
    uint[] public results;
    uint public numCandidates = 0; 

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Vote(address indexed from);

    mapping(address => uint256) balances;
    mapping(address => uint256) votes;
    mapping(uint => uint256) voteCounter;
    mapping(address => mapping (address => uint256)) allowed;

    struct Candidate{
        uint id;
        string name;
        uint votes;
    }

    mapping (uint => Candidate) public candidates;

    uint256 totalSupply_;

    using SafeMath for uint256;
    
    constructor(uint256 total, string[] memory candidateNames) {  
            totalSupply_ = total;
            balances[msg.sender] = totalSupply_;
            for (uint i = 0; i < candidateNames.length; i++) {
                addCandidate(candidateNames[i]);
            }
    }

    function addCandidate (string memory _name) private {
        candidates[numCandidates] = Candidate(numCandidates, _name , 0);
        numCandidates ++;
    }  

    function vote(string memory _nameCandidate) public returns (bool) {
        require(balances[msg.sender] > votes[msg.sender] && balances[msg.sender] != 0);
        if ( votes[msg.sender] < 1 ) {
            for (uint i = 0; i < numCandidates; i++) {
                string memory _name = candidates[i].name;
                if (compare(_name, _nameCandidate)) {
                    ++candidates[i].votes;
                    votes[msg.sender] = 1;
                }
                
            }
            emit Vote(msg.sender);
        }
        return true;
    }

    function totalSupply() public view returns (uint256) {
	    return totalSupply_;
    }

    function getResults() public view returns (uint[] memory) {
        return results;
    }

    function calculateResults() public {
        uint[3] memory newResults;   
        for (uint i = 0 ; i < numCandidates; i++) {
            
        }
        results = newResults;
    }


    function compare(string memory a, string memory b) public pure returns (bool){
        return compareTwoStrings(a, b);
    }

    function compareTwoStrings(string memory s1, string memory s2)  public pure returns (bool) {
      return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));  
    }

    function getCandidates() public view returns (Candidate [] memory) {
        Candidate[] memory id = new Candidate[](numCandidates);
        for (uint i = 0; i < numCandidates; i++) {
            Candidate storage candidate = candidates[i];
            id[i] = candidate;
        }
        return id;
    }
    
    
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function castedVotes(address tokenOwner) public view returns (uint) {
        return votes[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

}

library SafeMath { 
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}
