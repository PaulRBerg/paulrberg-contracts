// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IERC20.sol";
import "./IERC20Recover.sol";
import "./SafeERC20.sol";
import "../../access/Ownable.sol";

/// @title ERC20Recover
/// @author Paul Razvan Berg
abstract contract ERC20Recover is
    Ownable, // one dependency
    IERC20Recover // two dependencies
{
    using SafeERC20 for IERC20;

    /// PUBLIC STORAGE ///

    /// @inheritdoc IERC20Recover
    bool public override isTokenDenylistSet;

    /// INTERNAL STORAGE ///

    /// @dev Mapping between unsigned integers and non-recoverable tokens.
    IERC20[] internal tokenDenylist;

    /// PUBLIC CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20Recover
    function getTokenDenylist() external view returns (IERC20[] memory) {
        return tokenDenylist;
    }

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20Recover
    function recover(IERC20 token, uint256 amount) public override onlyOwner {
        // Checks: the token denylist is set.
        if (!isTokenDenylistSet) {
            revert ERC20Recover__TokenDenylistNotSet();
        }

        // Checks: the amount to recover is not zero.
        if (amount == 0) {
            revert ERC20Recover__RecoverAmountZero();
        }

        // Iterate over the non-recoverable token array.
        uint256 length = tokenDenylist.length;
        IERC20 nonRecoverableToken;

        for (uint256 i = 0; i < length; ) {
            // Check that the addresses of the tokens are not the same.
            nonRecoverableToken = tokenDenylist[i];
            if (token == nonRecoverableToken) {
                revert ERC20Recover__RecoverNonRecoverableToken(address(token));
            }

            // Increment the for loop iterator.
            unchecked {
                i += 1;
            }
        }

        // Interactions: recover the tokens by transferring them to the owner.
        token.safeTransfer(owner, amount);

        // Emit an event.
        emit Recover(owner, token, amount);
    }

    /// @inheritdoc IERC20Recover
    function setTokenDenylist(IERC20[] memory tokenDenylist_) public override onlyOwner {
        // Checks: the token denylist is not already set.
        if (isTokenDenylistSet) {
            revert ERC20Recover__TokenDenylistAlreadySet();
        }

        // Iterate over the token list.
        uint256 length = tokenDenylist_.length;
        IERC20 token;
        for (uint256 i = 0; i < length; ) {
            token = tokenDenylist_[i];

            // Sanity check each token contract by calling the `symbol` method.
            token.symbol();

            // Update the mapping.
            tokenDenylist.push(token);

            // Increment the for loop iterator.
            unchecked {
                i += 1;
            }
        }

        // Effects: prevent this function from ever being called again.
        isTokenDenylistSet = true;

        // Emit an event.
        emit SetTokenDenylist(owner, tokenDenylist_);
    }
}
