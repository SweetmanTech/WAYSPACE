// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "src/lib/TeamSplits.sol";

contract TeamSplitsTest is Test, TeamSplits {
    function setUp() public {}

    function testCan_getListOfRecipients() public {
        assertEq(recipients().length, 14);
    }

    function testFail_payout0thSplit() public {
        /// @dev starts at index 1.
        _paySplit(0, 100);
    }

    function testFail_payout15thSplit() public {
        /// @dev there are 14 recipients.
        _paySplit(15, 100);
    }

    function testCan_payoutSplit() public {
        for (uint8 i = 0; i < recipients().length; i++) {
            assertEq(address(recipients()[i]).balance, 0);
        }

        for (uint8 i = 0; i < recipients().length; i++) {
            uint256 preBalance = address(recipients()[i]).balance;
            _paySplit(i + 1, 100);
            assertEq(address(recipients()[i]).balance, preBalance + 100);
        }
    }
}
