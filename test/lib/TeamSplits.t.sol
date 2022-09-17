// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/lib/TeamSplits.sol";

contract TeamSplitsTest is Test {
    TeamSplits ts;

    function setUp() public {
        ts = new TeamSplits();
    }

    function testCan_publicSaleStart() public {
        assertEq(ts.recipients().length, 14);
    }
}
