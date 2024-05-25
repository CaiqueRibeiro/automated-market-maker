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

    address public LIQUIDITY_PROVIDER = makeAddr("lp1");

    function setUp() external {
        DeployLiquidityPool deployLiquidityPool = new DeployLiquidityPool();
        (LiquidityPool lp, address token0, address token1) = deployLiquidityPool
            .run();
        liquidityPool = lp;
        tokenIn = TokenIn(token0);
        tokenOut = TokenOut(token1);
    }

    function testIsDefined() public view {
        assert(address(liquidityPool) != address(0));
    }

    function testCanDeposit() public {
        uint256 amount1 = 3000;
        uint256 amount2 = 5000;
        tokenIn.mint(LIQUIDITY_PROVIDER, amount1 * 2);
        tokenOut.mint(LIQUIDITY_PROVIDER, amount2 * 2);

        vm.startPrank(LIQUIDITY_PROVIDER);
        tokenIn.approve(address(liquidityPool), amount1);
        tokenOut.approve(address(liquidityPool), amount2);

        uint256 share = liquidityPool.deposit(amount1, amount2);
        vm.stopPrank();

        assert(share > 0);
        assert(share == 3872);
    }

    function testCannotDepositIfShareIsTooSmall() public {
        uint256 amount1 = 0;
        uint256 amount2 = 1;
        tokenIn.mint(LIQUIDITY_PROVIDER, amount1 * 2);
        tokenOut.mint(LIQUIDITY_PROVIDER, amount2 * 2);

        vm.startPrank(LIQUIDITY_PROVIDER);
        tokenIn.approve(address(liquidityPool), amount1);
        tokenOut.approve(address(liquidityPool), amount2);

        vm.expectRevert(LiquidityPool.Lp_ShareTooSmall.selector);
        liquidityPool.deposit(amount1, amount2);
        vm.stopPrank();
    }
}
