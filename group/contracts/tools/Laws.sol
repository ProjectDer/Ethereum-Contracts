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

contract Laws {
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
    event ChairAdded(
        address indexed _from,
        uint indexed _id
    );
    event LawAdded(
        address indexed _from,
        uint indexed _id
    );
    event LawRemoved(
        address indexed _from,
        uint indexed _id
    );
    event ProposalAdded(
        address indexed _from,
        uint indexed _id
    );
    event ProposalRemoved(
        address indexed _from,
        uint indexed _id
    );
// - Modifiers -
    modifier onlyOffical()  {
        bool o = false;
        for (uint i = 0; i<chair_list.length; i++) {
            if (chairs[chair_list[i]].chair == msg.sender) {
                o = true;
                i = chair_list.length;
            }
        }
        require(o, "Admin required.");
        _;
    }
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
// - Variables -
    // chairs
    uint[] public chair_list;
    mapping(uint => Chair) chairs;
    // law
    uint[] public law_list;
    mapping(uint => Law) laws;
    // proposals
    uint[] public proposal_list;
    mapping(uint => Proposal) proposals;
    // other
    uint default_duration; // hearing duration in minutes
// - Constructor -
    constructor () public {
        default_duration = 20;
    }
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
    // chair, law, and proposal lists
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
        emit ProposalAdded(p.creator, id);
        return p;
    }
    function createProT0(uint id, // action: remove
    uint loc, uint dur) internal returns (Proposal memory) {
        Proposal memory p = returnBasicProposal(id, 0, false, dur);
        // Law index to remove
        p.law_loc = loc;
        emit ProposalAdded(p.creator, id);
        return p;
    }
    function createProT1(uint id, // action: add
    address m, uint c, uint dur) internal returns (Proposal memory) {
        Proposal memory p = returnBasicProposal(id, 1, true, dur);
        // Member address and elected Chair index
        p.member = m;
        p.chair_loc = c;
        emit ProposalAdded(p.creator, id);
        return p;
    }
    function createProT1(uint id, // action :remove
    uint c, uint dur) internal returns (Proposal memory) {
        Proposal memory p = returnBasicProposal(id, 1, false, dur);
        // Chair index to remove
        p.chair_loc = c;
        emit ProposalAdded(p.creator, id);
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
    //----------------------------------------------------------------------
    // chair
    function addChair(address a, string memory n) internal {
        uint id = chair_list.length;
        chair_list.push(id);
        chairs[id] = Chair(a,n);
    }
    function removeChair(uint id) internal {
        int l = checkExist(chair_list, id);
        require(l != 0, "Removing the admin at ID:0 is not allowed.");
        require(l > 0, "The given chair ID does not exist.");
        address n;
        require(chairs[chair_list[uint(l)]].chair == n,"The chair is not empty.");
        delete chair_list[uint(l)];
    }
    function appointOffice(uint id, address a) internal {

    }
    function removeOffice(uint id) internal {

    }
    // laws
    function addLaw(string memory n, string memory d) internal {
        Bill memory b = Bill(msg.sender,n,d);
        uint id = law_list.length;
        laws[id] = Law(b,now);
        law_list.push(id);
    }
    function removeLaw(uint id) internal {
        int l = -1;
        for (uint i = 0; i<law_list.length; i++) {
            if (law_list[i] == id) {
                l = int(i);
                i = law_list.length;
            }
        }
        require(l >= 0, "The given law ID does not exist.");
        delete law_list[uint(l)];
    }
    // proposals
    function addProposal(string memory n, string memory d) internal {
        Bill memory b = Bill(msg.sender,n,d);
        uint id = law_list.length;
        laws[id] = Law(b,now);
        law_list.push(id);
    }
    function removeProposal(uint id) internal {
        int l = -1;
        for (uint i = 0; i<law_list.length; i++) {
            if (law_list[i] == id) {
                l = int(i);
                i = law_list.length;
            }
        }
        require(l >= 0, "The given law ID does not exist.");
        delete law_list[uint(l)];
    }
// - Tools -
// - Testing -
}