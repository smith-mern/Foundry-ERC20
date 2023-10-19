// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address jessica = makeAddr("jessica");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 10000 ether;

        //Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 50;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransfers() public {
        //uint256 initialBalance = ourToken.balanceOf(bob);

        uint256 initialBalanceSender = ourToken.balanceOf(bob);
        uint256 initialBalanceRecipient = ourToken.balanceOf(alice);
        //ourToken.approve(alice, initialBalance);

        uint256 transferAmount = 5;
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        uint256 finalBalanceSender = ourToken.balanceOf(bob);
        uint256 finalBalanceRecipient = ourToken.balanceOf(alice);

        assertEq(finalBalanceSender, initialBalanceSender - transferAmount, "Sender balance should decrease");
        assertEq(finalBalanceRecipient, initialBalanceRecipient + transferAmount, "Recipient balance should increase");
    }

    function testApproveAndAllowance() public {
        address spender = bob;
        uint256 approvalAmount = 500;

        ourToken.approve(spender, approvalAmount);

        uint256 allowance = ourToken.allowance(address(this), spender);

        assertEq(allowance, approvalAmount, "Allowance should be set correctly");
    }

    // function testTransferFrom() public {
    //     uint256 amount = 1000;
    //     address receiver = address(0x1);
    //     vm.prank(msg.sender);
    //     ourToken.approve(address(this), amount);
    //     ourToken.transferFrom(msg.sender, receiver, amount);
    //     assertEq(ourToken.balanceOf(receiver), amount);
    // }
}
