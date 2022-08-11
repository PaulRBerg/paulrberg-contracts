// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

/// @title NonCompliantERC20
/// @author Paul Razvan Berg
/// @notice An implementation of ERC-20 that does not return a boolean on `transfer` and `transferFrom`.
/// @dev Strictly for test purposes. Do not use in production.
/// https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
contract NonCompliantERC20 {
    uint8 public decimals;

    string public name;

    string public symbol;

    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) internal _allowances;

    mapping(address => uint256) internal _balances;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function burn(address holder, uint256 amount) public {
        _balances[holder] -= amount;
        totalSupply -= amount;
        emit Transfer(holder, address(0), amount);
    }

    function mint(address beneficiary, uint256 amount) public {
        _balances[beneficiary] += amount;
        totalSupply += amount;
        emit Transfer(address(0), beneficiary, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /// @dev This function does not return a value, in violation of the ERC-20 standard.
    function transfer(address to, uint256 amount) public {
        _transfer(msg.sender, to, amount);
    }

    /// @dev This function does not return a value, in violation of the ERC-20 standard.
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public {
        _transfer(from, to, amount);
        _approve(from, msg.sender, _allowances[from][msg.sender] - amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + amount;
        emit Transfer(from, to, amount);
    }
}
