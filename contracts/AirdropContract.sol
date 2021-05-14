pragma solidity ^0.6.12;

import "./IERC20.sol";

contract AirdropContract {

    IERC20 public airdropToken;

    address public signerAddress;
    uint256 public airdropAmountPerWallet;
    uint256 public totalTokensWithdrawn;

    mapping (address => bool) public wasClaimed;

    constructor(address _signerAddress, uint256 _airdropAmountPerWallet) public {
        signerAddress = _signerAddress;
        airdropAmountPerWallet = _airdropAmountPerWallet;
    }

    function withdrawTokens(bytes memory proof) public {
        require(checkProof(proof, msg.sender) == true, "Not eligible to claim tokens!");
        require(wasClaimed[msg.sender] == false, "Already claimed!");

        airdropToken.transfer(msg.sender, airdropAmountPerWallet);

        wasClaimed[msg.sender] = true;
    }

    function checkProof(bytes memory proof, address beneficiary) public view returns (bool) {
        //TODO: Add ECDSA proof verification.
        return true;
    }

}
