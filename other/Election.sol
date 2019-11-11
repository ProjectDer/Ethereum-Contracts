pragma solidity ^0.5.0;

/// @title An Election testing platform
/// @author WG
/// @notice This is for testing only

/** Notes
& proposal -> hearing
& voters -> hearing
& proposal -> law

& candidates -> election
& voters -> election
& candidate -> chair

Members         population of addresses
Votes           member votes
--
Chairs          elected officals (must be members) * levels (1-5)
Bills           articles of legislation
--
Elections           public vote on chair modifications
Proposals       public vote on bill modifications

 */

contract Election {
// - Structures -
    struct Member {
        address a;
        uint power;
        bool offical; // elected offical
    }
    struct Vote {
        address a;
        uint power;
        uint vote;
    }
    // Law
    struct Bill {
        uint id;
        string name;
        string data;
    }
    struct Proposal {
        uint id;
        // start time
        uint duration; // hours
        uint voteCount;
        mapping(address => Vote) votes;
        Bill bill;
        bool complete;
        bool pass;
    }
    // Elected Offical
    struct Candidate {
        address a;
        string name;
        string data;
    }
    struct Chair {
        uint id;
        uint level;
        string name;
        string description;
        address seat; // a
        bool filled;
        // start and end date?
    }
    struct Election {
        uint id;
        string name;
        // start time
        uint duration; // hours
        uint voteCount;
        mapping(address => Vote) votes;
        uint candidate_count;
        Candidate[] candidates;
        Candidate winnder;
    }
// - Variables -
    // main contract admin
    address public bossman;
    // collection of members
    uint member_count;
    Member[] public members;
    // collection of elected officals
    uint chair_count;
    Chair[] public chairs;
    // collection of passed bills
    uint law_count;
    Bill[] public law;
    // proposals
    uint proposal_count;
    Proposal[] public proposals;
    //
    uint bill_count;
    uint election_count;
    uint vote_coutn;
    //
    uint default_duration;
    
// - Constructor -
    constructor () public {
        bossman = msg.sender;

        Member m;
        m.a = bossman;
        m.power = 1;
        m.offical = true;
        members.push(m);

        Chair c;
        c.id = 0;
        c.level = 1;
        c.name = "BossMan";
        c.description = "Master controller";
        c.seat = bossman;
        chairs.push(c);

        member_count = 1;
        chair_count = 1;
        law_count = 0;
        proposal_count = 0;
        bill_count = 0;
        election_count = 0;
        default_duration = 1; // hours
    }

// - Modifiers -
    modifier onlyBoss() {
        // emit message?
        require(msg.sender == bossman);
        _;
    }
    modifier onlyOffical() {
        require(checkMemberOffical(msg.sender) > 0);
        _;
    }
    modifier onlyMember() {
        require(checkMemberExist(msg.sender) > 0);
        _;
    }

// - Functions -
    // Check if the given member exists
    function checkMemberExist(address a) private return (int) {
        int l = -1;
        for (uint i=0; i<members.length(); i++) {
            if (members[i].a == a) {
                l = i;
                i = members.length();
            }
        }
        return l;
    }
    // Check if the given member is an Offical
    function checkMemberOffical(address a) private return (int) {
        int level = -1;
        int l = checkMemberExist(a);
        require(l > 0);
        if (members[l].offical) {
            level = members[l].level;
        }
        return level;
    }
    // Check if the given law exists
    function checkLawExist(uint id) private return (int) {
        int location = -1;
        for (uint i=0; i<law.length(); i++) {
            if (law[i].id == id) {
                location = i;
                i = law.length();
            }
        }
        return location;
    }
    // Check chair exists
    function checkChairExist(uint id) private return (int) {
        int location = -1;
        for (uint i=0; i<chairs.length(); i++) {
            if (chairs[i].id == id) {
                location = i;
                i = chairs.length();
            }
        }
        return location;
    }

    // Add the given bill to law
    // Require proposal pass
    function addLaw(Bill b) private {
        require(checkLawExist(b.id) > 0);
        law.push(b);
    }
    // Remove the given bill id from law
    // Require proposal pass
    function removeLaw(uint id) private {
        require(checkLawExist(id) > 0); // message?
        law.delete(id);
    }
    // Add a member
    // Require proposal pass
    function addMember(address a) private {
        require(checkMemberExist(a) > 0);
        Member m;
        m.a = a;
        m.power = 1;
        m.offical = false;
        members.push(m);
    }
    // Remove a member
    // Require proposal pass
    function removeMember(address a) private {
        int l = checkMemberExist(a);
        require(l>0); // message
        delete members[l];
    }
    // Add chair
    // Require boss
    function addChair(address a, string n, string d) public onlyBoss {
        Chair c;
        c.id = chair_count;
        chair_count++;
        c.name = n;
        c.description = d;
        chairs.push(c);
    }
    // Assign candidate to chair
    // Require election
    function assignChair(uint id, address a) private {
        int l = checkChairExist(id);
        require(l > 0);
        require(chairs[l].filled == false);
        chairs[l].seat = a;
    }
    // Remove elected offical
    // Require proposal
    function clearChair(uint id) private {
        int l = checkChairExist(id);
        require(l > 0);
        chairs[l].seat.delete();
        chairs[l].filled = false;
    }
    // Define bill and create proposal
    // Require member
    function createProposal(string n, uint d) public onlyMember {
        Proposal p;
        p.id = proposal_count;
        propsal_count++;
        // Bill
        Bill b;
        b.id = bill_count;
        bill_count++;
        //
        b.name = n;
        b.data = d;
        p.bill = b;
        // start time
        p.duration = default_duration;
        p.voteCount = 0;
        complete = false;
        pass = false;
    }
    // Run for office
    function runForOffice(uint id) public onlyMember {
        require()
    }
    // Begin the election voting cycle
    // Require elected office? timed?
    function beginElection() public onlyOffical {
        election_count++;
    }
    // Vote on proposal
    function vote(uint cat, uint id, bool pass) public onlyMember {
        // check for only one vote
        if (cat == 0) {
            // Proposal
        } else if (cat == 1) {
            // Election
        } else {
            // error
        }
    }

// - Testing -
    function returnSenderAddress() public returns (address){
        return msg.sender;
    }
/*
    function returnBalance() public {
        return msg.sender.balance();
    }

    function returnInfo() public onlyBoss {

    }

    function 
*/

// - Tools -
// Destroy this contract and return funds
    function kill() public onlyBoss {
        selfdestruct(msg.sender);
    }
}