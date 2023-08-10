//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title SelectivePausable
 * @author @uintgroup @curi0n-s
 * @notice pauses contract functions using each function's selector
 * @dev replaces OpenZeppelin's Pausable.sol (whenNotPaused would conflict)
 */

abstract contract SelectivePausable {
    // @notice revert with this custom error when array lengths do not match
    error ArrayLengthMismatch();

    // @notice revert with this custom error when a function is called while paused
    error FunctionIsPaused();

    // @notice emitted when a functions pause state is changed
    event FunctionIsPausedUpdate(
        bytes4 indexed functionSelector,
        bool isPaused
    );

    /// @notice function is paused by admins: functionId => bool
    mapping(bytes4 => bool) public functionIsPaused;

    /// @dev reverts if the function of the function selector in msg.sig is paused
    modifier whenNotPaused(bool _pauseAfterCall) {
        if (functionIsPaused[msg.sig]) {
            revert FunctionIsPaused();
        }
        _;
        functionIsPaused[msg.sig] = _pauseAfterCall;
    }

    /// @dev modifies pause state of single function
    function setIsPaused(bytes4 _functionSelector, bool _isPaused) external {
        functionIsPaused[_functionSelector] = _isPaused;
        emit FunctionIsPausedUpdate(_functionSelector, _isPaused);
    }

    /// @dev modifies pause state of multiple functions
    function batchSetFunctionIsPaused(
        bytes4[] calldata _selectors,
        bool[] calldata _isPaused
    ) external {
        if (_selectors.length != _isPaused.length) {
            revert ArrayLengthMismatch();
        }

        for (uint256 i = 0; i < _selectors.length; i++) {
            functionIsPaused[_selectors[i]] = _isPaused[i];
            emit FunctionIsPausedUpdate(_selectors[i], _isPaused[i]);
        }
    }
}
