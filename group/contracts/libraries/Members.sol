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

library Members {
// - Events -
    event MemberList(
        address[] indexed _list
    );
    event MemberAdded(
        address indexed _new,
        address indexed _from
    );
// - Structures -
    struct Member {
        uint balance;
        uint joined;
    }
// - Internal Functions -
    function checkMemberExist(address[] memory m, address a) internal pure returns (int) {
        int l = -1;
        for (uint i = 0; i<m.length; i++) {
            if (m[i] == a) {
                l = int(i);
                i = m.length;
            }
        }
        return l;
    }
    function createMember() internal view returns (Member memory) {
        return Member(1, now);
    }
    function removeMember(address[] memory m, address a) internal pure returns (address[] memory) {
        uint l = uint(checkMemberExist(m, a));
        require (l >= 0, "Given address is not a member");
        delete m[l];
        return m;
    }
}