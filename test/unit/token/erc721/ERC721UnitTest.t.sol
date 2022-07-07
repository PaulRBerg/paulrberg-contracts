// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { ERC721GodMode } from "@prb/contracts/token/erc721/ERC721GodMode.sol";
import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";
import { IERC721Receiver } from "@prb/contracts/token/erc721/IERC721Receiver.sol";

import { Test } from "forge-std/Test.sol";

/// @title ERC721UnitTest
/// @author Andrei Vlad Brg
/// @notice Common contract members needed across ERC721 test contracts.
abstract contract ERC721UnitTest is Test {
    /// EVENTS ///
    event Approval(address indexed owner, address indexed spender, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /// CONSTANTS ///

    bool internal constant APPROVED = true;
    bytes internal constant DATA = "DATA BYTES";
    uint256 internal constant TOKEN_ID = 4_20;

    /// STRUCTS ///

    struct Users {
        address chad;
        address operator;
        address owner;
        address to;
    }
    /// STORAGE ///

    bytes32 internal nextUser = keccak256(abi.encodePacked("user address"));
    ERC721GodMode internal nft;
    Users internal users;

    /// CONSTRUCTOR ///

    constructor() {
        // Create 4 users for testing. Order matters.
        users = Users({ chad: getNextUser(), operator: getNextUser(), owner: getNextUser(), to: getNextUser() });
        vm.label(users.chad, "chad");

        vm.label(users.operator, "operator");

        vm.label(users.owner, "owner");

        vm.label(users.to, "to");
    }

    /// SETUP FUNCTION ///

    /// @dev A setup function.
    function setUp() public {
        nft = new ERC721GodMode("Non-fungible token", "NFT");
        vm.startPrank(users.owner);
        nft.mint(users.owner, TOKEN_ID);
        nft.approve(users.chad, TOKEN_ID);
        nft.setApprovalForAll(users.operator, APPROVED);
    }

    /// INTERNAL NON-CONSTANT FUNCTIONS ///

    /// @dev Converts bytes32 to address.
    function getNextUser() internal returns (address payable) {
        address payable user = payable(address(uint160(uint256(nextUser))));
        nextUser = keccak256(abi.encodePacked(nextUser));
        return user;
    }
}

contract ERC721Recipient is IERC721Receiver {
    address public operator;
    address public from;
    uint256 public tokenId;
    bytes public data;

    function onERC721Received(
        address operator_,
        address from_,
        uint256 tokenId_,
        bytes calldata data_
    ) public virtual override returns (bytes4) {
        operator = operator_;
        from = from_;
        tokenId = tokenId_;
        data = data_;

        return IERC721Receiver.onERC721Received.selector;
    }
}

contract NonERC721ReceiverImplementer {}

contract WrongReturnDataERC721Recipient is IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) public virtual override returns (bytes4) {
        operator;
        from;
        tokenId;
        data;
        return 0x12345678;
    }
}