pragma solidity ^0.5.0;

/**

@title Members
@author WG
@notice Members with an address
@dev Currently using 'now' for time
@dev Notice active and deactivated accounts

Notes:

onlyBoss
onlyMember

checkMemberExists(address)
checkMemberIsBoss(address)
addMember(address)
removeMember(address)
returnMemberCount()
returnMemberList()

*/

contract Members {

    event MemberAdded(
        address indexed _new,
        address indexed _from
    );

    event MemberList(
        address[] indexed _list
    );

    struct Member {
        address a;
        bool active;
        uint balance;
    }

    // collection of members
    uint member_count; // continuing ID
    uint member_active; // number of active members
    Member[] members;
    address[] member_temp;
    // main contract admin
    address bossman;

    // - Constructor -
    constructor (address b) public {
        bossman = b;
        Member memory m;
        m.a = bossman;
        m.active = true;
        members.push(m);
        member_count = 1;
        member_active = 1;
    }

    modifier onlyBoss()  {
        require(msg.sender == bossman, "Denied.");
        _;
    }
    modifier onlyMember() {
        int l = -1;
        for (uint i = 0; i<members.length; i++) {
            if (members[i].a == msg.sender) {
                l = int(i);
                i = members.length;
            }
            _;
        }
        require(l >= 0, "You are not a member.");
    }

//    /// @param a: Member address
    function checkMemberExist(address a) public view returns (int) {
        int l = -1;
        for (uint i = 0; i<members.length; i++) {
            if (members[i].a == a) {
                l = int(i);
                i = members.length;
            }
        }
        return l;
    }
    function checkMemberIsBoss(address a) public view onlyMember returns (bool) {
        bool boss = false;
        require(checkMemberExist(a) >= 0, "Given address is not a member.");
        if (a == bossman) boss = true;
        return boss;
    }

// - Public Functions -

    /// @notice Require proposal pass
//    /// @param a: Member address to add
    function addMember(address a) public onlyBoss {
        require(checkMemberExist(a) == -1, "The given address is already a member.");
        Member memory m;
        m.a = a;
        m.active = true;
        members.push(m);
        member_count++;
        member_active++;
        emit MemberAdded(a, msg.sender);
    }
    /// @notice Require proposal pass
//    /// @param a: Member address to remove
    function removeMember(address a) public onlyBoss {
        int l = checkMemberExist(a);
        require(l >= 0, "Given member address is already not a member.");
        require(l != 0, "Can not remove the default member.");
        members[uint(l)].active = false;
        member_active--;
    }
    // Return list of members
    function emitMemberList() public onlyMember {
        delete member_temp;
        for (uint i = 0; i<member_count; i++) {
            member_temp.push(members[i].a);
        }
        emit MemberList(member_temp);
    }
    // Return count of active members
    function returnMemberCount() public view onlyMember returns (uint) {
        return member_active;
    }

// - Tools -
    function kill() public onlyBoss {
        selfdestruct(msg.sender);
    }
}

