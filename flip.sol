// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract CoinFlip {
    address public owner;
    uint256 public contractBalance;

    event FlipResult(address indexed player, uint256 betAmount, bool win);

    constructor() {
        owner = msg.sender;
    }

     function flip() public payable {
        require(address(this).balance >= msg.value * 2, "Contract has insufficient funds.");

        bool win = random() == 1;
        if (win) {
            payable(msg.sender).transfer(msg.value * 2);
        }

        contractBalance = address(this).balance;
        emit FlipResult(msg.sender, msg.value, win);
    }

    function random() private view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 2);
    }

    function fundContract() public payable {
        contractBalance = address(this).balance;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can withdraw.");
        require(amount <= address(this).balance, "Insufficient balance.");

        payable(owner).transfer(amount);
        contractBalance = address(this).balance;
    }
    receive() external payable {
        contractBalance = address(this).balance;
    }
}