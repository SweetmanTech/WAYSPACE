// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WAYSPACE.sol";

contract WayspaceTest is Test {
    function setUp() public {}

    WAYSPACE ws;

    /// -----------------------------------------------------------------------
    /// purchase testing
    /// -----------------------------------------------------------------------
    function testFail_blockPurchasePresale() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        vm.warp(ws.publicSaleStart() - 1);
        ws.purchase{value: 0.0222 ether}(1);
    }

    function testFail_blockPurchasePostSale() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        vm.warp(ws.publicSaleEnd());
        ws.purchase{value: 0.0222 ether}(1);
    }

    function testFail_blockPurchaseWrongPrice() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        ws.purchase{value: 0.0221 ether}(1);
        ws.purchase{value: 0.0223 ether}(1);
    }

    function testCan_purchase() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        uint256 firstMintedTokenId = ws.purchase{value: 0.0222 ether}(1);
        assertEq(firstMintedTokenId, 1);
        assertEq(ws.songCount(1), 0);
        assertEq(ws.songCount(2), 1);

        vm.warp(block.timestamp + ws.secondsBetweenDrops() - 1);
        firstMintedTokenId = ws.purchase{value: 0.0444 ether}(2);
        assertEq(firstMintedTokenId, 2);
        assertEq(ws.songCount(1), 0);
        assertEq(ws.songCount(2), 3);
    }

    function testCan_purchaseLastSong() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        vm.warp(block.timestamp + 5 * ws.secondsBetweenDrops() - 1);
        uint256 firstMintedTokenId = ws.purchase{value: 0.0888 ether}(4);
        assertEq(firstMintedTokenId, 1);
        assertEq(ws.songCount(9), 0);
        assertEq(ws.songCount(10), 4);

        vm.warp(block.timestamp + 1);
        firstMintedTokenId = ws.purchase{value: 0.0888 ether}(4);
        assertEq(firstMintedTokenId, 5);
        assertEq(ws.songCount(11), 0);
        assertEq(ws.songCount(12), 4);

        vm.warp(block.timestamp + 100 * ws.secondsBetweenDrops());
        firstMintedTokenId = ws.purchase{value: 0.0888 ether}(4);
        assertEq(firstMintedTokenId, 9);
        assertEq(ws.songCount(11), 0);
        assertEq(ws.songCount(12), 8);
    }

    /// -----------------------------------------------------------------------
    /// bundle testing
    /// -----------------------------------------------------------------------

    function testFail_blockPurchaseBundlePresale() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        vm.warp(ws.publicSaleStart() - 1);
        ws.purchaseBundle{value: 0.0333 ether}(1);
    }

    function testFail_blockPurchaseBundleWrongPrice() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);

        ws.purchaseBundle{value: 0.0332 ether}(1);
        ws.purchaseBundle{value: 0.0334 ether}(1);
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

    /// -----------------------------------------------------------------------
    /// metadataBaseByContract testing - for volfm UI
    /// -----------------------------------------------------------------------
    function testCan_metadataBaseByContract() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = string(abi.encodePacked("MUSIC_METADATA", i));
        }
        ws = new WAYSPACE(_musicMetadata);

        assertEq(ws.metadataBaseByContract(address(this)).base, ws.songURI(2));

        vm.warp(block.timestamp + ws.secondsBetweenDrops());
        assertEq(ws.metadataBaseByContract(address(this)).base, ws.songURI(4));

        vm.warp(block.timestamp + ws.secondsBetweenDrops());
        assertEq(ws.metadataBaseByContract(address(this)).base, ws.songURI(6));

        vm.warp(block.timestamp + ws.secondsBetweenDrops());
        assertEq(ws.metadataBaseByContract(address(this)).base, ws.songURI(8));

        vm.warp(block.timestamp + ws.secondsBetweenDrops());
        assertEq(ws.metadataBaseByContract(address(this)).base, ws.songURI(10));

        vm.warp(block.timestamp + ws.secondsBetweenDrops());
        assertEq(ws.metadataBaseByContract(address(this)).base, ws.songURI(12));

        vm.warp(ws.publicSaleEnd() + 1);
        assertEq(ws.metadataBaseByContract(address(this)).base, ws.songURI(12));
    }
}
