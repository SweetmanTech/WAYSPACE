// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "../interfaces/IMetadataRenderer.sol";

contract AlbumMetadata {
    /// @notice mapping from tokenId to songId
    mapping(uint256 => uint8) internal songIds;
    /// @notice mapping from songId to songMetadataURI
    mapping(uint8 => string) internal songURIs;
    /// @notice mapping from songId to number of songs minted
    mapping(uint8 => uint256) public songCount;
    /// @notice Zora Drops Metadata Renderer
    IMetadataRenderer immutable zoraDropMetadataRenderer;

    constructor(address _dropMetadataRenderer, string[] memory _musicMetadata) {
        setupAlbumMetadata(_musicMetadata);
        zoraDropMetadataRenderer = IMetadataRenderer(_dropMetadataRenderer);
        string memory initialBaseURI = _musicMetadata[1];
        string memory initialContractURI = _musicMetadata[1];
        bytes memory initialData = abi.encode(
            initialBaseURI,
            initialContractURI
        );
        zoraDropMetadataRenderer.initializeWithData(initialData);
    }

    /// @notice Returns the Uniform Resource Identifier (URI) for `tokenId` token.
    function songURI(uint8 _songId) public view returns (string memory) {
        return songURIs[_songId];
    }

    /// @notice updates the Song URI mapped to a tokenId
    function _setSongURI(
        uint256 __startTokenId,
        uint256 _quantity,
        uint8 _songId
    ) internal {
        unchecked {
            for (
                uint256 i = __startTokenId;
                i < __startTokenId + _quantity;
                i++
            ) {
                songIds[i] = _songId;
            }
            songCount[_songId] += _quantity;
        }
    }

    /// @notice setup metadata for each song in WAYSPACE
    function setupAlbumMetadata(string[] memory _musicMetadata) internal {
        unchecked {
            for (uint8 i = 1; i <= _musicMetadata.length; i++) {
                songURIs[i] = _musicMetadata[i - 1];
            }
        }
    }

    /// @notice Valid Song ID
    modifier onlyValidSongId(uint8 _songId) {
        require(bytes(songURI(_songId)).length > 0, "song does not exist");
        _;
    }

    /// @notice - returns address of metadata renderer
    function metadataRenderer() external view returns (address) {
        return address(zoraDropMetadataRenderer);
    }

    /// @notice updates zora metadata renderer to latest version
    function updateMetadataRenderer(uint8 _latestSong) internal {
        string memory base = zoraDropMetadataRenderer.tokenURI(1);
        if (
            keccak256(abi.encodePacked(base)) !=
            keccak256(abi.encodePacked(songURI(_latestSong), "1"))
        ) {
            zoraDropMetadataRenderer.updateMetadataBase(
                address(this),
                songURI(_latestSong),
                songURI(_latestSong)
            );
        }
    }

    /// @notice returns if caller already owns Wayspace [Full Album with Lyrics].
    function ownsSongId(uint256[] memory _ownedTokens, uint8 _songId)
        public
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _ownedTokens.length; ) {
            uint8 songId = songIds[_ownedTokens[i]];

            if (songId == _songId) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }
}
