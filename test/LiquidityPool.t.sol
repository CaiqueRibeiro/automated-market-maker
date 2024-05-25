// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {LiquidityPool} from "../src/LiquidityPool.sol";
import {DeployLiquidityPool} from "../script/DeployLiquidityPool.s.sol";

contract LiquidityPoolTest is Test {
    LiquidityPool liquidityPool;

    function setUp() external {
        DeployLiquidityPool deployLiquidityPool = new DeployLiquidityPool();
        liquidityPool = deployLiquidityPool.run();
    }

    function testIsDefined() public view {
        assert(address(liquidityPool) != address(0));
    }
}
