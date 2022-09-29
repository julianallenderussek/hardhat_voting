const { expect } = require("chai");


const testData = {
  numVotingTokens: 5,
  arrCandidatesNames: ["Salvador Dali", "Pablo Picasso", "Miguel Angel"]
}

describe("Voting Token contract", async function () {
  let Token, hardhatToken, owner, addr1, addr2, ownerBalance, candidates; 

    it("Deployment should assign the total supply of tokens to the owner", async function () {
      const accounts = await ethers.getSigners();
      owner = accounts[0];
      addr1 = accounts[1];
      addr2 = accounts[2];
      Token = await ethers.getContractFactory("VotingTokenERC20");
      hardhatToken = await Token.deploy(
        testData.numVotingTokens, 
        testData.arrCandidatesNames
      );
      await hardhatToken.deployed();
      ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });

    it("Owner can transfer a Voting Token", async function () {
      const prevOwnerBalance = await hardhatToken.balanceOf(owner.address)
      const prevValue = prevOwnerBalance.toNumber();
      
      await hardhatToken.connect(owner).transfer(addr1.address, 1)
      
      const newOwnerBalance = await hardhatToken.balanceOf(owner.address)
      const newValue = newOwnerBalance.toNumber();
      
      expect(prevValue).to.equal(newValue + 1);
    });

    it("AddressOne balance got updated", async function () {
      const newBalance = await hardhatToken.balanceOf(addr1.address)
      const result = newBalance.toNumber();
      expect(result).to.equal(1);
    });

    it("Get Candidates", async function () {
      const candidates = await hardhatToken.getCandidates()
    });

    it("AddressTwo can not vote", async function () {  
      const candidateName = await testData.arrCandidatesNames[0]
      await expect(hardhatToken.connect(addr2).vote(candidateName)).to.be.reverted;
    });

    it("AddressOne has casted 0 votes", async function () {
      const result = await hardhatToken.castedVotes(addr1.address) 
      await expect(result.toNumber()).to.be.equal(0);
    });
    
    it("AddressOne can vote, vote for [0]", async function () {
      const candidateName = await testData.arrCandidatesNames[0]
      await hardhatToken.connect(addr1).vote(candidateName)
      const result = await hardhatToken.castedVotes(addr1.address) 
      await expect(result.toNumber()).to.be.equal(1);
    });

    it("AddressOne has reached his voting limit, tried voting for [0]", async function () {
      const candidateName = await testData.arrCandidatesNames[0]
      await expect(hardhatToken.connect(addr1).vote(candidateName)).to.be.reverted;
    });

    it("Get results", async function () {
      await hardhatToken.calculateResults()
      const result = await hardhatToken.getResults() 
      console.log(result);
    });

    // it("Get results", async function () {
    //   console.log(testData.arrCandidatesNames);
    //   const result = await hardhatToken.test2(0)
    //   console.log(result); 
    //   const result2 = await hardhatToken.test2(1) 
    //   console.log(result2);
    //   const result3 = await hardhatToken.test2(2) 
    //   console.log(result3);
    // });

});

