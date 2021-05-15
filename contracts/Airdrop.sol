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

    event TokensAirdropped(address beneficiary, uint256 amount);

    constructor(address _signerAddress, uint256 _airdropAmountPerWallet) public {
        signerAddress = _signerAddress;
        airdropAmountPerWallet = _airdropAmountPerWallet;
    }

    function withdrawTokens(bytes memory signature) public {
        address beneficiary = msg.sender;

        require(checkSignature(signature, beneficiary) == true, "Not eligible to claim tokens!");
        require(wasClaimed[beneficiary] == false, "Already claimed!");

        airdropToken.transfer(beneficiary, airdropAmountPerWallet);

        emit TokensAirdropped(beneficiary, airdropAmountPerWallet);
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
