require 'yaml'
require_relative "pieces.rb"

class ChessBoard
    attr_accessor :board, :turn, :check, :won

    def initialize()
        @board = Array.new(8) { Array.new(8, nil) }
        @turn = 0 # 0 = white, 1 = black
        @check = false
        @won = false
    end

    def setup_board
        # White Pawns
        row = 1
        8.times do |column|
            @board[column][row] = Pawn.new(column, row, 'w')
        end
        
        # Other White Pieces
        row = 0
        @board[0][row] = Rook.new(0, row, 'w')
        @board[1][row] = Knight.new(1, row, 'w')
        @board[2][row] = Bishop.new(2, row, 'w')
        @board[3][row] = Queen.new(3, row, 'w')
        @board[4][row] = King.new(4, row, 'w')
        @board[5][row] = Bishop.new(5, row, 'w')
        @board[6][row] = Knight.new(6, row, 'w')
        @board[7][row] = Rook.new(7, row, 'w')

        # Black Pawns
        row = 6
        8.times do |column|
            @board[column][row] = Pawn.new(column, row, 'b')
        end

        # Other Black Pieces
        row = 7
        @board[0][row] = Rook.new(0, row, 'b')
        @board[1][row] = Knight.new(1, row, 'b')
        @board[2][row] = Bishop.new(2, row, 'b')
        @board[3][row] = Queen.new(3, row, 'b')
        @board[4][row] = King.new(4, row, 'b')
        @board[5][row] = Bishop.new(5, row, 'b')
        @board[6][row] = Knight.new(6, row, 'b')
        @board[7][row] = Rook.new(7, row, 'b')
    end

    def get_piece_symbol(piece)
        if piece.is_a?(Pawn)
            return piece.color + "p"
        elsif piece.is_a?(Rook)
            return piece.color + "r"
        elsif piece.is_a?(Knight)
            return piece.color + "k"
        elsif piece.is_a?(Bishop)
            return piece.color + "b"
        elsif piece.is_a?(Queen)
            return piece.color + "Q"
        elsif piece.is_a?(King)
            return piece.color + "K"
        else
            return "  "
        end
    end

    def display_board
        print "\n\n      A    B    C    D    E    F    G    H"
        print "\n\n    -----------------------------------------\n"
        8.downto(1) do |row|
            print row.to_s + "   | "
            8.times do |column|
                print get_piece_symbol(@board[column][row - 1]) + " | "
            end
            print "   " + row.to_s
            print "\n    -----------------------------------------\n"
        end
        print "\n      A    B    C    D    E    F    G    H\n\n\n"
        puts "Check!" if @check == true
        check = false
    end

    def change_turn
        @turn == 0 ? (@turn = 1) : (@turn = 0)
    end

    def choose_piece
        @turn == 0 ? (print "White") : (print "Black")
        print ", choose a square with a piece: "
        gets.chomp
    end
    
    def choose_move
        print "Choose a valid move for the piece: "
        gets.chomp
    end

    def get_coord(pos)
        column_hash = {
            "A" => 0,
            "B" => 1,
            "C" => 2,
            "D" => 3,
            "E" => 4,
            "F" => 5,
            "G" => 6,
            "H" => 7
        }
        column = column_hash[pos[0]]
        row = (pos[1].to_i) - 1
        return Point.new(column, row)
    end

    def find_king
        @board.each do |column|
            column.each do |space|
                return space if space.is_a?(King) && space.get_color != @turn
            end
        end
        return nil
    end

    def check
        king = find_king
        @board.each do |column|
            column.each do |space|
                if space != nil && space.get_color == @turn
                   space.get_moves(board)
                   @check = true if space.validMoves.include?(king.pos)
                end
            end
        end
    end

    def checkmate?
        return false unless @check
        king = find_king
        king.get_moves(@board)
        kingMoves = king.validMoves
        @board.each do |column|
            column.each do |space|
                if space != nil && space.get_color != @turn
                    space.get_moves(@board)
                    kingMoves -= space.validMoves
                    return true if kingMoves.empty?
                end
            end
        end
        return false
    end

    def move_piece
        # choose piece
        piece = nil
        loop do
            input = choose_piece
            if input.match(/^[A-Ha-h][1-8]$/)
                coord = get_coord(input)
                if @board[coord.x][coord.y] == nil
                    puts "No piece there, try again."
                else
                    if @board[coord.x][coord.y].get_color == @turn
                        piece = @board[coord.x][coord.y]    
                        piece.get_moves(board)
                        if piece.validMoves == []
                            puts "Piece has no moves, pick another piece."
                        else
                            break
                        end
                    else
                        puts "Not your piece, try again."
                    end
                end
            else
                puts "Invalid input, try again."
            end
        end

        #choose move
        move = nil
        loop do
            input = choose_move
            if input.match(/^[A-Ha-h][1-8]$/)
                coord = get_coord(input)
                if piece.is_a?(Pawn)
                    if (@board[coord.x][coord.y] == nil && piece.valid_move?(coord)) || (@board[coord.x][coord.y] != nil && @board[coord.x][coord.y].get_color != @turn && piece.valid_cap?(coord))
                            prev = piece.pos
                            @board[coord.x][coord.y] = piece
                            piece.pos = coord
                            @board[prev.x][prev.y] = nil
                            piece.first = false
                            break
                    else
                        puts "Invalid move, try again."
                    end
                elsif piece.is_a?(King) || piece.is_a?(Rook)
                    if piece.valid_move?(coord)
                        piece.castle = false
                        prev = piece.pos
                        @board[coord.x][coord.y] = piece
                        piece.pos = coord
                        @board[prev.x][prev.y] = nil
                        break
                    elsif piece.castleMoves.include?(coord)
                        prev = piece.pos
                        @board[coord.x][coord.y] = piece
                        piece.pos = coord
                        if coord.x < prev.x
                            @board[3][coord.y] = @board[0][coord.y] 
                            @board[3][coord.y].castle = false
                            @board[0][coord.y] = nil
                        else
                            @board[5][coord.y] = @board[7][coord.y] 
                            @board[5][coord.y].castle = false
                            @board[7][coord.y] = nil
                        end
                        @board[prev.x][prev.y] = nil
                        break
                    else
                        puts "Invalid move, try again."
                    end
                else
                    if piece.valid_move?(coord)
                        prev = piece.pos
                        @board[coord.x][coord.y] = piece
                        piece.pos = coord
                        @board[prev.x][prev.y] = nil
                        break
                    else
                        puts "Invalid move, try again."
                    end
                end
            else
                puts "Invalid input, try again."
            end
        end
        check
    end

=begin
    def save_game
        File.open("./saved.yaml", "w") do |file|
            file.puts Yaml.dump(self)
        end
        print "Game saved.\n"
        exit
    end

    def load_game
        self = Yaml::load((File.open("./saved.yaml", "r")))
        File.delete("./saved.yaml")
    end
=end
    def start_game
=begin
        if File.exists?("./saved.yaml")
            load_game
        else
=end
            setup_board
            until @won
                display_board
                @won = true if find_king == nil
                move_piece
                if checkmate?
                    @won = true
                elsif find_king == nil
                    @won = true
                else
                    change_turn
                end
            end
            @turn == 0 ? (puts "White wins!") : (puts "Black wins!")
       # end
    end
end

ChessBoard.new.start_game
