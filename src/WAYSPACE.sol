// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./lib/PuzzleDrop.sol";
import "./lib/AlbumMetadata.sol";
import "./lib/TeamSplits.sol";
import "./interfaces/IMetadataRenderer.sol";

contract WAYSPACE is AlbumMetadata, PuzzleDrop, TeamSplits {
    constructor(string[] memory _musicMetadata, address _dropMetadataRenderer)
        PuzzleDrop("WAYSPACE", "JACKIE")
        AlbumMetadata(_dropMetadataRenderer, _musicMetadata)
    {}

    /// @notice This allows the user to purchase the latest drop
    /// at the given price in the contract.
    function purchase(uint256 _quantity)
        external
        payable
        onlyPublicSaleActive
        onlyValidPrice(singlePrice, _quantity)
        returns (uint256)
    {
        return purchaseTrack(_quantity, dropsCreated());
    }

    /// @notice This allows the user to purchase a specific drop
    /// at the given price in the contract.
    function purchaseTrack(uint256 _quantity, uint8 _trackNumber)
        public
        payable
        onlyPublicSaleActive
        onlyValidPrice(singlePrice, _quantity)
        onlyTrackSaleActive(_trackNumber)
        returns (uint256)
    {
        uint256 firstMintedTokenId = _purchase(_quantity, _trackNumber);
        updateMetadataRenderer(dropsCreated());
        _paySplit(_trackNumber, address(this).balance);
        return firstMintedTokenId;
    }

    /// @notice This allows the user to purchase a edition edition
    /// at the given price in the contract.
    function purchaseBundle(uint256 _quantity)
        external
        payable
        onlyPublicSaleActive
        onlyValidPrice(bundlePrice, _quantity)
        returns (uint256)
    {
        uint8 songIdTwo = dropsCreated();
        uint8 songIdOne = songIdTwo - 1;
        uint256 firstMintedTokenId = _purchase(_quantity, songIdOne);
        _purchase(_quantity, songIdTwo);
        _paySplit(songIdOne, address(this).balance / 2);
        _paySplit(songIdTwo, address(this).balance);
        return firstMintedTokenId;
    }

    /// @notice This allows the user to purchase a edition edition
    /// at the given price in the contract.
    function _purchase(uint256 quantity, uint8 _songId)
        internal
        onlyValidSongId(_songId)
        returns (uint256)
    {
        uint256 start = _nextTokenId();
        _mint(msg.sender, quantity);
        _setSongURI(start, quantity, _songId);

        emit Sale({
            to: msg.sender,
            quantity: quantity,
            pricePerToken: singlePrice,
            firstPurchasedTokenId: start
        });
        return start;
    }

    /// @notice Returns the Uniform Resource Identifier (URI) for `tokenId` token.
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(IERC721A, ERC721A)
        returns (string memory)
    {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        uint8 songId = songIds[tokenId];
        return songURI(songId);
    }

    /**
     * @dev Hook that is called after a set of serially-ordered token IDs
     * have been transferred. This includes minting.
     * And also called after one token has been burned.
     *
     * `startTokenId` - the first token ID to be transferred.
     * `quantity` - the amount to be transferred.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
     * transferred to `to`.
     * - When `from` is zero, `tokenId` has been minted for `to`.
     * - When `to` is zero, `tokenId` has been burned by `from`.
     * - `from` and `to` are never both zero.
     */
    function _afterTokenTransfers(
        address,
        address,
        uint256,
        uint256
    ) internal override {
        uint256[] memory _ownedTokens = tokensOfOwner(msg.sender);
        if (_ownedTokens.length >= 12) {
            if (puzzleCompleted(_ownedTokens) && !ownsFullAlbum(_ownedTokens)) {
                _airdropFullAlbum();
            }
        }
    }

    /// @notice airdrops the full album
    function _airdropFullAlbum() internal {
        uint256 start = _nextTokenId();
        _setSongURI(start, 1, 13);
        _mint(msg.sender, 1);
    }
}
