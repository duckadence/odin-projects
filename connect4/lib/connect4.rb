class ConnectFour

    attr_accessor :board, :turn, :won

    def initialize()
        @board = Array.new(7) { Array.new(6, 0) }
        @turn = 0   #Player 1 = 1, Player 2 = 2
        @won = false
    end

    def display_board()
        print '  '
        7.times do |num|
            print (num + 1).to_s + '   '
        end
        print "\n"
        5.downto(0) do |row|
            print '| '
            7.times do |column|
                piece = @board[column][row]
                if piece == 0
                    print ' '
                elsif piece == 1
                    print 'X'
                elsif piece == 2
                    print 'O'
                end
                print ' | '
            end
            print "\n-----------------------------\n"
        end
    end

    def switch_turn()
        if @turn == 0
            @turn = 1
        elsif @turn == 1
            @turn = 2
        elsif @turn == 2
            @turn = 1
        end
    end

    def player_input
        print "Player #{@turn}, enter column number: "
        return gets.chomp 
    end

    def get_column()
        loop do
            column = player_input
            if column.match(/^[1-7]$/)
                column = column.to_i
                column -= 1
                if @board[column.to_i].include?(0)
                    add_piece(column.to_i)
                    break
                else
                    puts "Column is full, try again."
                end
            else
                puts "Invalid column, try again."
            end
        end
    end

    def add_piece(column)
        @board[column].each_with_index do |slot, index|
            if slot == 0
                @board[column][index] = turn
                check_win(column, index)
                switch_turn unless @won
                break
            end
        end
    end

    def check_vertical(column, row)
        count = 0
        if row >= 3
            row.downto(row - 3) do |num|
                break if @board[column][num] != @turn
                count += 1
                @won = true if count == 4
            end
        end
    end

    def check_horizontal(column, row)
        start = column
        loop do
            if @board[start][row] != @turn
                start += 1
                break
            else
                start == 0 ? break : (start -= 1)
            end
        end
        start.upto(start + 3) do |num|
            break if num == 7
            break if @board[num][row] != @turn
            @won = true if num == (start + 3)
        end
    end

    def check_diagonal(column, row)
        #/
        startColumn = column
        startRow = row
        loop do
            if @board[startColumn][startRow] != @turn
                startColumn += 1
                startRow += 1
                break
            else
                if startColumn == 0 || startRow == 0
                    break
                else
                    startColumn -= 1
                    startRow -= 1
                end
            end
        end
        
        4.times do |num|
            break if @board[startColumn][startRow] != @turn
            @won = true if num == 3
            break if startColumn == 6 || startRow == 5
            startColumn += 1
            startRow += 1
        end

        unless @won
            #\
            startColumn = column
            startRow = row

            loop do
                if @board[startColumn][startRow] != @turn
                    startColumn += 1
                    startRow -= 1
                    break
                else
                    if startColumn == 0 || startRow == 5
                        break
                    else
                        startColumn -= 1
                        startRow += 1
                    end
                end
            end
            4.times do |num|
                break if @board[startColumn][startRow] != @turn
                @won = true if num == 3
                break if startColumn == 6 || startRow == 0
                startColumn += 1
                startRow -= 1
            end
        end
    end

    def check_win(column, row)
        check_vertical(column, row)
        check_horizontal(column, row) unless @won
        check_diagonal(column, row) unless @won
    end

    def end_game()
        display_board
        print "Player #{@turn} wins!\n"
    end

    def start_game()
        switch_turn
        until won
            display_board
            get_column
        end
        end_game
    end
end

#ConnectFour.new.start_game
