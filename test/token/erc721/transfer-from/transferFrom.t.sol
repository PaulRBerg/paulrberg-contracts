// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__TransferFrom is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotTransferFrom__InvalidFrom() external {
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__TransferInvalidFrom.selector, users.chad));
        nft.transferFrom(users.chad, users.to, TOKEN_ID);
    }

    modifier ValidFrom() {
        _;
    }

    /// @dev it should revert.
    function testCannotTransferFrom__ToZeroAddress() external ValidFrom {
        address to = address(0);
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__TransferZeroAddress.selector));
        nft.transferFrom(users.owner, to, TOKEN_ID);
    }

    modifier ToNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotTransferFrom__UnauthorizedSender() external ValidFrom ToNotZeroAddress {
        changePrank(users.to);
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__UnauthorizedSender.selector, users.to));
        nft.transferFrom(users.owner, users.to, TOKEN_ID);
    }

    modifier AuthorizedSender() {
        _;
    }

    /// @dev it should make the transfer.
    function testTransferFrom__CallerFrom() external ValidFrom ToNotZeroAddress AuthorizedSender {
        address from = users.owner;
        address to = users.to;

        nft.transferFrom(from, to, TOKEN_ID);

        address actualApprovals = nft.getApproved(TOKEN_ID);
        address expectedApprovals = address(0);
        assertEq(actualApprovals, expectedApprovals);

        uint256 actualBalanceFrom = nft.balanceOf(from);
        uint256 expectedBalanceFrom = 0;
        assertEq(actualBalanceFrom, expectedBalanceFrom);

        uint256 actualBalanceTo = nft.balanceOf(to);
        uint256 expectedBalanceTo = 1;
        assertEq(actualBalanceTo, expectedBalanceTo);

        address actualOwner = nft.ownerOf(TOKEN_ID);
        address expectedOwner = to;
        assertEq(actualOwner, expectedOwner);
    }

    /// @dev it should emit a Transfer event.
    function testTransferFrom__CallerFrom__Event() external ValidFrom ToNotZeroAddress AuthorizedSender {
        address from = users.owner;
        address to = users.to;

        vm.expectEmit(true, true, false, true);
        emit Transfer(from, to, TOKEN_ID);
        nft.transferFrom(from, to, TOKEN_ID);
    }

    /// @dev it should make the transfer.
    function testTransferFrom__CallerOperator() external ValidFrom ToNotZeroAddress AuthorizedSender {
        address from = users.owner;
        address to = users.to;

        changePrank(users.operator);
        nft.transferFrom(from, to, TOKEN_ID);

        address actualApprovals = nft.getApproved(TOKEN_ID);
        address expectedApprovals = address(0);
        assertEq(actualApprovals, expectedApprovals);

        uint256 actualBalanceFrom = nft.balanceOf(from);
        uint256 expectedBalanceFrom = 0;
        assertEq(actualBalanceFrom, expectedBalanceFrom);

        uint256 actualBalanceTo = nft.balanceOf(to);
        uint256 expectedBalanceTo = 1;
        assertEq(actualBalanceTo, expectedBalanceTo);

        address actualOwner = nft.ownerOf(TOKEN_ID);
        address expectedOwner = to;
        assertEq(actualOwner, expectedOwner);
    }

    /// @dev it should emit a Transfer event.
    function testTransferFrom__CallerOperator__Event() external ValidFrom ToNotZeroAddress AuthorizedSender {
        address from = users.owner;
        address to = users.to;

        changePrank(users.operator);
        vm.expectEmit(true, true, false, true);
        emit Transfer(from, to, TOKEN_ID);
        nft.transferFrom(from, to, TOKEN_ID);
    }

    /// @dev it should make the transfer.
    function testTransferFrom__CallerApproved() external ValidFrom ToNotZeroAddress AuthorizedSender {
        address from = users.owner;
        address to = users.to;

        changePrank(users.chad);
        nft.transferFrom(from, to, TOKEN_ID);

        address actualApprovals = nft.getApproved(TOKEN_ID);
        address expectedApprovals = address(0);
        assertEq(actualApprovals, expectedApprovals);

        uint256 actualBalanceFrom = nft.balanceOf(from);
        uint256 expectedBalanceFrom = 0;
        assertEq(actualBalanceFrom, expectedBalanceFrom);

        uint256 actualBalanceTo = nft.balanceOf(to);
        uint256 expectedBalanceTo = 1;
        assertEq(actualBalanceTo, expectedBalanceTo);

        address actualOwner = nft.ownerOf(TOKEN_ID);
        address expectedOwner = to;
        assertEq(actualOwner, expectedOwner);
    }

    /// @dev it should emit a Transfer event.
    function testTransferFrom__CallerApproved__Event() external ValidFrom ToNotZeroAddress AuthorizedSender {
        address from = users.owner;
        address to = users.to;

        changePrank(users.chad);
        vm.expectEmit(true, true, false, true);
        emit Transfer(from, to, TOKEN_ID);
        nft.transferFrom(from, to, TOKEN_ID);
    }

    /// @dev it should make the transfer.
    function testTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external ValidFrom ToNotZeroAddress AuthorizedSender {
        vm.assume(from != address(0) && from != users.owner);
        vm.assume(to != address(0) && to != from && to != users.owner);
        vm.assume(tokenId != TOKEN_ID);
        changePrank(from);

        nft.mint(from, tokenId);
        nft.transferFrom(from, to, tokenId);

        address actualApprovals = nft.getApproved(tokenId);
        address expectedApprovals = address(0);
        assertEq(actualApprovals, expectedApprovals);

        uint256 actualBalanceFrom = nft.balanceOf(from);
        uint256 expectedBalanceFrom = 0;
        assertEq(actualBalanceFrom, expectedBalanceFrom);

        uint256 actualBalanceTo = nft.balanceOf(to);
        uint256 expectedBalanceTo = 1;
        assertEq(actualBalanceTo, expectedBalanceTo);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = to;
        assertEq(actualOwner, expectedOwner);
    }
}
