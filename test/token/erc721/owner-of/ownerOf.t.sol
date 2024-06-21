// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__OwnerOf is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotOwnerOf__NonExistentTokenId() external {
        uint256 nonExistentTokenId = 1;
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__InvalidTokenId.selector, nonExistentTokenId));
        nft.ownerOf(nonExistentTokenId);
    }

    modifier TokenIdExists() {
        _;
    }

    /// @dev it should return the correct owner.
    function testOwnerOf() external TokenIdExists {
        address actualOwner = nft.ownerOf(TOKEN_ID);
        address expectedOwner = users.owner;

        assertEq(actualOwner, expectedOwner);
    }
}
