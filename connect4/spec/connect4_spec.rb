require_relative "../lib/connect4.rb"

describe ConnectFour do
    describe "#get_column" do
        subject(:game) { described_class.new() }
        context "when user input is not a column number" do
            before do
                invalid = 'a'
                valid = '3'
                allow(game).to receive(:player_input).and_return(invalid, valid)
            end
            it "asks for user input again" do
                expect(game).to receive(:puts).with("Invalid column, try again.").once
                game.get_column
            end
        end

        context "when user input is a column number" do
            before do
                full = '5'
                valid = '4'
                allow(game).to receive(:player_input).and_return(full, valid)
            end
            before do

            end
            it "asks for different column if column is full" do
                6.times do |row|
                    game.board[4][row] = 1
                end
                expect(game).to receive(:puts).with("Column is full, try again.").once
                game.get_column
            end
        end
    end

    describe "#add_piece" do
        subject(:game) { described_class.new() }
        it "adds player 1's piece to the given column" do
            expectedArray = Array.new(7) { Array.new(6, 0) }
            expectedArray[3][0] = 1

            column = 3
            game.turn = 1

            game.add_piece(column)
            expect(game.board).to eq(expectedArray) 
        end

        it "adds player 2's piece to the given column" do
            expectedArray = Array.new(7) { Array.new(6, 0) }
            expectedArray[4][0] = 2

            column = 4
            game.turn = 2

            game.add_piece(4) 
            expect(game.board).to eq(expectedArray)
        end
    end

    describe "#check_win" do
        subject(:game) { described_class.new() }
        context "when there are four in a row vertically" do
            it "detects player 1 win" do
                game.turn = 1

                expectedArray = Array.new(7) { Array.new(6, 0) }
                4.times do |row|
                    expectedArray[5][row] = 1
                end
                game.board = expectedArray
                expect{ game.check_win(5, 3) }.to change(game, :won).from(false).to(true)
            end

            it "detects player 2 win" do
                game.turn = 2

                expectedArray = Array.new(7) { Array.new(6, 0) } 
                4.times do |row|
                    expectedArray[6][row] = 2
                end
                game.board = expectedArray
                expect{ game.check_win(6, 3) }.to change(game, :won).from(false).to(true)
            end
        end

        context "when there are four in a row horizontally" do
            it "detects player 1 win" do
                game.turn = 1
                expectedArray = Array.new(7) { Array.new(6, 0) }
                4.times do |column|
                    expectedArray[column + 1][0] = 1
                end
                game.board = expectedArray
                expect{ game.check_win(2, 0) }.to change(game, :won).from(false).to(true)
            end

            it "detects player 2 win" do
                game.turn = 2
                expectedArray = Array.new(7) { Array.new(6, 0) }
                4.times do |column|
                    expectedArray[column + 2][4] = 2
                end
                game.board = expectedArray
                expect{ game.check_win(4, 4) }.to change(game, :won).from(false).to(true)
            end
        end

        context "when there are four in a row diagonally" do
            it "detects player 1 win when diagonal like /" do
                game.turn = 1
                expectedArray = Array.new(7) { Array.new(6, 0) }
                4.times do |offset|
                    expectedArray[offset][offset] = 1
                end
                game.board = expectedArray
                expect{ game.check_win(2, 2) }.to change(game, :won).from(false).to(true)
            end

            it "detects player 2 win when diagonal like \\" do
                game.turn = 2
                expectedArray = Array.new(7) { Array.new(6, 0) }
                4.times do |offset|
                    expectedArray[4 - offset][0 + offset] = 2
                end
                game.board = expectedArray
                expect{ game.check_win(4, 0) }.to change(game, :won).from(false).to(true)
            end
        end

        context "when there aren't four in a row" do
            it "doesn't change won" do
                game.turn = 2
                expectedArray = Array.new(7) { Array.new(6, 0) }
                3.times do |offset|
                    expectedArray[6 - offset][2 + offset] = 2
                end
                game.board = expectedArray
                expect{ game.check_win(5, 3) }.to_not change(game, :won)
            end
        end
    end
end
