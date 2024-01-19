// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";
import {Bank} from "../src/Bank.sol";

contract BankTest is Test {
    MyToken public token;
    Bank public bank;
    address public admin = address(0x888888);
    address public account1 = address(0x1);
    address public account2 = address(0x2);
    uint total_supply  = 10000;

    function setUp() public {
        vm.startPrank(admin);
        token = new MyToken(total_supply);
        bank = new Bank(address(token));
        token.transfer(account1, 500);
        token.transfer(account2, 500);  //每人500
        vm.stopPrank();
    }

    function deposit(uint value) internal{
        vm.startPrank(account1);
        vm.assume(value < 500 && value >0);
        token.approve(address(bank), value);
        bank.deposit(value);
        vm.stopPrank();
    }

    function withdraw()internal{
        uint pre_bal = address(admin).balance;
        uint bank_bal = address(bank).balance;
        bank.withdraw();
        uint new_bal = address(admin).balance;
        vm.stopPrank();
        assertEq(new_bal , pre_bal+bank_bal);
    }

    function testDeposit(uint value) public {
        deposit(value);
        assertEq(bank.balance(account1),value);
    }

    function testWithdraw(uint value) public {
        vm.assume(value > 0);
        deposit(value);
        console2.logUint(token.balanceOf(address(bank)));
        vm.startPrank(admin);
        withdraw();
    }
}
