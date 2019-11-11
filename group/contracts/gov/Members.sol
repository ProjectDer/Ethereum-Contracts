pragma solidity ^0.5.0;

/**

@title Members
@author WG
@notice Member management library

*//* Notes:

variables
---------------------------------
Member[]:   Members
address:    Member
uint/int:   location (-1: DNE)

*/

contract Members {
// - Events -
    event MemberList(
        address[] indexed _list
    );
    event MemberNew(
        address indexed _new,
        address indexed _from
    );
    event MemberLeft(
        address indexed _left
    );
// - Modifiers -
    modifier onlyAdmin()  {
        require(admin == msg.sender, "Admin required.");
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
        require(m, "Member required.");
        _;
    }
// - Structures -
    struct Member {
        uint balance;
        uint joined;
    }
// - Variables -
    address admin;
    address[] public member_list;
    mapping(address => Member) members;
// - Constructor -
    constructor(address _admin) public {
        admin = _admin;
    }
// - Private Functions -
    function createMember() private view returns (Member memory) {
        return Member(0, now);
    }
// - Internal Functions -
    function setAdmin(address _admin) internal onlyAdmin {
        admin = _admin;
    }
    function checkMemberExist(address a) internal view onlyMember returns (int) {
        int l = -1;
        for (uint i = 0; i<member_list.length; i++) {
            if (member_list[i] == a) {
                l = int(i);
                i = member_list.length;
            }
        }
        return l;
    }
    function addMember(address a) internal onlyMember {
        member_list.push(a);
        emit MemberNew(a, msg.sender);
    }
    function removeMember(address a) internal onlyAdmin {
        int l = checkMemberExist(a);
        require(l > 0,"The given address is not a member.");
        delete members[member_list[uint(l)]];
        delete member_list[uint(l)];
        emit MemberLeft(a);
    }
// - Public Functions -
}