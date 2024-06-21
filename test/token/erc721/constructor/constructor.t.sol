// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { ERC721GodMode } from "@prb/contracts/token/erc721/ERC721GodMode.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__Constructor is ERC721UnitTest {
    function testConstructor() external {
        string memory actualName = nft.name();
        string memory expectedName = "Non-fungible token";
        assertEq(actualName, expectedName);

        string memory actualSymbol = nft.symbol();
        string memory expectedSymbol = "NFT";
        assertEq(actualSymbol, expectedSymbol);
    }

    function testConstructor(string memory name, string memory symbol) external {
        ERC721GodMode nft = new ERC721GodMode(name, symbol);

        string memory actualName = nft.name();
        string memory expectedName = name;
        assertEq(actualName, expectedName);

        string memory actualSymbol = nft.symbol();
        string memory expectedSymbol = symbol;
        assertEq(actualSymbol, expectedSymbol);
    }
}
