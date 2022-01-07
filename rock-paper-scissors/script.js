function computerPlay()
{
    let rand = Math.floor(Math.random() * 3) + 1;

    switch(rand)
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


