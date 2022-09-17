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

    function testCan_weekNumber() public {
        pd = new PuzzleDrop("WAYSPACE", "JACKIE");
        assertEq(pd.weekNumber(), 1);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.weekNumber(), 2);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.weekNumber(), 3);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.weekNumber(), 4);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.weekNumber(), 5);

        vm.warp(block.timestamp + pd.secondsBetweenDrops());
        assertEq(pd.weekNumber(), 6);

        vm.warp(block.timestamp + 100 * pd.secondsBetweenDrops());
        assertEq(pd.weekNumber(), 106);
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
}
