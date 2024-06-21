// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721Recipient } from "../ERC721UnitTest.t.sol";
import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";
import { NonERC721ReceiverImplementer } from "../ERC721UnitTest.t.sol";
import { WrongReturnDataERC721Recipient } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__SafeTransferFrom is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotSafeTransferFrom__NonERC721ReceiverImplementer() external {
        NonERC721ReceiverImplementer nonERC721ReceiverImplementer = new NonERC721ReceiverImplementer();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeTransferFrom(users.owner, address(nonERC721ReceiverImplementer), TOKEN_ID);
    }

    /// @dev it should revert.
    function testCannotSafeTransferFrom__NonERC721ReceiverImplementer__WithData() external {
        NonERC721ReceiverImplementer nonERC721ReceiverImplementer = new NonERC721ReceiverImplementer();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeTransferFrom(users.owner, address(nonERC721ReceiverImplementer), TOKEN_ID, DATA);
    }

    modifier ERC721ReceiverImplementer() {
        _;
    }

    /// @dev it should revert.
    function testCannotSafeTransferFrom__WrongReturnData() external ERC721ReceiverImplementer {
        WrongReturnDataERC721Recipient wrongReturnDataERC721Recipient = new WrongReturnDataERC721Recipient();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeTransferFrom(users.owner, address(wrongReturnDataERC721Recipient), TOKEN_ID);
    }

    /// @dev it should revert.
    function testCannotSafeTransferFrom__WrongReturnData__WithData() external ERC721ReceiverImplementer {
        WrongReturnDataERC721Recipient wrongReturnDataERC721Recipient = new WrongReturnDataERC721Recipient();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeTransferFrom(users.owner, address(wrongReturnDataERC721Recipient), TOKEN_ID, DATA);
    }

    modifier CorrectReturnData() {
        _;
    }

    /// @dev it should transfer the token safely.
    function testSafeTransferFrom__EOA() external ERC721ReceiverImplementer CorrectReturnData {
        address from = users.owner;
        address to = users.to;

        nft.safeTransferFrom(from, to, TOKEN_ID);

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

    /// @dev it should transfer the token safely.
    function testSafeTransferFrom__ERC721Recipient() external ERC721ReceiverImplementer CorrectReturnData {
        address from = users.owner;
        ERC721Recipient to = new ERC721Recipient();

        nft.safeTransferFrom(from, address(to), TOKEN_ID);

        address actualApprovals = nft.getApproved(TOKEN_ID);
        address expectedApprovals = address(0);
        assertEq(actualApprovals, expectedApprovals);

        uint256 actualBalanceFrom = nft.balanceOf(from);
        uint256 expectedBalanceFrom = 0;
        assertEq(actualBalanceFrom, expectedBalanceFrom);

        uint256 actualBalanceTo = nft.balanceOf(address(to));
        uint256 expectedBalanceTo = 1;
        assertEq(actualBalanceTo, expectedBalanceTo);

        address actualOwner = nft.ownerOf(TOKEN_ID);
        address expectedOwner = address(to);
        assertEq(actualOwner, expectedOwner);

        address actualOperator = to.operator();
        address expectedOperator = users.owner;
        assertEq(actualOperator, expectedOperator);

        address actualFrom = to.from();
        address expectedFrom = from;
        assertEq(actualFrom, expectedFrom);

        uint256 actualTokenId = to.tokenId();
        uint256 expectedTokenId = TOKEN_ID;
        assertEq(actualTokenId, expectedTokenId);

        bytes memory actualData = to.data();
        bytes memory expectedData = "";
        assertEq(actualData, expectedData);
    }

    /// @dev it should transfer the token safely.
    function testSafeTransferFrom__ERC721Recipient__WithData() external ERC721ReceiverImplementer CorrectReturnData {
        address from = users.owner;
        ERC721Recipient to = new ERC721Recipient();

        nft.safeTransferFrom(from, address(to), TOKEN_ID, DATA);

        address actualApprovals = nft.getApproved(TOKEN_ID);
        address expectedApprovals = address(0);
        assertEq(actualApprovals, expectedApprovals);

        uint256 actualBalanceFrom = nft.balanceOf(from);
        uint256 expectedBalanceFrom = 0;
        assertEq(actualBalanceFrom, expectedBalanceFrom);

        uint256 actualBalanceTo = nft.balanceOf(address(to));
        uint256 expectedBalanceTo = 1;
        assertEq(actualBalanceTo, expectedBalanceTo);

        address actualOwner = nft.ownerOf(TOKEN_ID);
        address expectedOwner = address(to);
        assertEq(actualOwner, expectedOwner);

        address actualOperator = to.operator();
        address expectedOperator = users.owner;
        assertEq(actualOperator, expectedOperator);

        address actualFrom = to.from();
        address expectedFrom = from;
        assertEq(actualFrom, expectedFrom);

        uint256 actualTokenId = to.tokenId();
        uint256 expectedTokenId = TOKEN_ID;
        assertEq(actualTokenId, expectedTokenId);

        bytes memory actualData = to.data();
        bytes memory expectedData = DATA;
        assertEq(actualData, expectedData);
    }

    /// @dev it should transfer the token safely.
    function testSafeTransferFrom_EOA(
        address from,
        address to,
        uint256 tokenId
    ) external ERC721ReceiverImplementer CorrectReturnData {
        vm.assume(from != address(0) && from != users.owner);
        vm.assume(to != address(0) && to != from);
        vm.assume(tokenId != TOKEN_ID);
        if (uint256(uint160(to)) > 18 || to.code.length > 0) return;
        changePrank(from);

        nft.mint(from, tokenId);
        nft.safeTransferFrom(from, to, tokenId);

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

    /// @dev it should transfer the token safely.
    function testSafeTransferFrom__ERC721Recipient(address from, uint256 tokenId)
        external
        ERC721ReceiverImplementer
        CorrectReturnData
    {
        vm.assume(from != address(0) && from != users.owner);
        vm.assume(tokenId != TOKEN_ID);
        changePrank(from);

        ERC721Recipient to = new ERC721Recipient();

        nft.mint(from, tokenId);
        nft.safeTransferFrom(from, address(to), tokenId);

        address actualApprovals = nft.getApproved(tokenId);
        address expectedApprovals = address(0);
        assertEq(actualApprovals, expectedApprovals);

        uint256 actualBalanceFrom = nft.balanceOf(from);
        uint256 expectedBalanceFrom = 0;
        assertEq(actualBalanceFrom, expectedBalanceFrom);

        uint256 actualBalanceTo = nft.balanceOf(address(to));
        uint256 expectedBalanceTo = 1;
        assertEq(actualBalanceTo, expectedBalanceTo);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = address(to);
        assertEq(actualOwner, expectedOwner);

        address actualOperator = to.operator();
        address expectedOperator = from;
        assertEq(actualOperator, expectedOperator);

        address actualFrom = to.from();
        address expectedFrom = from;
        assertEq(actualFrom, expectedFrom);

        uint256 actualTokenId = to.tokenId();
        uint256 expectedTokenId = tokenId;
        assertEq(actualTokenId, expectedTokenId);

        bytes memory actualData = to.data();
        bytes memory expectedData = "";
        assertEq(actualData, expectedData);
    }

    /// @dev it should transfer the token safely.
    function testSafeTransferFrom__ERC721Recipient__WithData(
        address from,
        uint256 tokenId,
        bytes memory data
    ) external ERC721ReceiverImplementer CorrectReturnData {
        vm.assume(from != address(0) && from != users.owner);
        vm.assume(tokenId != TOKEN_ID);
        changePrank(from);

        ERC721Recipient to = new ERC721Recipient();

        nft.mint(from, tokenId);
        nft.safeTransferFrom(from, address(to), tokenId, data);

        // The brackets are used for avoing the stack too deep error.
        {
            address actualApprovals = nft.getApproved(tokenId);
            address expectedApprovals = address(0);
            assertEq(actualApprovals, expectedApprovals);
        }

        {
            uint256 actualBalanceFrom = nft.balanceOf(from);
            uint256 expectedBalanceFrom = 0;
            assertEq(actualBalanceFrom, expectedBalanceFrom);
        }

        {
            uint256 actualBalanceTo = nft.balanceOf(address(to));
            uint256 expectedBalanceTo = 1;
            assertEq(actualBalanceTo, expectedBalanceTo);
        }

        {
            address actualOwner = nft.ownerOf(tokenId);
            address expectedOwner = address(to);
            assertEq(actualOwner, expectedOwner);
        }

        {
            address actualOperator = to.operator();
            address expectedOperator = from;
            assertEq(actualOperator, expectedOperator);
        }

        {
            address actualFrom = to.from();
            address expectedFrom = from;
            assertEq(actualFrom, expectedFrom);
        }

        {
            uint256 actualTokenId = to.tokenId();
            uint256 expectedTokenId = tokenId;
            assertEq(actualTokenId, expectedTokenId);
        }

        {
            bytes memory actualData = to.data();
            bytes memory expectedData = data;
            assertEq(actualData, expectedData);
        }
    }
}
