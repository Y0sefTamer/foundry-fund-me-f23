// SPDX-LICENSE-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    address  USER = makeAddr("user");
    FundMe fundMe;

    function setUp() external {
         //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
         DeployFundMe deployFundMe = new DeployFundMe();
            fundMe = deployFundMe.run();
            vm.deal(USER, 10 ether);
    }

    function testMinimumDollarIsFive() public  {
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }
    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund{value: 0.0001 ether}();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
        uint256 amountFunded = fundMe.addressToAmountFunded(USER);
        assertEq(amountFunded, 1 ether);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
        address funder = fundMe.funders(0);
        assertEq(funder, USER);
    }

    modifier funded {
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
        _;
    }

     function testOnlyOwnerCanWithdraw() public funded{
        

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

     function testWithdrawWithASingleFunder() public funded {

        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {

    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
        // we get hoax from stdcheats
        // prank + deal
        hoax(address(i), 1 ether);
        fundMe.fund{value: 1 ether}();
    }

    uint256 startingFundMeBalance = address(fundMe).balance;
    uint256 startingOwnerBalance = fundMe.i_owner().balance;

    
    vm.startPrank(fundMe.i_owner());
    fundMe.withdraw();
    vm.stopPrank();
   

    assert(address(fundMe).balance == 0);
    assert(startingFundMeBalance + startingOwnerBalance == fundMe.i_owner().balance);
    assert((numberOfFunders + 1) * 1 ether == fundMe.i_owner().balance - startingOwnerBalance);
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {

    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
        // we get hoax from stdcheats
        // prank + deal
        hoax(address(i), 1 ether);
        fundMe.fund{value: 1 ether}();
    }

    uint256 startingFundMeBalance = address(fundMe).balance;
    uint256 startingOwnerBalance = fundMe.i_owner().balance;

    
    vm.startPrank(fundMe.i_owner());
    fundMe.cheaperWithdraw();
    vm.stopPrank();
   

    assert(address(fundMe).balance == 0);
    assert(startingFundMeBalance + startingOwnerBalance == fundMe.i_owner().balance);
    assert((numberOfFunders + 1) * 1 ether == fundMe.i_owner().balance - startingOwnerBalance);
    }

}