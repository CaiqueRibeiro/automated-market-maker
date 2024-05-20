// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract LiquidityPool is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    error Lp_NonConstantProduct();
    error Lp_ShareTooSmall();
    error Lp_ReceiveAmountToSmall(string message);

    ERC20 public s_token0;
    ERC20 public s_token1;
    uint256 public s_reserve0;
    uint256 public s_reserve1;

    constructor(
        address _token0,
        address _token1
    ) ERC20("Liquidity Pool Token", "LPT") Ownable(msg.sender) {
        s_token0 = ERC20(_token0);
        s_token1 = ERC20(_token1);
    }

    function deposit(
        uint256 _amount0,
        uint256 _amount1
    ) external nonReentrant returns (uint256 shares) {
        if (s_reserve0 > 0 || s_reserve1 > 0) {
            if (_amount0 * s_reserve1 != _amount1 * s_reserve0) {
                revert Lp_NonConstantProduct();
            }
        }

        s_token0.transferFrom(msg.sender, address(this), _amount0);
        s_token1.transferFrom(msg.sender, address(this), _amount1);

        uint256 totalSupply = totalSupply();

        if (totalSupply == 0) {
            shares = _sqrt(_amount0 * _amount1);
        } else {
            shares = _min(
                (_amount0 * totalSupply) / s_reserve0,
                (_amount1 * totalSupply) / s_reserve1
            );
        }

        if (shares <= 0) {
            revert Lp_ShareTooSmall();
        }

        _mint(msg.sender, shares);
        _update(s_reserve0 + _amount0, s_reserve1 + _amount1);
    }

    function withdraw(
        uint256 _shares
    ) external nonReentrant returns (uint256 amount0, uint256 amount1) {
        uint256 bal0 = s_token0.balanceOf(address(this));
        uint256 bal1 = s_token1.balanceOf(address(this));
        uint256 totalSupply = totalSupply();
        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;

        if (amount1 == 0 || amount1 == 0) {
            revert Lp_ReceiveAmountToSmall("amount0 or amount1 == 0");
        }

        _burn(msg.sender, _shares);
        _update(bal0 - amount0, bal1 - amount1);

        s_token0.transfer(msg.sender, amount0);
        s_token1.transfer(msg.sender, amount1);
    }

    function _update(uint256 _reserve0, uint256 _reserve1) private {
        s_reserve0 = _reserve0;
        s_reserve1 = _reserve1;
    }

    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint256 x, uint256 y) private pure returns (uint256) {
        return x < y ? x : y;
    }
}
