// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {TokenIn, TokenOut} from "../test/mock/TokensMock.sol";

contract HelperConfig is Script {
    ERC20 s_tokenIn;
    ERC20 s_tokenOut;

    constructor() {
        if (block.chainid == 11155111) {
            getEthTokens();
        } else {
            getAnvilTokens();
        }
    }

    function getEthTokens() public {
        s_tokenIn = ERC20(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        s_tokenOut = ERC20(0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B);
    }

    function getAnvilTokens() public {
        if (
            address(s_tokenIn) != address(0) &&
            address(s_tokenOut) != address(0)
        ) {
            return;
        }

        vm.startBroadcast();
        s_tokenIn = new TokenIn();
        s_tokenOut = new TokenOut();
        vm.stopBroadcast();
    }

    function getTokenAddresses() external view returns (address, address) {
        return (address(s_tokenIn), address(s_tokenOut));
    }
}
