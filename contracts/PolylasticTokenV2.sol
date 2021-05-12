pragma solidity ^0.6.12;

import "./utils/Context.sol";
import "./IERC20.sol";
import "./math/SafeMath.sol";

/**
 * PolylasticTokenV2 contract.
 */
contract PolylasticTokenV2 is Context, IERC20 {

    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    address public admin;
    address public treasury;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping (address => bool) isAddressWhitelisted;


    constructor (
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        uint8 decimals_,
        address _treasury
    ) public {
        admin = msg.sender;

        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _mint(_msgSender(), totalSupply_);

        treasury = _treasury;
    }

    /// Function to transfer ownership of the contract
    function transferOwnership(address newOwner)
    public
    {
        require(msg.sender == admin);
        require(newOwner != address(0));

        admin = newOwner;
    }

    /// Function to set treasury wallet
    function setTreasury(address _treasury) public {
        require(msg.sender == admin);
        treasury = _treasury;
    }


    /// Function to whitelist selected wallets
    function whitelistWallets(address [] memory wallets)
    public
    {
        require(msg.sender == admin);

        for(uint i = 0; i <  wallets.length; i++) {
            isAddressWhitelisted[wallets[i]] = true;
        }
    }

    /// Function to remove whitelist permission to selected wallets
    function removeWhitelistStatus(address [] memory wallets)
    public
    {
        require(msg.sender == admin);

        for(uint i = 0; i <  wallets.length; i++) {
            isAddressWhitelisted[wallets[i]] = false;
        }
    }

    function computeTransferFee(address sender, address receiver, uint amount)
    public
    view
    returns (uint256)
    {
        if(isAddressWhitelisted[sender] || isAddressWhitelisted[receiver]) {
            // In whitelist case there's no fee
            return 0;
        }

        return computeTransferFeeInTokens(amount);
    }

    /**
     * @notice Function to compute transfer fee in tokens based on the amount being sent
     */
    function computeTransferFeeInTokens(
        uint amountOfTokensToTransfer
    )
    public
    pure
    returns (uint)
    {
        // Fixed 2% fee on transfers less than 100 tokens
        if(amountOfTokensToTransfer <= 100 * 10**18) {
            return amountOfTokensToTransfer.mul(2).div(100);
        } else {
            uint root = sqrt(amountOfTokensToTransfer);
            return root.mul(10**9).div(5);
        }
    }

    function computeFeePercentageForTransfer(
        uint amountOfTokensToTransfer
    )
    public
    pure
    returns (uint)
    {
        uint fee = computeTransferFeeInTokens(amountOfTokensToTransfer);
        // Return fee % in WEI units
        return fee.mul(10**18).div(amountOfTokensToTransfer).mul(100);
    }


    /**
     * @notice Function to compute square root of a number
     */
    function sqrt(
        uint x
    )
    internal
    pure
    returns (uint y)
    {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        uint transferFee = computeTransferFee(recipient, _msgSender(), amount);

        if(transferFee > 0) {
            _transfer(_msgSender(), treasury, transferFee);
        }

        _transfer(_msgSender(), recipient, amount.sub(transferFee));

        return true;
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        uint transferFee = computeTransferFee(recipient, _msgSender(), amount);

        if(transferFee > 0) {
            _transfer(_msgSender(), treasury, transferFee);
        }

        _transfer(sender, recipient, amount.sub(transferFee));

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");


        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }


    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
}
