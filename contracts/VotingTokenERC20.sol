
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract VotingTokenERC20 {
    string public constant name = "VotingBasic";
    string public constant symbol = "VTK";
    uint8 public constant decimals = 18;
    uint public constant electionEnd = 0;
    uint[] public results;
    uint public numCandidates; 
    string[] public candidates;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Vote(address indexed from);

    mapping(address => uint256) balances;
    mapping(address => uint256) votes;
    mapping(string => uint256) voteCounter;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    using SafeMath for uint256;
    
   constructor(uint256 total, string[] memory _candidates) {  
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
        candidates = _candidates;
        numCandidates = _candidates.length;
    }  

    function vote(string memory candidateName) public returns (bool) {
        require(balances[msg.sender] > votes[msg.sender] && balances[msg.sender] != 0);
        if ( votes[msg.sender] < 1 ) {
            votes[msg.sender] = 1;
            voteCounter[candidateName] += 1;
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
        for (uint i = 0 ; i < candidates.length; i++) {
            uint result = voteCounter[candidates[i]];
            newResults[i] = result;
        }
        results = newResults;
    }

    function getCandidates() public view returns (string [] memory) {
	    return candidates;
    }

    function test(uint i) public view returns (string memory) {
	    return candidates[i];
    }

    function test2(uint i) public view returns (uint) {
	    return voteCounter[candidates[i]];
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

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
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