// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenIn is ERC20 {
    constructor() ERC20("Token In", "TKI") {}
}

contract TokenOut is ERC20 {
    constructor() ERC20("Token Out", "TKO") {}
}
