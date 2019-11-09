pragma solidity ^0.5.0;

import "./Members.sol";

/**

@title An Election testing platform
@author WG

@notice Proposal duration time is in minutes
@dev Currently using 'now' for time

Notes:

* Member        an address
* Vote          member vote
* Bill          articles of legislation
* Proposal      member vote on law modifications
* Law           collection of passed bills

*/

contract Law {

    event ProposalCreated(
        address indexed _from,
        uint indexed _id
    );

// - Structures -

    struct Bill {
        uint id;
        string name;
        string data;
    }
    struct Proposal {
        uint id;
        address creator;
        uint start_time;
        uint duration;
        address[] voters;
        mapping(address => bool) votes;
        Bill bill;
        bool complete;
        bool pass;
    }

// - Variables -
    // members
    Members members;
    // proposals
    uint proposal_count; // continuing ID
    Proposal[] proposals;
    // law
    uint law_count; // continuing ID
    Bill[] law;
    // other
    uint default_duration;

// - Constructor -
    constructor (address memberAddr) public {
        members = Members(memberAddr);

        proposal_count = 0;
        law_count = 0;
        default_duration = 1;
    }

// - Modifiers -

// - Private Functions -

    function checkMember() private view {
        require(members.checkMemberExist(msg.sender) >= 0, "You are not a member.");
    }
    function checkBoss() private view {
        checkMember();
        require(members.checkMemberIsBoss(msg.sender), "You are not a boss.");
    }

    function test() public {
        members.emitMemberList();
    }
/*
//    /// @param id: Proposal ID
    function checkProposalExist(uint id) private view returns (int) {
        int l = -1;
        for (uint i = 0; i<proposals.length; i++) {
            if (proposals[i].id == id) {
                l = int(i);
                i = proposals.length;
            }
        }
        return l;
    }
//    /// @param id: Law ID
    function checkLawExist(uint id) private view returns (int) {
        int l = -1;
        for (uint i = 0; i<law.length; i++) {
            if (law[i].id == id) {
                l = int(i);
                i = law.length;
            }
        }
        return l;
    }
//    /// @param a: The members address
//    /// @param l: The proposals array location
    /// @return False if a vote has not been cast
    function checkVoteCast(address a, uint l) private view returns (bool) {
        bool cast = false;
        uint vote_count = proposals[l].voters.length;
        for (uint i = 0; i<vote_count; i++) {
            if(a == proposals[l].voters[i]) {
                cast = true;
                i = vote_count;
            }
        }
        return cast;
    }
    /// @notice Require proposal pass
//    /// @param b: Bill to add
    function addLaw(Bill storage b) private {
        uint id = law_count;
        law_count++;
        b.id = id;
        law.push(b);
    }
    /// @notice Require proposal pass
//    /// @param  id: Bill ID to remove
    function removeLaw(uint id) private {
        int l = checkLawExist(id);
        require(l >= 0, "The given Bill ID does not exist.");
        delete law[uint(l)];
    }

// - Public Functions -

    /// @notice Require member
    /// @dev Consider adding different proposal actions
//    /// @param n: Bill name
//    /// @param d: Bill description
    function createProposal(string memory n, string memory d) public {
        checkMember();
        Proposal memory p;
        p.id = proposal_count;
        proposal_count++;
        p.creator = msg.sender;
        // Bill
        Bill memory b;
        b.id = p.id;
        b.name = n;
        b.data = d;
        //
        p.bill = b;
        p.start_time = now;
        p.duration = default_duration;
        p.complete = false;
        p.pass = false;
        //
        proposals.push(p);
        emit ProposalCreated(p.creator, p.id);
    }
//    /// @param id: Proposal ID to cancel
    function cancelProposal(uint id) public {
        checkBoss();
        int l = checkProposalExist(id);
        require(l >= 0, "Given Proposal ID is invalid.");
        delete proposals[uint(l)];
    }
    /// @notice pass (true) or fail (false)
//    /// @param id: proposal id
//    /// @param pass: the members vote (true, false)
    function vote(uint id, bool pass) public {
        address a = msg.sender;
        int lm = members.checkMemberExist(a);
        require(lm >= 0, "You are not a member");
        int lp = checkProposalExist(id);
        require(lp >= 0, "Given Proposal ID is invalid.");
        // check if member has voted yet
        require(checkVoteCast(a, uint(lp)), "Your vote has already been cast for this Proposal.");
        // apply vote
        proposals[uint(lp)].votes[a] = pass;
        proposals[uint(lp)].voters.push(a);
    }
    /// @notice onlyBoss
//    /// @param id: proposal id
    function closeProposal(uint id) public {
        checkBoss();
        int l = checkProposalExist(id);
        require(l >= 0, "Given Proposal ID is invalid.");
        // check if end time has been reached
        uint start = proposals[uint(l)].start_time;
        uint duration = proposals[uint(l)].duration * 1 minutes;
        //uint duration = proposals[uint(l)].duration * 1 hours;
        uint end_time = start + duration;
        uint time = now;
        require(time >= end_time, "The Proposal is still in.");
        proposals[uint(l)].complete = true;
        // tally votes
        uint votes_for = 0;
        uint vote_count = proposals[uint(l)].voters.length;
        for (uint i = 0; i<vote_count; i++) {
            address voter = proposals[uint(l)].voters[i];
            if (proposals[uint(l)].votes[voter]) votes_for++;
        }
        // if passed...
        // add to law
        uint score = votes_for / vote_count * 100;
        if (score > 50) {
            proposals[uint(l)].pass = true;
            Bill memory b = proposals[uint(l)].bill;
            law.push(b);
            law_count++;
        }

    }
    // Return list of running proposals
    function returnProposalCount() public view returns (uint) {
        return proposals.length;
    }
    // Return laws
    function returnLawCount() public view returns (uint) {
        return law.length;
    }

// - Testing -
    // /// @return Return senders adress
    function returnSenderAddress() public view returns (address) {
        return msg.sender;
    }
    function returnNow() public view returns (uint) {
        return uint(now);
    }
    function testBoss() public view returns (bool) {
        if (msg.sender == members.bossman) return true;
        return false;
    }
/*
    function returnBalance() public {
        return msg.sender.balance();
    }

    function returnInfo() public onlyBoss {

    }
*/

// - Tools -
    function kill() public {
        //checkBoss();
        selfdestruct(msg.sender);
    }
}