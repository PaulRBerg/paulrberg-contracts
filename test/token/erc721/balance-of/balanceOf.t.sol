// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC721 } from "@prb/contracts/token/erc721/IERC721.sol";

import { ERC721UnitTest } from "../ERC721UnitTest.t.sol";

contract ERC721__UnitTest__BalanceOf is ERC721UnitTest {
    /// @dev it should revert.
    function testCannotBalanceOf__OwnerZeroAddress() external {
        address ownerZeroAddress = address(0);
        vm.expectRevert(IERC721.ERC721__BalanceOfZeroAddress.selector);
        nft.balanceOf(ownerZeroAddress);
    }

    modifier OwnerNotZeroAddress() {
        _;
    }

    /// @dev it should return the correct balance.
    function testBalanceOf() external OwnerNotZeroAddress {
        uint256 actualBalance = nft.balanceOf(users.owner);
        uint256 expectedBalance = 1;

        assertEq(actualBalance, expectedBalance);
    }
}
