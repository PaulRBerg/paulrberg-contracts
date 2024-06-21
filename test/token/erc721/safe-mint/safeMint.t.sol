// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721Recipient } from "../ERC721UnitTest.t.sol";
import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";
import { NonERC721ReceiverImplementer } from "../ERC721UnitTest.t.sol";
import { WrongReturnDataERC721Recipient } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__SafeMint is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotSafeMint__NonERC721ReceiverImplementer() external {
        uint256 tokenId = 1;
        NonERC721ReceiverImplementer nonERC721ReceiverImplementer = new NonERC721ReceiverImplementer();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeMint(address(nonERC721ReceiverImplementer), tokenId);
    }

    /// @dev it should revert.
    function testCannotSafeMint__NonERC721ReceiverImplementer__WithData() external {
        uint256 tokenId = 1;
        NonERC721ReceiverImplementer nonERC721ReceiverImplementer = new NonERC721ReceiverImplementer();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeMint(address(nonERC721ReceiverImplementer), tokenId, DATA);
    }

    modifier ERC721ReceiverImplementer() {
        _;
    }

    /// @dev it should revert.
    function testCannotSafeMint__WrongReturnData() external ERC721ReceiverImplementer {
        uint256 tokenId = 1;
        WrongReturnDataERC721Recipient wrongReturnDataERC721Recipient = new WrongReturnDataERC721Recipient();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeMint(address(wrongReturnDataERC721Recipient), tokenId);
    }

    /// @dev it should revert.
    function testCannotSafeMint__WrongReturnDataWithData__WithData() external ERC721ReceiverImplementer {
        uint256 tokenId = 1;
        WrongReturnDataERC721Recipient wrongReturnDataERC721Recipient = new WrongReturnDataERC721Recipient();
        vm.expectRevert(abi.encodeWithSelector(IERC721.ERC721__NonERC721ReceiverImplementer.selector));
        nft.safeMint(address(wrongReturnDataERC721Recipient), tokenId, DATA);
    }

    modifier CorrectReturnData() {
        _;
    }

    /// @dev it should mint the token safely.
    function testSafeMint__EOA() external ERC721ReceiverImplementer CorrectReturnData {
        uint256 tokenId = 1;
        nft.safeMint(users.to, tokenId);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = users.to;
        assertEq(actualOwner, expectedOwner);

        uint256 actualBalance = nft.balanceOf(users.to);
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should mint the token safely.
    function testSafeMint__ERC721Recipient() external ERC721ReceiverImplementer CorrectReturnData {
        ERC721Recipient to = new ERC721Recipient();
        uint256 tokenId = 1;

        nft.safeMint(address(to), tokenId);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = address(to);
        assertEq(actualOwner, expectedOwner);

        uint256 actualBalance = nft.balanceOf(address(to));
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);

        address actualOperator = to.operator();
        address expectedOperator = users.owner;
        assertEq(actualOperator, expectedOperator);

        address actualFrom = to.from();
        address expectedFrom = address(0);
        assertEq(actualFrom, expectedFrom);

        uint256 actualTokenId = to.tokenId();
        uint256 expectedTokenId = tokenId;
        assertEq(actualTokenId, expectedTokenId);

        bytes memory actualData = to.data();
        bytes memory expectedData = "";
        assertEq(actualData, expectedData);
    }

    /// @dev it should mint the token safely.
    function testSafeMint__ERC721Recipient__WithData() external ERC721ReceiverImplementer CorrectReturnData {
        ERC721Recipient to = new ERC721Recipient();
        uint256 tokenId = 1;

        nft.safeMint(address(to), tokenId, DATA);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = address(to);
        assertEq(actualOwner, expectedOwner);

        uint256 actualBalance = nft.balanceOf(address(to));
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);

        address actualOperator = to.operator();
        address expectedOperator = users.owner;
        assertEq(actualOperator, expectedOperator);

        address actualFrom = to.from();
        address expectedFrom = address(0);
        assertEq(actualFrom, expectedFrom);

        uint256 actualTokenId = to.tokenId();
        uint256 expectedTokenId = tokenId;
        assertEq(actualTokenId, expectedTokenId);

        bytes memory actualData = to.data();
        bytes memory expectedData = DATA;
        assertEq(actualData, expectedData);
    }

    /// @dev it should mint the token safely.
    function testSafeMint__EOA(address to, uint256 tokenId) external ERC721ReceiverImplementer CorrectReturnData {
        vm.assume(to != address(0) && to != users.owner);
        vm.assume(tokenId != TOKEN_ID);

        if (uint256(uint160(to)) > 18 || to.code.length > 0) return;

        nft.safeMint(to, tokenId);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = to;
        assertEq(actualOwner, expectedOwner);

        uint256 actualBalance = nft.balanceOf(address(to));
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should mint the token safely.
    function testSafeMint__ERC721Recipient(uint256 tokenId) external ERC721ReceiverImplementer CorrectReturnData {
        vm.assume(tokenId != TOKEN_ID);

        ERC721Recipient to = new ERC721Recipient();

        nft.safeMint(address(to), tokenId);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = address(to);
        assertEq(actualOwner, expectedOwner);

        uint256 actualBalance = nft.balanceOf(address(to));
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);

        address actualOperator = to.operator();
        address expectedOperator = users.owner;
        assertEq(actualOperator, expectedOperator);

        address actualFrom = to.from();
        address expectedFrom = address(0);
        assertEq(actualFrom, expectedFrom);

        uint256 actualTokenId = to.tokenId();
        uint256 expectedTokenId = tokenId;
        assertEq(actualTokenId, expectedTokenId);

        bytes memory actualData = to.data();
        bytes memory expectedData = "";
        assertEq(actualData, expectedData);
    }

    /// @dev it should mint the token safely.
    function testSafeMint__ERC721Recipient__WithData(uint256 tokenId, bytes calldata data)
        external
        ERC721ReceiverImplementer
        CorrectReturnData
    {
        vm.assume(tokenId != TOKEN_ID);

        ERC721Recipient to = new ERC721Recipient();

        nft.safeMint(address(to), tokenId, data);

        address actualOwner = nft.ownerOf(tokenId);
        address expectedOwner = address(to);
        assertEq(actualOwner, expectedOwner);

        uint256 actualBalance = nft.balanceOf(address(to));
        uint256 expectedBalance = 1;
        assertEq(actualBalance, expectedBalance);

        address actualOperator = to.operator();
        address expectedOperator = users.owner;
        assertEq(actualOperator, expectedOperator);

        address actualFrom = to.from();
        address expectedFrom = address(0);
        assertEq(actualFrom, expectedFrom);

        uint256 actualTokenId = to.tokenId();
        uint256 expectedTokenId = tokenId;
        assertEq(actualTokenId, expectedTokenId);

        bytes memory actualData = to.data();
        bytes memory expectedData = data;
        assertEq(actualData, expectedData);
    }
}
