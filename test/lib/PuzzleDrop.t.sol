// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/lib/PuzzleDrop.sol";

contract PuzzleDropTest is Test {
    function setUp() public {}

    PuzzleDrop pd;

    function testCan_publicSaleStart() public {
        pd = new PuzzleDrop("WAYSPACE", "JACKIE");
        uint64 start = pd.publicSaleStart();
        uint64 nowSec = uint64(block.timestamp);
        assertEq(start, nowSec);
    }

    function testCan_publicSaleEnd() public {
        pd = new PuzzleDrop("WAYSPACE", "JACKIE");
        uint64 end = pd.publicSaleEnd();
        uint64 halloween = 1667260799;
        assertEq(end, halloween);
    }

    function testCan_dropsCreated() public {
        pd = new PuzzleDrop("WAYSPACE", "JACKIE");
        assertEq(pd.dropsCreated(), 2);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.dropsCreated(), 4);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.dropsCreated(), 6);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.dropsCreated(), 8);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.dropsCreated(), 10);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.dropsCreated(), 12);

        vm.warp(block.timestamp + 100 * pd.secondsBetweenDrops());
        assertEq(pd.dropsCreated(), 12);
    }

    function testCan_dropsAvailable() public {
        pd = new PuzzleDrop("WAYSPACE", "JACKIE");
        vm.warp(block.timestamp - 1);
        assertEq(pd.dropsAvailable(), 0);

        vm.warp(pd.publicSaleStart());
        assertEq(pd.dropsAvailable(), 2);

        vm.warp(pd.publicSaleStart() + pd.secondsBetweenDrops() * 6);
        assertEq(pd.dropsAvailable(), 12);

        vm.warp(pd.publicSaleEnd());
        assertEq(pd.dropsAvailable(), 0);
    }
}
