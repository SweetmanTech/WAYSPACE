// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WAYSPACE.sol";

contract WayspaceTest is Test {
    function setUp() public {}

    WAYSPACE ws;

    function testFail_blockPurchaseBundlePresale() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        vm.warp(ws.publicSaleStart() - 1);
        ws.purchaseBundle{value: 0.0333 ether}(1);
    }

    function testFail_blockPurchaseBundlePostSale() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        vm.warp(ws.publicSaleEnd());
        ws.purchaseBundle{value: 0.0333 ether}(1);
    }

    function testCan_purchaseFirstBundle() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        uint256 firstMintedTokenId = ws.purchaseBundle{value: 0.0333 ether}(1);
        assertEq(firstMintedTokenId, 1);
        assertEq(ws.songCount(1), 1);
        assertEq(ws.songCount(2), 1);

        vm.warp(block.timestamp + ws.secondsBetweenDrops() - 1);
        firstMintedTokenId = ws.purchaseBundle{value: 0.0666 ether}(2);
        assertEq(firstMintedTokenId, 3);
        assertEq(ws.songCount(1), 3);
        assertEq(ws.songCount(2), 3);
    }

    function testCan_purchaseLastBundle() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);
        vm.warp(block.timestamp + 5 * ws.secondsBetweenDrops() - 1);
        uint256 firstMintedTokenId = ws.purchaseBundle{value: 0.0999 ether}(3);
        assertEq(firstMintedTokenId, 1);
        assertEq(ws.songCount(9), 3);
        assertEq(ws.songCount(10), 3);

        vm.warp(block.timestamp + 1);
        firstMintedTokenId = ws.purchaseBundle{value: 0.0999 ether}(3);
        assertEq(firstMintedTokenId, 7);
        assertEq(ws.songCount(11), 3);
        assertEq(ws.songCount(12), 3);

        vm.warp(block.timestamp + 100 * ws.secondsBetweenDrops());
        firstMintedTokenId = ws.purchaseBundle{value: 0.0999 ether}(3);
        assertEq(firstMintedTokenId, 13);
        assertEq(ws.songCount(11), 6);
        assertEq(ws.songCount(12), 6);
    }

    function testCan_purchaseMultipleBundles() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);
        ws.purchaseBundle{value: 0.0999 ether}(3);
        assertEq(ws.songCount(1), 3);
        assertEq(ws.songCount(2), 3);

        vm.warp(block.timestamp + ws.secondsBetweenDrops());
        ws.purchaseBundle{value: 0.0999 ether}(3);
        assertEq(ws.songCount(3), 3);
        assertEq(ws.songCount(4), 3);

        vm.warp(block.timestamp + ws.secondsBetweenDrops() - 1);
        ws.purchaseBundle{value: 0.0666 ether}(2);
        assertEq(ws.songCount(3), 5);
        assertEq(ws.songCount(4), 5);

        vm.warp(block.timestamp + ws.secondsBetweenDrops() + 1);
        ws.purchaseBundle{value: 0.0999 ether}(3);
        assertEq(ws.songCount(7), 3);
        assertEq(ws.songCount(8), 3);

        vm.warp(block.timestamp + ws.secondsBetweenDrops());
        ws.purchaseBundle{value: 0.0999 ether}(3);
        assertEq(ws.songCount(1), 3);
        assertEq(ws.songCount(2), 3);
        assertEq(ws.songCount(3), 5);
        assertEq(ws.songCount(4), 5);
        assertEq(ws.songCount(5), 0);
        assertEq(ws.songCount(6), 0);
        assertEq(ws.songCount(7), 3);
        assertEq(ws.songCount(8), 3);
    }
}
