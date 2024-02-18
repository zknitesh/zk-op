// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubmitPoll {
    mapping(address => uint256) private sAddressAmountFundedMap;

    // Later make this a payable method, such that only deployer can register for free
    function registerPoll() public {}
}
