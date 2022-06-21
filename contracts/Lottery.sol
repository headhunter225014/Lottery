pragma solidity ^0.4.17;

contract Lottery {
    //
    address public manager;
    address[] public players;
    //constructor function with assignment of manager
    function Lottery() public {
        manager = msg.sender;
    }
    //function to enter the lottery
    function enter() public payable {
        //minimum of .01 ether to enter
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }

    //function for creating pseudo random number
    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

    //picking winner from players array
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance);
        //cleans the list
        players = new address[](0);
    }

    //modifier for manager requirement, so I don't need to type it twice
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    //getting players array
    function getPlayers() public view returns (address[]) {
        return players;
    }
}   