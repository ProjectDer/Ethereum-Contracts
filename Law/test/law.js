const Law = artifacts.require("Law");

contract("Law Test", async accounts => {
    it("should set the creator as boss", async () => {
        let l = await Law.deployed();
        let b = await l.testBoss();
        assert.equal(b.valueOf(), true);
    });
    it("should accept a new member from boss", async () => {
        let l = await Law.deployed();
        l.addMember(accounts[1]);
        let c = await l.returnMemberCount();
        assert.equal(c.valueOf(), 2);
    });
    it("should delete a member from boss", async () => {
        let l = await Law.deployed();
        l.addMember(accounts[1]);
        let c = await l.returnMemberCount();
        assert.equal(c.valueOf(), 2);
        l.removeMember(accounts[1]);
        c = await l.returnMemberCount();
        assert.equal(c.valueOf(), 1);
    });
    /*
    it("should accept a new proposal", async () => {
        let l = await Law.deployed();
        l.createProposal("First", "testing proposal");
        let c = await l.returnProposalCount();
        assert.equal(c.valueOf(), 1);
    })
    it("should allow clearing of a proposal", async () => {
        let l = await Law.deployed();
        l.createProposal("First", "testing proposal");
        let c = await l.returnProposalCount();
        assert.equal(c.valueOf(), 1);
        l.cancelProposal(0);
        c = await l.returnProposalCount();
        assert.equal(c.valueOf(), 0);
    })
    */
});