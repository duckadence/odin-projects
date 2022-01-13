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
            if (computerValue == 3)
            {
                playerValue = 4;
            }
            else
            {
                playerValue = 1;
            }
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

    let msg = document.createElement("div");
    let msgBox = document.querySelector(".msg");
    while (msgBox.firstChild)
    {
        msgBox.removeChild(msgBox.firstChild);
    }

    if (playerValue < computerValue)
    {
        let winMessage = "You Win! " + playerSelection + " beats " + computerSelection;

        msg.textContent = winMessage;
        msgBox.appendChild(msg);

        return 0;
    }
    else if (playerValue > computerValue)
    {
        let loseMessage = "You Lose! " + computerSelection + " beats " + playerSelection;
        
        msg.textContent = loseMessage;
        msgBox.appendChild(msg);

        return 1;
    }
    else
    {
        msg.textContent = "Tie!";
        msgBox.appendChild(msg);

        return 2;
    }
}

function game(choice)
{
    let playerScoreDisplay = document.querySelector(".player-score");
    let computerScoreDisplay = document.querySelector(".cp-score");

    playerScoreDisplay.textContent = playerScore;
    computerScoreDisplay.textContent = computerScore;

    let result = 0;

    let playerSelection = choice;
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
        case 2:
            break;
        default:
            console.log("This should never happen");
            break;
    }

    playerScoreDisplay.textContent = playerScore;
    computerScoreDisplay.textContent = computerScore;

    if (playerScore == 5 || computerScore == 5)
    {
        let msg = document.createElement("div");    
        let msgBox = document.querySelector(".msg");
        while (msgBox.firstChild)
        {
            msgBox.removeChild(msgBox.firstChild);
        }

        if (playerScore > computerScore)
        {
            msg.textContent = "You win the game!";
            msgBox.appendChild(msg);
        }
        else
        {
            msg.textContent = "You lose idiot!";
            msgBox.appendChild(msg);
        }
    }
}


let playerScore = 0;
let computerScore = 0;

const scissors = document.querySelector("#scissors");
const paper = document.querySelector("#paper");
const rock = document.querySelector("#rock");

scissors.addEventListener("click", function (e) {
    game("scissors");
    scissors.classList.add("clicked");
});

paper.addEventListener("click", function (e) {
    game("paper");
    paper.classList.add("clicked");
});

rock.addEventListener("click", function (e) {
    game("rock");
    rock.classList.add("clicked");
});

function removeTransition(e) {
    scissors.classList.remove("clicked");
    paper.classList.remove("clicked");
    rock.classList.remove("clicked");
}

const buttons = document.querySelectorAll("button");
buttons.forEach(button => button.addEventListener("transitionend", removeTransition));
