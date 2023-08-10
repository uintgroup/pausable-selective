//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title PausableSelective
 * @author @uintgroup @curi0n-s
 * @notice pauses contract functions using each function's selector
 * @dev can replace or work in tandem with OpenZeppelin's Pausable.sol
 */

abstract contract PausableSelective {
    /**
     * @dev Revert with this custom error when array lengths do not match.
     */
    error PausableSelective_ArrayLengthMismatch();

    /**
     * @dev Revert with this custom error when a function is called while paused.
     */
    error PausableSelective_FunctionIsPaused(bytes4 functionSelector);

    /**
     * @dev Emitted when a functions pause state is changed
     */
    event PausableSelective_FunctionIsPausedUpdate(
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
        if (functionIsPaused[_msgSigPausableSelective()]) {
            revert PausableSelective_FunctionIsPaused(
                _msgSigPausableSelective()
            );
        }
        _;
        functionIsPaused[_msgSigPausableSelective()] = _pauseAfterCall;
    }

    /**
     * @dev Modifies pause state of a single function.
     */
    function _setFunctionIsPaused(
        bytes4 _functionSelector,
        bool _isPaused
    ) internal virtual {
        functionIsPaused[_functionSelector] = _isPaused;
        emit PausableSelective_FunctionIsPausedUpdate(
            _msgSenderPausableSelective(),
            _functionSelector,
            _isPaused
        );
    }

    /**
     * @dev Modifies pause state of multiple functions.
     */
    function _batchSetFunctionIsPaused(
        bytes4[] calldata _selectors,
        bool[] calldata _isPaused
    ) internal virtual {
        if (_selectors.length != _isPaused.length) {
            revert PausableSelective_ArrayLengthMismatch();
        }

        for (uint256 i = 0; i < _selectors.length; i++) {
            functionIsPaused[_selectors[i]] = _isPaused[i];
            emit PausableSelective_FunctionIsPausedUpdate(
                _msgSenderPausableSelective(),
                _selectors[i],
                _isPaused[i]
            );
        }
    }

    /**
     * @dev Replaces need to import OpenZeppelin's Context.sol. Returns the msg.sender.
     */
    function _msgSenderPausableSelective()
        internal
        view
        virtual
        returns (address)
    {
        return msg.sender;
    }

    /**
     * @dev Returns the msg.sig (function selector).
     */
    function _msgSigPausableSelective() internal view virtual returns (bytes4) {
        return msg.sig;
    }
}
