// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__SetApprovalForAll is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotSetApprovalForAll__CurrentOwner() external {
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__ApproveCurrentOwner.selector, users.owner));
        nft.setApprovalForAll(users.owner, APPROVED);
    }

    modifier NotCurrentOwner() {
        _;
    }

    /// @dev it should set the aprroval value for all the tokens.
    function testSetApprovalForAll__True() external NotCurrentOwner {
        bool actualApprovalForAll = nft.isApprovedForAll(users.owner, users.operator);
        bool expectedApprovalForAll = APPROVED;

        assertEq(actualApprovalForAll, expectedApprovalForAll);
    }

    /// @dev it should emit a ApprovalForAll event.
    function testSetApprovalForAll__True__Event() external NotCurrentOwner {
        vm.expectEmit(true, true, false, true);
        emit ApprovalForAll(users.owner, users.operator, APPROVED);
        nft.setApprovalForAll(users.operator, APPROVED);
    }

    /// @dev it should set the aprroval value for all the tokens.
    function testSetApprovalForAll__False() external NotCurrentOwner {
        bool approvedFalse = false;

        nft.setApprovalForAll(users.operator, approvedFalse);

        bool actualApprovalForAll = nft.isApprovedForAll(users.owner, users.operator);
        bool expectedApprovalForAll = approvedFalse;

        assertEq(actualApprovalForAll, expectedApprovalForAll);
    }

    /// @dev it should emit a ApprovalForAll event.
    function testSetApprovalForAll__False__Event() external NotCurrentOwner {
        bool approvedFalse = false;

        vm.expectEmit(true, true, false, true);
        emit ApprovalForAll(users.owner, users.operator, approvedFalse);
        nft.setApprovalForAll(users.operator, approvedFalse);
    }

    /// @dev it should set the aprroval value for all the tokens.
    function testSetApprovalForAll(address operator, bool approved) external NotCurrentOwner {
        vm.assume(operator != users.owner);

        nft.setApprovalForAll(operator, approved);

        bool actualApprovalForAll = nft.isApprovedForAll(users.owner, operator);
        bool expectedApprovalForAll = approved;

        assertEq(actualApprovalForAll, expectedApprovalForAll);
    }
}
