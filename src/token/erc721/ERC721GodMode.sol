// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.13;

import { ERC721 } from "./ERC721.sol";

/// @title ERC721GodMode
/// @author Andrei Vlad Brg
/// @notice A mock for the ERC721 contract.
contract ERC721GodMode is ERC721 {
    /// EVENTS ///

    event Burn(address indexed owner, uint256 tokenId);

    event Mint(address indexed to, uint256 tokenId);

    /// CONSTRUCTOR ///

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        // solhint-disable-previous-line no-empty-blocks
    }

    /// @dev See the documentation for the function that is called.
    function burn(uint256 tokenId) public virtual {
        burnInternal(tokenId);
    }

    /// @dev See the documentation for the function that is called.
    function mint(address to, uint256 tokenId) public virtual {
        mintInternal(to, tokenId);
    }

    /// @dev See the documentation for the function that is called.
    function safeMint(address to, uint256 tokenId) public virtual {
        safeMintInternal(to, tokenId);
    }

    /// @dev See the documentation for the function that is called.
    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual {
        safeMintInternal(to, tokenId, data);
    }

    /// @dev See the documentation for the function that is overriden.
    function tokenURI(uint256) public pure virtual override returns (string memory) {}
}