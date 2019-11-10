pragma solidity ^0.5.0;

/**

@title An Election testing platform
@author WG

@notice Proposal duration time is in minutes

*//* Notes:

outline
-------------------------------------------
Vote          member vote
Bill          articles of legislation
Proposal      member vote on law modifications
Law           collection of passed bills

proposals
-------------------------------------------
0: add/remove bill to/from law
1: add/remove member to/from chair

*/

library Laws {
// - Events -
    event VoteCast(
        address indexed _from,
        uint indexed _id,
        bool indexed _vote
    );
    event ChairModified(
        address indexed _from,
        uint indexed _id
    );
    event LawModified(
        address indexed _from,
        uint indexed _id
    );
    event ProposalCreated(
        address indexed _from,
        uint indexed _id
    );
// - Structures -
    struct Vote {
        address voter;
        bool vote;
        uint time;
    }
    struct Chair {
        address chair;
        string name;
    }
    struct Bill {
        address creator;
        string name;
        string data;
        //uint hashed;  /// !??!
    }
    struct Proposal {
        address creator;
        uint id;
        uint t;         // type (0,1)
        bool action;    // add/remove
        // vote
        uint start_time;
        uint duration;
        address[] voter_list;
        mapping(address => bool) votes;
        bool complete;
        bool pass;
        // t:0: Laws - Bill (add) or uint (remove)
        Bill bill;
        uint law_loc;
        // t:1 Chairs - address (add) or chair_loc (remove)
        address member;
        uint chair_loc;
    }
    struct Law {
        Bill bill;
        uint enacted;
    }
// - Modifiers -
// - Private Functions -
    function returnBasicProposal(uint id, uint t, bool act, uint dur) private view returns (Proposal memory) {
        Proposal memory p;
        p.creator = msg.sender;
        p.id = id;
        p.t = t;
        p.action = act;
        p.start_time = now;
        p.duration = dur;
        p.complete = false;
        p.pass = false;
        return p;
    }
// - Internal Functions -
    // voting
    function checkVoteCast(address[] memory voter_list, address a) internal pure returns (bool) {
        for (uint i = 0; i<voter_list.length; i++) {
            if(a == voter_list[i]) {
                return true;
            }
        } return false;
    }
    /// @return bool: voters vote (checks for previous vote)
    function vote(address[] memory voter_list, bool pass) internal view returns (bool) {
        address a = msg.sender;
        require(checkVoteCast(voter_list, a), "Your vote has already been cast for this Proposal.");
        return pass;
    }
    // chairs, laws, and proposals lists
    /// @return int: -1: DNE, 0+: list index
    function checkExist(uint[] memory list, uint id) internal pure returns (int) {
        int l = -1;
        for (uint i = 0; i<list.length; i++) {
            if (list[i] == id) {
                l = int(i);
                i = list.length;
            }
        }
        return l;
    }
    // create proposal
    function createProT0(uint id, // action: add
    string memory n, string memory d,
    uint dur) internal returns (Proposal memory) {
        Proposal memory p = returnBasicProposal(id, 0, true, dur);
        // Bill to add
        Bill memory b;
        b.creator = msg.sender;
        b.name = n;
        b.data = d;
        p.bill = b;
        emit ProposalCreated(p.creator, id);
        return p;
    }
    function createProT0(uint id, // action: remove
    uint loc, uint dur) internal returns (Proposal memory) {
        Proposal memory p = returnBasicProposal(id, 0, false, dur);
        // Law index to remove
        p.law_loc = loc;
        emit ProposalCreated(p.creator, id);
        return p;
    }
    function createProT1(uint id, // action: add
    address m, uint c, uint dur) internal returns (Proposal memory) {
        Proposal memory p = returnBasicProposal(id, 1, true, dur);
        // Member address and elected Chair index
        p.member = m;
        p.chair_loc = c;
        emit ProposalCreated(p.creator, id);
        return p;
    }
    function createProT1(uint id, // action :remove
    uint c, uint dur) internal returns (Proposal memory) {
        Proposal memory p = returnBasicProposal(id, 1, false, dur);
        // Chair index to remove
        p.chair_loc = c;
        emit ProposalCreated(p.creator, id);
        return p;
    }
    // ----
    function closeProposal(Proposal memory p) internal view returns (bool) {
        // check if end time has been reached
        uint end_time = p.start_time + p.duration * 1 minutes;
        require(now >= end_time, "The Proposal is still in.");
        p.complete = true;
        // tally votes
        uint votes_for = 0;
        uint vote_count = p.voter_list.length;
        for (uint i = 0; i<vote_count; i++) {
            //p.votes[p.voter_list[i]];
            if (true) votes_for++;
        }
        // check if passed
        uint score = (votes_for / vote_count * 100);
        if (score > 50) {
            p.pass = true;
        }
        return p.pass;
    }
// - Tools -
// - Testing -
}