class Mastermind
    
    @@answer = Array.new
    @@guess = Array.new
    @@hint = Array.new
    @@board = Array.new(12) {Array.new(8)}
    @@tryNumber = 0
    @@condition = 0


    #symbols
    @@square = "\u25A0"
    @@circle = "\u25CF"
    @@cross = "X"

    def generate_answer
        while @@answer.length < 4
            randNum = rand(1 .. 6)
            @@answer << randNum if @@answer.none?(randNum)
        end
    end

    def display_board
        j = 0
        for row in @@board
            i = 0
            if j <= @@tryNumber
                print "| "
                while i < 4
                print row[i].to_s + " "             
                i += 1
                end
                print "| " 
                while i < 8
                print row[i].to_s + " "
                i += 1
                end
                print "|\n"
            end
            j += 1
        end
    end

    def update_board
        i = 0
        while i < 8
            if i < 4
                @@board[@@tryNumber][i] = @@guess[i]
            else
                @@board[@@tryNumber][i] = @@hint[i-4]
            end
            i += 1
        end
    end

    def end_game
        case @@condition #0 = none, 1 = win, 2 = lose
        when 1
            p "Win message"
            return true
        when 2
            p "Lose message"
            return true
        else
            return false
        end
    end

    def compare
        wrong = 0
        circle = Array.new
        square = Array.new
        cross = Array.new
        4.times do |num|
            if @@answer[num] == @@guess[num]
                circle << @@circle
            elsif @@answer.include?(@@guess[num])
                square << @@square
            else
                cross << @@cross
            end
        end

        @@hint = circle + square + cross

        @@condition = 1 if @@answer == @@guess
        @@condition = 2 if @@tryNumber == 11
        update_board
    end

    def get_guess
        @@guess.clear()
        4.times do |number|
            print "Input guess for position #{number + 1}: "
            guess = gets.to_i
            loop do
                while guess < 1 || guess > 6
                    print "Invalid, try again: "
                    guess = gets.to_i
                end
                if @@guess.include?(guess) 
                    guess = 0    
                else
                    @@guess << guess
                    break
                end
            end
        end
        
    end

    def start_game
        generate_answer
        until end_game
            get_guess
            compare
            display_board
            @@tryNumber += 1
        end
    end
end



game = Mastermind.new
game.start_game

