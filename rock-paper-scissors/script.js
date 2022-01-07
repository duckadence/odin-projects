function computerPlay()
{
    let rand = Math.floor(Math.random() * 3) + 1;

    switch (rand)
    {
        case 1:
            return "scissors";
        case 2:
            return "paper";
        case 3:
            return "rock";
        default:
            return "foobar";
    }
}

function playRound(playerSelection, computerSelection)
{
    let playerValue,
        computerValue;

    switch (computerSelection)
    {
        case "scissors":
            computerValue = 1;
            break;
        case "paper":
            computerValue = 2;
            break;
        case "rock":
            computerValue = 3;
            break;
    }

    switch (playerSelection)
    {
        case "scissors":
            playerValue = 1;
            break;
        case "paper":
            playerValue = 2;
            break;
        case "rock":
            if (computerValue == 1)
            {
                playerValue = 0;
            }
            else
            {
                playerValue = 3;
            }
            break;
    }

    if (playerValue > computerValue)
    {
        let winMessage = "You Win! " + playerSelection + " beats " + computerSelection;

        console.log(winMessage);

        return 0;
    }
    else if (playerValue < computerValue)
    {
        let loseMessage = "You Lose! " + computerSelection + " beats " + playerSelection;
        
        console.log(loseMessage);

        return 1;
    }
    else if (playerValue == computerValue)
    {
        console.log("Tie!");

        return 2;
    }
}

function game()
{
let playerScore = 0;
let computerScore = 0;
let result = 0;

    for (let round = 0; round < 5; round++)
    {
        let playerSelection = prompt("Choose scissors, paper, or rock: ", "choice here");
        playerSelection = playerSelection.toLowerCase();
        let computerSelection = computerPlay();

        result = playRound(playerSelection, computerSelection);
        
        switch (result)
        {
            case 0:
                playerScore++;
                break;
            case 1:
                computerScore++;
                break;
            default:
                break;
        }
    }

    if (playerScore > computerScore)
    {
        console.log("You win the game!");
    }
    else
    {
        console.log("You lose idiot!");
    }
}

game();
