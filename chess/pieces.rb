Point = Struct.new(:x, :y) 

class Piece
    attr_accessor :pos, :validMoves, :color

    def initialize(column, row, color)
        @pos = Point.new(column, row)
        @validMoves = Array.new
        @color = color
    end

    def get_color
        color == 'w' ? (return 0) : (return 1)
    end

    def on_board?
        @pos.x < 0 || @pos.x > 7 || @pos.y < 0 || @pos.y > 7 ? (return false) : (return true)
    end

    def on_board?(point)
        point.x < 0 || point.x > 7 || point.y < 0 || point.y > 7 ? (return false) : (return true)
    end

    def valid_move?(coord)
        return @validMoves.include?(coord)
    end

    def add_points(point1, point2)
        return Point.new(point1.x + point2.x, point1.y + point2.y)
    end
end

class Pawn < Piece
    attr_accessor :first, :captureMoves

    def initialize(column, row, color)
        super(column, row, color)
        @captureMoves = Array.new
        @first = true
    end

    def get_moves(board)
        if get_color == 0
            @validMoves.clear
            @validMoves << Point.new(@pos.x, @pos.y + 2) if @first
            @validMoves << Point.new(@pos.x, @pos.y + 1)

            @captureMoves.clear
            @captureMoves << Point.new(@pos.x + 1, @pos.y + 1) if @pos.x < 7
            @captureMoves << Point.new(@pos.x - 1, @pos.y + 1) if @pos.x > 0
        else
            @validMoves.clear
            @validMoves << Point.new(@pos.x, @pos.y - 2) if @first
            @validMoves << Point.new(@pos.x, @pos.y - 1)

            @captureMoves.clear
            @captureMoves << Point.new(@pos.x + 1, @pos.y - 1) if @pos.x < 7
            @captureMoves << Point.new(@pos.x - 1, @pos.y - 1) if @pos.x > 0
        end
    end

    def valid_cap?(coord)
        return @captureMoves.include?(coord)    
    end
end

class Bishop < Piece
    def initialize(column, row, color)
        super(column, row, color)
    end
    
    def get_moves(board)
        @validMoves.clear
        # index 0 = NorthWest, 1 = NorthEast, 2 = SouthEast, 3 = SouthWest 
        moveDirection = [Point.new(-1, 1), Point.new(1, 1), Point.new(1, -1), Point.new(-1, -1)]
        # NW start
        simulated = @pos
        direction = 0
        loop do
            temp = add_points(simulated, moveDirection[direction])
            if on_board?(temp) && board[temp.x][temp.y] == nil
                @validMoves << temp
                simulated = temp
            elsif on_board?(temp) && board[temp.x][temp.y].get_color != self.get_color
                @validMoves << temp
                simulated = @pos
                direction += 1
            else
                simulated = @pos
                direction += 1
            end
            break if direction == 4
        end

        @validMoves.uniq!
    end
end

class Knight < Piece
    def initialize(column, row, color)
        super(column, row, color)
    end

    def get_moves(board)
        @validMoves.clear
        xMove = [2, 1, -1, -2, -2, -1, 1, 2]
        yMove = [1, 2, 2, 1, -1, -2, -2, -1]
        8.times do |num|
            temp = Point.new(@pos.x + xMove[num], @pos.y + yMove[num])
            @validMoves << temp if on_board?(temp) && (board[temp.x][temp.y] == nil || board[temp.x][temp.y].get_color != self.get_color)
        end
    end
end

class Rook < Piece
    attr_accessor :castle

    def initialize(column, row, color)
        super(column, row, color)
        @castle = true
    end

    def get_moves(board)
        @validMoves.clear
        # index 0 = North, 1 = South, 2 = East, 3 = West
        moveDirection = [Point.new(0, 1), Point.new(0, -1), Point.new(1, 0), Point.new(-1, 0)]
        simulated = @pos
        direction = 0
        loop do  
            temp = add_points(simulated, moveDirection[direction])
            if on_board?(temp) && board[temp.x][temp.y] == nil
                @validMoves << temp
                simulated = temp
            elsif on_board?(temp) && board[temp.x][temp.y] != nil && board[temp.x][temp.y].get_color != self.get_color
                @validMoves << temp
                simulated = @pos
                direction += 1
            else
                simulated = @pos
                direction += 1
            end
            break if direction == 4
        end
    end
end

class Queen < Piece
    def initialize(column, row, color)
        super(column, row, color)
    end

    def get_moves(board)
        @validMoves.clear

        # index 0 = North, 1 = NorthWest, 2 = West, 3 = SouthWest, 4 = South, 5 = SouthEast, 6 = East, 7 = NorthEast
        moveDirection = [Point.new(0, 1), Point.new(-1, 1), Point.new(-1, 0), Point.new(-1, -1), Point.new(0, -1), Point.new(1, -1), Point.new(1, 0), Point.new(1, 1)]

        simulated = @pos
        direction = 0
        loop do
            temp = add_points(simulated, moveDirection[direction])
            if on_board?(temp) && board[temp.x][temp.y] == nil
                @validMoves << temp
                simulated = temp
            elsif on_board?(temp) && board[temp.x][temp.y] != nil && board[temp.x][temp.y].get_color != self.get_color
                @validMoves << temp
                simulated = @pos
                direction += 1
            else
                simulated = @pos
                direction += 1
            end
            break if direction == 8
        end
        @validMoves.uniq!
    end
end

class King < Piece
    attr_accessor :castle, :castleMoves

    def initialize(column, row, color)
        super(column, row, color)
        @castle = true
        @castleMoves = []
    end

    def get_moves(board)
        @validMoves.clear
        # index 0 = North, 1 = NorthWest, 2 = West, 3 = SouthWest, 4 = South, 5 = SouthEast, 6 = East, 7 = NorthEast
        moveDirection = [Point.new(0, 1), Point.new(-1, 1), Point.new(-1, 0), Point.new(-1, -1), Point.new(0, -1), Point.new(1, -1), Point.new(1, 0), Point.new(1, 1)]

        simulated = @pos
        direction = 0
        loop do
            temp = add_points(simulated, moveDirection[direction])
            @validMoves << temp if on_board?(temp) && (board[temp.x][temp.y] == nil || board[temp.x][temp.y].get_color != self.get_color)
            direction += 1
            break if direction == 8
        end

        if @castle
            if board[0][@pos.y].is_a?(Rook) && board[0][@pos.y].castle == true && board[1][@pos.y] == nil && board[2][@pos.y] == nil && board[3][@pos.y] == nil
                @castleMoves << Point.new(@pos.x - 2, @pos.y)
            end

            if board[7][@pos.y].is_a?(Rook) && board[7][@pos.y].castle == true && board[6][@pos.y] == nil && board[5][@pos.y] == nil
                @castleMoves << Point.new(@pos.x + 2, @pos.y)
            end
        end
    end
end
