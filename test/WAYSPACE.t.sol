// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/WAYSPACE.sol";

contract WayspaceTest is Test {
    function setUp() public {}

    WAYSPACE ws;

    function testCan_purchaseBundle() public {
        string[] memory _musicMetadata = new string[](12);
        for (uint32 i = 0; i < _musicMetadata.length; i++) {
            _musicMetadata[i] = "MUSIC_METADATA";
        }
        ws = new WAYSPACE(_musicMetadata);
        uint256 firstMintedTokenId = ws.purchaseBundle{value: 0.0333 ether}(1);
        assertEq(firstMintedTokenId, 2);
    }
}
