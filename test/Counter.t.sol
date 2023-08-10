// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0, false);
    }

    function testIncrement() public {
        counter.increment(true);
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x, true);
        assertEq(counter.number(), x);
    }

    /**
     * @dev Tests that counter.increment(bool) can't be called when paused.
     */

    function testPauseIncrementAndTryToCall() public {
        counter.setIsPaused(counter.increment.selector, true);
        uint256 numBefore = counter.number();
        vm.expectRevert();
        counter.increment(true);
        assertEq(counter.number(), numBefore);
    }

    /**
     * @dev Tests that counter.increment(true) will pause the function after the call.
     */
    function testCallAfterPausingAfterCall() public {
        counter.increment(true);
        uint256 numBefore = counter.number();
        vm.expectRevert();
        counter.increment(false);
        assertEq(counter.number(), numBefore);
    }
}
