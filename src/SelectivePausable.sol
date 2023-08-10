//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title SelectivePausable
 * @author @uintgroup @curi0n-s
 * @notice pauses contract functions using each function's selector
 * @dev can replace or work in tandem with OpenZeppelin's Pausable.sol
 */

abstract contract SelectivePausable {
    /**
     * @dev Revert with this custom error when array lengths do not match.
     */
    error ArrayLengthMismatch();

    /**
     * @dev Revert with this custom error when a function is called while paused.
     */
    error FunctionIsPaused(bytes4 functionSelector);

    /**
     * @dev Emitted when a functions pause state is changed
     */
    event FunctionIsPausedUpdate(
        address indexed sender,
        bytes4 indexed functionSelector,
        bool indexed isPaused
    );

    /**
     * @dev Indicates whether function is paused: functionId => bool.
     */
    mapping(bytes4 => bool) public functionIsPaused;

    /**
     * @dev Reverts if the function of the function selector in _msgSig() is paused.
     */
    modifier whenNotPausedSelective(bool _pauseAfterCall) {
        if (functionIsPaused[_msgSig()]) {
            revert FunctionIsPaused(_msgSig());
        }
        _;
        functionIsPaused[_msgSig()] = _pauseAfterCall;
    }

    /**
     * @dev Modifies pause state of a single function.
     */
    function _setFunctionIsPaused(
        bytes4 _functionSelector,
        bool _isPaused
    ) internal virtual {
        functionIsPaused[_functionSelector] = _isPaused;
        emit FunctionIsPausedUpdate(_msgSender(), _functionSelector, _isPaused);
    }

    /**
     * @dev Modifies pause state of multiple functions.
     */
    function _batchSetFunctionIsPaused(
        bytes4[] calldata _selectors,
        bool[] calldata _isPaused
    ) internal virtual {
        if (_selectors.length != _isPaused.length) {
            revert ArrayLengthMismatch();
        }

        for (uint256 i = 0; i < _selectors.length; i++) {
            functionIsPaused[_selectors[i]] = _isPaused[i];
            emit FunctionIsPausedUpdate(
                _msgSender(),
                _selectors[i],
                _isPaused[i]
            );
        }
    }

    /**
     * @dev Replaces need to import OpenZeppelin's Context.sol. Returns the msg.sender.
     */
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    /**
     * @dev Returns the msg.sig (function selector).
     */
    function _msgSig() internal view virtual returns (bytes4) {
        return msg.sig;
    }
}
