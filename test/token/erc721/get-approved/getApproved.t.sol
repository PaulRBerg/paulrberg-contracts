// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__GetApproved is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotGetApproved__TokenIdNonExisting() external {
        uint256 nonExistingTokenId = 1;
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__InvalidTokenId.selector, nonExistingTokenId));
        nft.getApproved(nonExistingTokenId);
    }

    modifier TokenIdExists() {
        _;
    }

    /// @dev it should return the correct approved address.
    function testGetApproved() external TokenIdExists {
        address actualApproved = nft.getApproved(TOKEN_ID);
        address expectedApproved = users.chad;

        assertEq(actualApproved, expectedApproved);
    }
}
