class Board

    @@turn = 2 #1 = player 1, 2 = player 2
    @@winner = 0 #0 = none, 1 = player 1, 2 = player 2
    @@spaces = [[0, 0, 0], [0, 0, 0], [0, 0, 0]] #0 = empty, 1 = X, 2 = 0

    def symbol(space)
        case space
        when 1
            return "X"
        when 2
            return "0"
        else
            return " "
        end
    end

    def display_board
        i = 0
        for row in @@spaces
            print symbol(row[0]) + "|" + symbol(row[1]) + "|" + symbol(row[2]) + "\n"
            if i < 2
                print "-----\n"
            end
            i += 1
        end
    end

    def whowon(winsymbol)
        case winsymbol
        when 1
            @@winner = 1
        when 2
            @@winner = 2
        else
            @@winner = 0
        end
    end

    def won?
        #loop tests horizontals and verticals
        3.times do |number|
            if @@spaces[number][0] == @@spaces[number][1] && @@spaces[number][0] == @@spaces[number][2]
                whowon(@@spaces[number][0])
            elsif @@spaces[0][number] == @@spaces[1][number] && @@spaces[0][number] == @@spaces[2][number]
                whowon(@@spaces[0][number])
            end
            break if @@winner != 0
        end

        #tests diagonals
        if @@spaces[0][0] == @@spaces[1][1] && @@spaces[0][0] == @@spaces[2][2]
            whowon(@@spaces[0][0])
        elsif @@spaces[0][2] == @@spaces[1][1] && @@spaces[0][2] == @@spaces[2][0]
            whowon(@@spaces[0][2])
        end
        
        if @@winner != 0
            return true
        else
            return false
        end
    end

    def set?(player, place)
        if @@spaces[place/3][place%3] == 0
            if player == 1
                @@spaces[place/3][place%3] = 1
            elsif player == 2
                @@spaces[place/3][place%3] = 2
            end
            return true
        else
            puts "Position already taken."
            return false
        end
    end

    def get_choice
        display_board
        loop do
            choice = 0
            print "Player " + @@turn.to_s +  ", enter position(1-9): "
            choice = gets.to_i
            while choice < 1 && choice > 9
                display_board
                print "Invalid position, try again: "
                choice = gets.to_i
            end
            break if set?(@@turn, choice - 1)
        end
    end

    def switch_player
        if @@turn == 1
            @@turn = 2
        else
            @@turn = 1
        end
    end

    def get_player
        return @@turn
    end
end


board = Board.new

until board.won?
    board.switch_player
    board.get_choice
end

board.display_board
p "Player " + board.get_player.to_s + " wins!"
