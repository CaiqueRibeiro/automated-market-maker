// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract LiquidityPool is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    ERC20 public s_token0;
    ERC20 public s_token1;

    uint public s_reserve0;
    uint public s_reserve1;

    constructor(
        address _token0,
        address _token1
    ) ERC20("Liquidity Pool Token", "LPT") Ownable(msg.sender) {
        s_token0 = ERC20(_token0);
        s_token1 = ERC20(_token1);
    }
}
