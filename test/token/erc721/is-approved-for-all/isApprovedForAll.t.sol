// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__IsApprovedForAll is ERC721UnitTest {
    /// @dev it should return false.
    function testIsApprovedForAll__False() external {
        bool actualApprovedForAll = nft.isApprovedForAll(users.owner, users.to);
        bool expectedApprovedForAll = false;
        assertEq(actualApprovedForAll, expectedApprovedForAll);
    }

    /// @dev it should return true.
    function testIsApprovedForAll__True() external {
        bool actualApprovedForAll = nft.isApprovedForAll(users.owner, users.operator);
        bool expectedApprovedForAll = APPROVED;
        assertEq(actualApprovedForAll, expectedApprovedForAll);
    }
}
