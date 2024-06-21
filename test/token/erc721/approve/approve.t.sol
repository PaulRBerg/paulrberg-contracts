// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__Approve is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotApprove__CurrentOwner() external {
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__ApproveCurrentOwner.selector, users.owner));
        nft.approve(users.owner, TOKEN_ID);
    }

    modifier NotCurrentOwner() {
        _;
    }

    /// @dev it should revert.
    function testCannotApprove__UnauthorizedApprover() external NotCurrentOwner {
        address unauthorizedApprover = users.to;
        changePrank(unauthorizedApprover);
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__UnauthorizedApprover.selector, unauthorizedApprover));
        nft.approve(unauthorizedApprover, TOKEN_ID);
    }

    modifier AuthorizedApprover() {
        _;
    }

    /// @dev it should make the approval.
    function testApprove__CallerOwner() external NotCurrentOwner AuthorizedApprover {
        address actualApproved = nft.getApproved(TOKEN_ID);
        address expectedApproved = users.chad;

        assertEq(actualApproved, expectedApproved);
    }

    /// @dev it should emit an Approval event.
    function testApprove__CallerOwner__Event() external NotCurrentOwner AuthorizedApprover {
        uint256 tokenId = 1;

        nft.mint(users.owner, tokenId);

        vm.expectEmit(true, true, false, true);
        emit Approval(users.owner, users.to, tokenId);
        nft.approve(users.to, tokenId);
    }

    /// @dev it should make the approval.
    function testApprove__CallerApproved() external NotCurrentOwner AuthorizedApprover {
        changePrank(users.operator);

        nft.approve(users.to, TOKEN_ID);

        address actualApproved = nft.getApproved(TOKEN_ID);
        address expectedApproved = users.to;

        assertEq(actualApproved, expectedApproved);
    }

    /// @dev it should emit an Approval event.
    function testApprove__CallerApproved__Event() external NotCurrentOwner AuthorizedApprover {
        changePrank(users.operator);

        vm.expectEmit(true, true, false, true);
        emit Approval(users.owner, users.to, TOKEN_ID);
        nft.approve(users.to, TOKEN_ID);
    }

    /// @dev it should make the approval.
    function testApprove(address to, uint256 tokenId) external NotCurrentOwner AuthorizedApprover {
        vm.assume(to != address(0) && to != users.owner);
        vm.assume(tokenId != 4_20);

        nft.mint(users.owner, tokenId);

        nft.approve(to, tokenId);

        address actualApproved = nft.getApproved(tokenId);
        address expectedApproved = to;

        assertEq(actualApproved, expectedApproved);
    }
}
