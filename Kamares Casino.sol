pragma solidity 0.8.12;

contract KamaresCasino {
    mapping (address=>uint) public gameBetInWei;
    mapping (address=>uint) public blockHashesUsedForRandomness;

    function betGame() external payable {
        if (blockHashesUsedForRandomness[msg.sender] == 0) {
            blockHashesUsedForRandomness[msg.sender]=block.number + 2;
            gameBetInWei[msg.sender]=msg.value;
            return;
        }
        require(msg.value==0,"Lottery: Finish current game before starting new one.");
        require(blockhash(blockHashesUsedForRandomness[msg.sender])!=0,"Lottery:Game not ready yet. Block still needs mining first.")
        uint randomNumber=uint(blockhash(blockHashesUsedForRandomness[msg.sender]));

        //Player wins if randomNumber is even. He loses if it is odd.
        if (randomNumber!=0 && randomNumber%2=0) {
            winningPayout= gameBetInWei[msg.sender]*2;
            (bool success,)= msg.sender.call{value: winningPayout}("");
            require(success,"Lottery: Winning payout failed")
        }
        blockHashesUsedForRandomness[msg.sender]=0;
        gameBetInWei[msg.sender]=0;
    }    
}