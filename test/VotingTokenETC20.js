const { expect } = require("chai");

describe("Voting Token contract", async function () {
  let Token, hardhatToken, owner, addr1, addr2, ownerBalance; 

    it("Deployment should assign the total supply of tokens to the owner", async function () {
      const accounts = await ethers.getSigners();
      owner = accounts[0];
      addr1 = accounts[1];
      addr2 = accounts[2];
      Token = await ethers.getContractFactory("VotingTokenERC20");
      hardhatToken = await Token.deploy(5);
      await hardhatToken.deployed();
      console.log(owner.address);
      ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });

    it("Owner can transfer a Voting Token", async function () {
      //await hardhatToken.connect(owner.address).transfer(addr1.address, 1)
      //console.log(await hardhatToken.connect(owner.address));
      
      const prevOwnerBalance = await hardhatToken.balanceOf(owner.address)
      const prevValue = prevOwnerBalance.toNumber();
      
      await hardhatToken.connect(owner).transfer(addr1.address, 1)
      
      const newOwnerBalance = await hardhatToken.balanceOf(owner.address)
      const newValue = newOwnerBalance.toNumber();
      
      expect(prevValue).to.equal(newValue + 1);

    });
});

