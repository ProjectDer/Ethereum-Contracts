pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/**

@title ERC20 Token
@author WG

Notes:
*
*
*/

contract Token {
// - Events -
    event Approval(address indexed tokenOwner,
        address indexed spender, uint tokens);
    event Transfer(address indexed from,
        address indexed to, uint tokens);
// - Structures -
// - Variables -
    string public constant name;
    string public constant symbol;
    string public constant decimals;
    uint public constant total_supply;
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
// - Modifiers -
// - Constructor -
    constructor (uint256 total) public {
        balances[msg.sender] = total;
        total_supply = total;
        name = "A Token";
        symbol = "WG";
        decimals = 8;
    }
// - Private Functions -
// - Public Functions -
    function totalSupply() public view returns (uint256) {
        return total_supply;
    }
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }
    function transfer(address receiver,
        uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender], "Not enough funds.");
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }
// - Tools -
// - Testing -
}