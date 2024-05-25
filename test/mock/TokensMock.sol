// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenIn is ERC20 {
    constructor() ERC20("Token In", "TKI") {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}

contract TokenOut is ERC20 {
    constructor() ERC20("Token Out", "TKO") {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}
