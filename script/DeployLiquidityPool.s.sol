// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {LiquidityPool} from "../src/LiquidityPool.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployLiquidityPool is Script {
    function run() external returns (LiquidityPool, address, address) {
        HelperConfig helperConfig = new HelperConfig();
        (address tokenIn, address tokenOut) = helperConfig.getTokenAddresses();

        vm.startBroadcast();
        LiquidityPool liquidityPool = new LiquidityPool(tokenIn, tokenOut);
        vm.stopBroadcast();
        return (liquidityPool, tokenIn, tokenOut);
    }
}
