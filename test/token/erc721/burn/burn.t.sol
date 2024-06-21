// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__Burn is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotBurn__NonExistentTokenId() external {
        uint256 nonExistentTokenId = 1;
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__InvalidTokenId.selector, nonExistentTokenId));
        nft.burn(nonExistentTokenId);
    }

    modifier TokenIdExists() {
        _;
    }

    /// @dev it should burn the token id.
    function testBurn() external TokenIdExists {
        nft.burn(TOKEN_ID);

        uint256 actualBalance = nft.balanceOf(users.owner);
        uint256 expectedBalance = 0;

        assertEq(actualBalance, expectedBalance);

        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__InvalidTokenId.selector, TOKEN_ID));
        nft.ownerOf(TOKEN_ID);
    }

    /// @dev it should emit a Transfer event.
    function testBurn__Event() external TokenIdExists {
        vm.expectEmit(true, true, false, true);
        emit Transfer(users.owner, address(0), TOKEN_ID);
        nft.burn(TOKEN_ID);
    }

    /// @dev it should burn the token id.
    function testBurn(address to, uint256 tokenId) external TokenIdExists {
        vm.assume(to != address(0) && to != users.owner);
        vm.assume(tokenId != TOKEN_ID);

        nft.mint(to, tokenId);
        uint256 actualBalance = nft.balanceOf(to);
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = to;
        assertEq(actualOwner, expectedOwner);

        nft.burn(tokenId);

        actualBalance = nft.balanceOf(to);
        expectedBalance = 0;
        assertEq(actualBalance, expectedBalance);

        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__InvalidTokenId.selector, tokenId));
        nft.ownerOf(tokenId);
    }
}
