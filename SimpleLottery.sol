// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery {

    address public lotteryOwner;
    address[] public lotteryBuyers;

    constructor() {
        lotteryOwner = msg.sender;  // address of the person who deployed this contract
    }

    function enter() public payable {
        require(msg.value > 0.01 ether);         // 'enter' function is allowed users to buy tickets
        lotteryBuyers.push(msg.sender);               // add address of the sender to the LotteryBuyers array
    }

    function random() private view returns(uint) {
           return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, lotteryBuyers.length)));   // It generates a random number using the block difficulty, block timestamp, no.of players
    }

    function totalLotteryBuyers() public view returns(uint) {
              return lotteryBuyers.length;
    }

    
    function pickWinner() public restricted {                             // 'pickWinner' function => It selects a winner randomly from the index and transfers the contract balance to the winner
        uint index = random() % lotteryBuyers.length;                            
        payable(lotteryBuyers[index]).transfer(address(this).balance);
        lotteryBuyers = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == lotteryOwner);            // It restricts access to the 'pickWinner' function to the LotteryOwner
        _;
    }


}