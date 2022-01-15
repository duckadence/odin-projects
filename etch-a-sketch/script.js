function addBoxes(length)
{
    for (let count = 0; count < length; count++)
    {
        const column = document.createElement('div');
        column.classList.add('column');
        for (let count = 0; count < length; count++)
        {
            const box = document.createElement('div');
            box.classList.add('box');
            column.appendChild(box);
        }
        grid.appendChild(column);
    }
}

function sketch(e)
{
    this.style.cssText = 'background: gray';
}

const grid = document.querySelector('.container');
const reset = document.querySelector('#reset');
const size = document.querySelector('#size');

addBoxes(16);

const boxes = document.querySelectorAll('.box');
boxes.forEach(box => box.addEventListener('mouseenter', sketch));

reset.addEventListener('click', function(e) {
    for (let count = 0; count < boxes.length; count++)
    {
        boxes[count].style.cssText = 'background: white';
    }
    
});

size.addEventListener('click', function(e) {
    while (grid.firstChild)
    {
        grid.removeChild(grid.firstChild);
    }

    let length = prompt('Enter grid length (1 - 100):', '');
    while(true)
    {
        if (length != null && length <= 100 && length >= 1)
        {
            addBoxes(length);
            break;
        }
        else
        {
            length = prompt('Invalid input, please try again:', '');
        }
    }
    
    reset.addEventListener('click', function(e) {
        for (let count = 0; count < boxes.length; count++)
        {
            boxes[count].style.cssText = 'background: white';
        }
        
    });
    const boxes = document.querySelectorAll('.box');
    boxes.forEach(box => box.addEventListener('mouseenter', sketch));
});

