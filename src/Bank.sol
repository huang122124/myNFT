// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MyToken.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Bank{
    MyToken public my_token;
    mapping(address=>uint) public balance;
    address public owner;
    using SafeERC20 for IERC20;

    constructor(address token){
        owner = msg.sender;
        my_token = MyToken(token);
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"not owner!!");
        _;
    }

    function tokenReceive(address sender , uint amount) external {
        //实现在转账回调中,将Token 存入 TokenBank
        balance[sender] += amount;
    }

    function deposit(uint value)public{
        require(value <= my_token.allowance(msg.sender, address(this)),"allowance not enough"); //需要先判断用户对于合约地址的授权额度
        my_token.transferWithCallback(address(this),value);
        
    }

    function withdraw()public onlyOwner{
        uint token_balance = my_token.balanceOf(address(this));
        require(0 < token_balance,"No balance");
        my_token.transfer(owner, token_balance);
    }
    
}