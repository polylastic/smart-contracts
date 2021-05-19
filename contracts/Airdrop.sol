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

    constructor(address _signerAddress, uint256 _airdropAmountPerWallet, address _airdropToken) public {
        signerAddress = _signerAddress;
        airdropAmountPerWallet = _airdropAmountPerWallet;
        airdropToken = IERC20(_airdropToken);
    }

    function withdrawTokens(bytes memory signature) public {
        address beneficiary = msg.sender;

        require(checkSignature(signature, beneficiary) == true, "Not eligible to claim tokens!");
        require(wasClaimed[beneficiary] == false, "Already claimed!");

        airdropToken.transfer(beneficiary, airdropAmountPerWallet);

        emit TokensAirdropped(beneficiary, airdropAmountPerWallet);
        wasClaimed[msg.sender] = true;
    }

    function getSigner(bytes memory signature, address beneficiary) public view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(beneficiary));
        bytes32 messageHash = hash.toEthSignedMessageHash();
        return messageHash.recover(signature);
    }

    function checkSignature(bytes memory signature, address beneficiary) public view returns (bool) {
        return getSigner(signature, beneficiary) == signerAddress;
    }

}
