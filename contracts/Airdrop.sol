pragma solidity ^0.6.12;

import "./IERC20.sol";
import "@openzeppelin/contracts/cryptography/ECDSA.sol";

contract Airdrop {

    using ECDSA for *;

    IERC20 public airdropToken;

    address public signerAddress;
    uint256 public airdropAmountPerWallet;
    uint256 public totalTokensWithdrawn;

    mapping (address => bool) public wasClaimed;

    constructor(address _signerAddress, uint256 _airdropAmountPerWallet) public {
        signerAddress = _signerAddress;
        airdropAmountPerWallet = _airdropAmountPerWallet;
    }

    function withdrawTokens(bytes memory signature) public {
        require(checkSignature(signature, msg.sender) == true, "Not eligible to claim tokens!");
        require(wasClaimed[msg.sender] == false, "Already claimed!");

        airdropToken.transfer(msg.sender, airdropAmountPerWallet);

        wasClaimed[msg.sender] = true;
    }

    function checkSignature(bytes memory signature, address beneficiary) public view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(beneficiary, airdropAmountPerWallet));
        bytes32 messageHash = hash.toEthSignedMessageHash();
        // Verify that the message's signer is the signatory address
        address signer = messageHash.recover(signature);
        return signer == signerAddress;
    }

}
