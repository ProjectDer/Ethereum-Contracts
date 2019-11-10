const Member = artifacts.require("Member");

contract("Member Test", async accounts => {
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
});