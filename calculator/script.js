function add(num1, num2)
{
    return Number(num1) + Number(num2);
}

function subtract(num1, num2)
{
    return num1 - num2;
}

function multiply(num1, num2)
{
    return num1 * num2;
}

function divide(num1, num2)
{
    if (num2 == 0)
    {
        return '3104558'; 
    }
    else
    {
        return num1 / num2;
    }
}

function operate(num1, num2, operator)
{
    switch (operator)
    {
        case '+':
            return add(num1, num2);
        case '-':
            return subtract(num1, num2);
        case '*':
            return multiply(num1, num2);
        case '/':
            return divide(num1, num2);
        default:
            console.log('this should never happen');
    }
}

let result = document.querySelector('#lower-display');
let buffer = document.querySelector('#upper-display');
let num1 = ''; 
let num2 = '';
let operator = '';
let state = 0; // 0 = input first number, 1 = switch input to first, 2 = input second number, 3 = switch input to second

function inputNumber()
{
    let digit = this.textContent;
    if (digit == '.')
    {
        document.getElementById('decimal').disabled = true;
    }
    if (state == 1 || state == 3)
    {
        result.textContent = '';
        if (state == 1)
        {
            num1 = '';
        }
        else
        {
            num2 = '';
        }
    }

    if (result.textContent == '' && digit == '.')
    {  
        result.textContent = '0.';   
    }
    else
    {
        result.textContent += digit;
    }

    if (state <= 1)
    {   
        if (digit == '.' && num1 == '')
        {
            num1 = '0.';
        }
        else
        {
            num1 += digit;
        }
        state = 0;
    }
    else if (state >= 2)
    {
        if (digit == '.' && num2 == '')
        {
            num2 = '0.';
        }
        else
        {
            num2 += digit;
        }
        state = 2;
    }
}

const numbers = Array.from(document.querySelectorAll('.number'));
numbers.forEach(number => number.addEventListener('click', inputNumber));

function addOperator(e)
{
    document.getElementById('decimal').disabled = false;
    let op = this.textContent;
    switch (op)
    {
        case '÷':
            op = '/';
            break;
        case 'x':
            op = '*';
            break;
        case '-':
            op = '-';
            break;
        case '+':
            op = '+';
            break;
        default:
            console.log('This should never happen');
            break;
    }
    if (state <= 1)
    {
        operator = op;
        num2 = '';
    }
    else if(state > 1)
    {
        if (num2 == '')
        {
            operator = op;
        }
        else
        {
            num1 = operate(num1, num2, operator);
            operator = op;
            num2 = '';
        }
    }
    state = 3;
    buffer.textContent = num1 + ' ' + op;
}

const signs = Array.from(document.querySelectorAll('.operation'));
signs.forEach(sign => sign.addEventListener('click', addOperator));

let clear = document.querySelector('#clear');
clear.addEventListener('click', function (e) {
    document.getElementById('decimal').disabled = false;
    num1 = '';
    num2 = '';
    operator = '';
    result.textContent = '';
    buffer.textContent = '';
    state = 0;
});

let del = document.querySelector('#delete');
del.addEventListener('click', function (e) {
    if (state <= 1)
    {
        if (num1.length == 0)
        {
            num1 = '';
            result.textContent = '0';
        }
        else
        {
            num1 = num1.substring(0, num1.length - 1);
            result.textContent = num1;
        }
    }
    else
    {
        if (num2.length == 0)
        {
            num2 = '';
            result.textContent = '0';
        }
        else
        {
            num2 = num2.substring(0, num2.length - 1);
            result.textContent = num2;
        }
    }
});

let equal = document.querySelector('#equal');
equal.addEventListener('click', function (e) {
    if (num1 == '')
    {
        return 0;
    }
    if (operator == '')
    {
        return num1;
    }
    if (num2 == '')
    {
        num2 = num1;
    }
    let answer = operate(num1, num2, operator);
    result.textContent = answer;
    buffer.textContent = num1 + ' ' + operator + ' ' + num2 + ' =';
    num1 = answer;
    //num2 = '';
    //operator = '';
    state = 1;
});
