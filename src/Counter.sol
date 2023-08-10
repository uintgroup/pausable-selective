// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SelectivePausable} from "./SelectivePausable.sol";

contract Counter is SelectivePausable {
    uint256 public number;

    function setNumber(
        uint256 newNumber,
        bool pauseAfterCall
    ) public whenNotPausedSelective(pauseAfterCall) {
        number = newNumber;
    }

    function increment(
        bool pauseAfterCall
    ) public whenNotPausedSelective(pauseAfterCall) {
        number++;
    }

    function setIsPaused(bytes4 _functionSelector, bool _isPaused) external {
        _setIsPaused(_functionSelector, _isPaused);
    }
}
