pragma solidity 0.6.12;

import "./IERC20.sol";
import "./math/SafeMath.sol";


contract TokenSwapPortal {

    using SafeMath for uint256;

    address public deployer;
    // Token which will be taken from users and burned
    IERC20 public tokenToReceive;
    // Token which will be sent to users, 1:1 ratio with tokenToBurn
    IERC20 public tokenToSend;

    uint public totalTokensSwapped;

    constructor(
        address _tokenToReceive,
        address _tokenToSend
    ) public {
        require(_tokenToReceive != address(0));
        require(_tokenToSend != address(0));

        deployer = msg.sender;

        tokenToReceive = IERC20(_tokenToReceive);
        tokenToSend = IERC20(_tokenToSend);
    }

    // Function to swap tokens
    function swapToken() public {
        uint amount = tokenToReceive.balanceOf(msg.sender);
        require(amount > 0, "User has 0 tokens to give.");

        bool status = tokenToReceive.transferFrom(msg.sender, address(this), amount);
        require(status, "transferFrom is false.");

        bool statusTransfer = tokenToSend.transfer(msg.sender, amount);
        require(statusTransfer, "transfer status is false");

        totalTokensSwapped = totalTokensSwapped.add(amount);
    }


    // Withdraw some tokens if stuck in the contract
    function withdrawTokenIfStuck(address token, uint amount)
    public
    {
        require(token != address(tokenToSend) && token != address(tokenToReceive), "Can not withdraw tokens which are for swaps");
        require(msg.sender == deployer, "Can be called only by deployer.");
        IERC20(token).transfer(deployer, amount);
    }
}
