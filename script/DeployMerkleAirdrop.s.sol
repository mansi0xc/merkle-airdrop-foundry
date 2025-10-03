// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script } from "forge-std/Script.sol";
import { MerkleAirdrop } from "src/MerkleAirdrop.sol";
import { CivetToken } from "src/CivetToken.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 private s_merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 private s_amountToTransfer = 4 * 25 ether;

    function deployMerkleAirdrop() public returns (MerkleAirdrop, CivetToken) {
        vm.startBroadcast();
        CivetToken token = new CivetToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRoot, address(token));
        // Fund the airdrop contract so it can distribute tokens during claims
        token.mint(address(airdrop), s_amountToTransfer);
        vm.stopBroadcast();
        return (airdrop, token);
    }

    function run() external returns (MerkleAirdrop, CivetToken) {
        return deployMerkleAirdrop();
    }
}