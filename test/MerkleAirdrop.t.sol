// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {CivetToken} from "../src/CivetToken.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop public airdrop;
    CivetToken public token;

    bytes32 public ROOT = 0x59162885dcb346508731ca48791c029f931d71d0d576f65fadf2a430fc890236;
    uint256 public AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = AMOUNT_TO_CLAIM * 4;
    bytes32 proofOne = 0x9e10faf86d92c4c65f81ac54ef2a27cc0fdf6bfea6ba4b1df5955e47f187115b;
    bytes32 proofTwo = 0x8c1fd7b608678f6dfced176fa3e3086954e8aa495613efcd312768d41338ceab;
    bytes32[] public PROOF = [proofOne, proofTwo];
    address user;
    uint256 userPrivKey;

    function setUp() public {
        token = new CivetToken();
        airdrop = new MerkleAirdrop(ROOT, address(token));
        token.mint(token.owner(), AMOUNT_TO_SEND);
        token.transfer(address(airdrop), AMOUNT_TO_SEND);
        (user, userPrivKey) = makeAddrAndKey("user");
    }

    function testUsersCanClaim() public {
        console.log("User address:", user);
        console.log("User private key:", userPrivKey);

        uint256 startingBalance = token.balanceOf(user);
        console.log("User starting balance:", startingBalance);

        vm.prank(user);
        airdrop.claim(user, AMOUNT_TO_CLAIM, PROOF);

        uint256 endingBalance = token.balanceOf(user);
        console.log("User ending balance:", endingBalance);
        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);
    }
}