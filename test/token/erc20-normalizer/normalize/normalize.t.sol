// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { ERC20GodMode } from "@prb/contracts/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "@prb/contracts/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "@prb/contracts/token/erc20/IERC20Normalizer.sol";

import { stdError } from "forge-std/Test.sol";

import { ERC20NormalizerTest } from "../ERC20NormalizerTest.t.sol";

contract ERC20Normalizer__Normalize is ERC20NormalizerTest {
    /// @dev it should return the normalized amount.
    function testNormalize__ScalarNotComputed() external {
        uint256 amount = bn(100, usdc.decimals());
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount = bn(100, STANDARD_DECIMALS);
        assertEq(expectedNormalizedAmount, actualNormalizedAmount);
    }

    modifier ScalarComputed() {
        _;
    }

    /// @dev it should return the normalized amount.
    function testNormalize__Scalar1() external ScalarComputed {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = bn(100, usdc.decimals());
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount = bn(100, STANDARD_DECIMALS);
        assertEq(actualNormalizedAmount, expectedNormalizedAmount);
    }

    modifier ScalarNot1() {
        _;
    }

    /// @dev it should revert.
    function testCannotNormalize__CalculationOverflows(uint256 amount) external ScalarComputed ScalarNot1 {
        vm.assume(amount > (MAX_UINT256 / USDC_SCALAR) + 1); // 10^12 is the scalar for USDC.
        erc20Normalizer.computeScalar(usdc);
        vm.expectRevert(stdError.arithmeticError);
        erc20Normalizer.normalize(usdc, amount);
    }

    modifier CalculationDoesNotOverflow() {
        _;
    }

    /// @dev it should return zero.
    function testNormalize__AmountZero() external ScalarComputed ScalarNot1 CalculationDoesNotOverflow {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = 0;
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount = 0;
        assertEq(actualNormalizedAmount, expectedNormalizedAmount);
    }

    modifier AmountNotZero() {
        _;
    }

    /// @dev it should return the normalized amount.
    function testNormalize(uint256 amount) external ScalarComputed ScalarNot1 CalculationDoesNotOverflow AmountNotZero {
        vm.assume(amount > 0);
        vm.assume(amount <= MAX_UINT256 / USDC_SCALAR); // 10^12 is the scalar for USDC.
        erc20Normalizer.computeScalar(usdc);
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount;
        unchecked {
            expectedNormalizedAmount = amount * USDC_SCALAR;
        }
        assertEq(actualNormalizedAmount, expectedNormalizedAmount);
    }
}
