// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "src/lib/AlbumMetadata.sol";
import "src/lib/ZoraDropMetadataRenderer/DropMetadataRenderer.sol";

contract Metadata is AlbumMetadata {
    constructor(address _metadataRenderer, string[] memory _musicMetadata)
        AlbumMetadata(_metadataRenderer, _musicMetadata)
    {}

    function setSongURI(
        uint256 _startTokenId,
        uint256 _quantity,
        uint8 _songId
    ) public {
        _setSongURI(_startTokenId, _quantity, _songId);
    }

    function songId(uint256 _tokenId) public view returns (uint8) {
        return songIds[_tokenId];
    }

    function songCounts(uint8 _songId) public view returns (uint256) {
        return songCount[_songId];
    }
}

contract AlbumMetadataTest is Test {
    Metadata metadata;
    DropMetadataRenderer dmr;

    /// @notice Struct to store metadata info and update data
    struct MetadataURIInfo {
        string base;
        string extension;
        string contractURI;
        uint256 freezeAt;
    }

    function setUp() public {
        dmr = new DropMetadataRenderer();
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        metadata = new Metadata(address(dmr), _musicMetadata);
    }

    function testCan_setSongURI() public {
        metadata.setSongURI(1, 1, 1);
        assertEq(metadata.songId(1), 1);
        assertEq(metadata.songCounts(1), 1);

        metadata.setSongURI(1, 10, 2);
        assertEq(metadata.songCounts(2), 10);
        for (uint256 i = 1; i < 11; i++) {
            assertEq(metadata.songId(i), 2);
        }

        metadata.setSongURI(1, 100, 12);
        assertEq(metadata.songCounts(12), 100);
        for (uint256 i = 1; i < 100; i++) {
            assertEq(metadata.songId(i), 12);
        }
    }

    function testCan_setZoraDropMetadataRenderer() public {
        assertEq(metadata.metadataRenderer(), address(dmr));
    }
}
