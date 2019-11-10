pragma solidity ^0.5.0;

//pragma experimental ABIEncoderV2;

import * as M from "./libraries/Members.sol";
import * as L from "./libraries/Laws.sol";
import * as B from "./templates/Basic.sol";

/**

@title Portal
@author WG
@notice The Collection
@dev Contains data and administers global functions

Notes:
*
* add auth
*/

contract Portal is Basic {
// - Variables -
    // members
    address[] public member_list;
    mapping(address => DT.DataTypes.Member) members;
    // chairs
    uint[] public chair_list;
    mapping(uint => DT.DataTypes.Chair) chairs;
    // law
    uint[] public law_list;
    mapping(uint => DT.DataTypes.Law) laws;
    // proposals
    uint[] public proposal_list;
    mapping(uint => DT.DataTypes.Proposal) proposals;
    // other
    uint default_duration; // hearing duration in hours

// - Modifiers -
    modifier onlyBoss()  {
        require(chairs[0].chair == msg.sender, "Master Admin required.");
        _;
    }
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
    modifier onlyMember() {
        bool m = false;
        for (uint i = 0; i<member_list.length; i++) {
            if (member_list[i] == msg.sender) {
                m = true;
                i = member_list.length;
            }
        }
        require(m, "Admin required.");
        _;
    }
// - Constructor -
    constructor (address admin) public {
        // member
        DT.DataTypes.Member memory m = DT.DataTypes.Member(100);
        members[admin] = m;
        member_list.push(admin);
        // chair
        DT.DataTypes.Chair memory c = DT.DataTypes.Chair("Admin", admin);
        chairs[0] = c;
        chair_list.push(0);
    }
// - Private Functions -
// - Public Functions -
    // member
    function setAdmin(address a) internal {
        chairs[0].chair = a;
    }
    function addMember(address a) internal {
        member_list.push(a);
    }
    function removeMember(address[] memory m, address a) internal {
        int l = checkMemberExist(m, a);
        require(l > 0,"The given address is not a member.");
        delete members[member_list[uint(l)]];
        delete member_list[uint(l)];
    }
    // chair
    function addChair(string memory n, address a) internal {
        uint id = chair_list.length;
        chair_list.push(id);
        chairs[id] = DT.DataTypes.Chair(n,a);
    }
    function removeChair(uint id) internal {
        int l = findChair(id);
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
        DT.DataTypes.Bill memory b = DT.DataTypes.Bill(n,d);
        uint id = law_list.length;
        laws[id] = DT.DataTypes.Law(b,now);
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
        Bill memory b = Bill(n,d);
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
    // elections
// - Tools -
// - Testing -
}