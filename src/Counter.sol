// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SelectivePause} from "./SelectivePause.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public whenNotPaused(false) {
        number = newNumber;
    }

    function increment() public whenNotPaused(true) {
        number++;
    }
}
