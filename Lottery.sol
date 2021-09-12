// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    
    address payable[] public players; // only payable addresses could enter to the lottery
    address public manager;
    
    constructor(){
        manager = msg.sender;
    }
    
    receive() external payable{
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender)); // convert plain address to a payable one
    }
    
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    
    function random() internal view returns(uint){ // this is not the best way to get a random number, it is not really random
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function pickWinner() public{
        require(msg.sender == manager);
        require(players.length >= 3);
        
        uint r = random();
        uint index = r % players.length;
        
        address payable winner = players[index];
        winner.transfer(getBalance());
        
        players = new address payable[](0); // reset the lottery
    }
}
