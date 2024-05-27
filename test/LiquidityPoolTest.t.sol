// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {LiquidityPool} from "../src/LiquidityPool.sol";
import {DeployLiquidityPool} from "../script/DeployLiquidityPool.s.sol";
import {TokenIn, TokenOut} from "./mock/TokensMock.sol";

contract LiquidityPoolTest is Test {
    LiquidityPool liquidityPool;
    TokenIn tokenIn;
    TokenOut tokenOut;
    uint256 constant TOKEN_IN_AMOUNT = 3000;
    uint256 constant TOKEN_OUT_AMOUNT = 5000;

    address public LIQUIDITY_PROVIDER = makeAddr("lp1");

    function setUp() external {
        DeployLiquidityPool deployLiquidityPool = new DeployLiquidityPool();
        (LiquidityPool lp, address token0, address token1) = deployLiquidityPool
            .run();
        liquidityPool = lp;
        tokenIn = TokenIn(token0);
        tokenOut = TokenOut(token1);
    }

    modifier mintedUser() {
        tokenIn.mint(LIQUIDITY_PROVIDER, TOKEN_IN_AMOUNT * 2);
        tokenOut.mint(LIQUIDITY_PROVIDER, TOKEN_OUT_AMOUNT * 2);
        _;
    }

    modifier allowed() {
        vm.startPrank(LIQUIDITY_PROVIDER);
        tokenIn.approve(address(liquidityPool), 3000);
        tokenOut.approve(address(liquidityPool), 5000);
        vm.stopPrank();
        _;
    }

    function testIsDefined() public view {
        assert(address(liquidityPool) != address(0));
    }

    function testCanDeposit() public mintedUser allowed {
        vm.prank(LIQUIDITY_PROVIDER);
        uint256 share = liquidityPool.deposit(
            TOKEN_IN_AMOUNT,
            TOKEN_OUT_AMOUNT
        );

        assert(share > 0);
        assert(share == 3872);

        uint256 contractBalance0 = tokenIn.balanceOf(address(liquidityPool));
        uint256 contractBalance1 = tokenOut.balanceOf(address(liquidityPool));

        assert(contractBalance0 == 3000);
        assert(contractBalance1 == 5000);
    }

    function testCannotDepositIfShareIsTooSmall() public mintedUser allowed {
        vm.prank(LIQUIDITY_PROVIDER);
        vm.expectRevert(LiquidityPool.Lp_ShareTooSmall.selector);
        liquidityPool.deposit(0, TOKEN_OUT_AMOUNT);
    }
}
