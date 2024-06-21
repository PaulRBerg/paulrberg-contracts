// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__Mint is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotMint__ToZeroAddress() external {
        address toZeroAddress = address(0);
        uint256 tokenId = 1;
        vm.expectRevert(IERC721.ERC721__MintZeroAddress.selector);
        nft.mint(toZeroAddress, tokenId);
    }

    modifier ToNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotMint__ExistingToken() external ToNotZeroAddress {
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__MintExistingToken.selector, TOKEN_ID));
        nft.mint(users.to, TOKEN_ID);
    }

    modifier NonExistingToken() {
        _;
    }

    /// @dev it should mint the token.
    function testMint() external ToNotZeroAddress NonExistingToken {
        uint256 actualBalance = nft.balanceOf(users.owner);
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);

        address actualOwner = nft.ownerOf(TOKEN_ID);
        address expectedOwner = users.owner;
        assertEq(actualOwner, expectedOwner);
    }

    /// @dev it should emit a Transfer event.
    function testMint__Event() external ToNotZeroAddress NonExistingToken {
        uint256 tokenId = 1;

        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), users.to, tokenId);
        nft.mint(users.to, tokenId);
    }

    /// @dev it should mint the token.
    function testMint(address to, uint256 tokenId) external ToNotZeroAddress NonExistingToken {
        vm.assume(to != address(0) && to != users.owner);
        vm.assume(tokenId != TOKEN_ID);

        nft.mint(to, tokenId);

        uint256 actualBalance = nft.balanceOf(to);
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = to;
        assertEq(actualOwner, expectedOwner);
    }
}
