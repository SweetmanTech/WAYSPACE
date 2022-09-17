// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/lib/AlbumMetadata.sol";

contract PuzzleDropTest is Test, AlbumMetadata {
    function setUp() public {}

    function testCan_setSongURI() public {
        _setSongURI(1, 1, 1);
        assertEq(songIds[1], 1);
        assertEq(songCount[1], 1);

        _setSongURI(1, 10, 2);
        assertEq(songCount[2], 10);
        for (uint256 i = 1; i < 11; i++) {
            assertEq(songIds[i], 2);
        }

        _setSongURI(1, 100, 12);
        assertEq(songCount[12], 100);
        for (uint256 i = 1; i < 100; i++) {
            assertEq(songIds[i], 12);
        }
    }
}
