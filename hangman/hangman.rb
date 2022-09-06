require 'yaml'

class Hangman

    def set_word()
        words = File.readlines("google-10000-english-no-swears.txt")
        randNum = rand(0..9999)
        words.each_with_index do |word, index|
            return word.chomp if index == randNum
        end
    end

    def initialize()
        @answer = set_word()
        @guesses = Array.new(@answer.length, "_")
        @guessed = Array.new
        @incorrect = Array.new
        @mistakes = 8
    end


    def display()
        @guesses.each { |letter| print " #{letter} " }
        print " Incorrect guesses: " unless @incorrect.empty?
        @incorrect.each { |letter| print letter }
        puts "\n"
    end

    def guess()
        print "Enter guess: "
        input = gets.chomp
        input.downcase!
        if input == "-1"
            save_game()
            return
        end
        loop do
            break if @guessed.none?(input) && input.count("a-z") == input.length
            print "Invalid, try again: "
            input = gets.chomp
        end
        if input.length == 1
            if @answer.split("").include?(input)
                @answer.length.times do |index|
                    if @answer.split("")[index] == input
                        @guesses[index] = input
                    end
                end
            else
                @incorrect << input
                @mistakes -= 1
            end
        elsif input.length > 1
            if input == @answer
                @guesses = input.split("")
                end_game()
            end
        end
        @guessed << input
    end

    def save_game() 
        File.open("./saved.yaml", "w") do |file|
            file.puts YAML.dump(self)
        end
        print "Game saved.\n"
        exit
    end

    def load_game()
        game = YAML::load((File.open("./saved.yaml", "r")))
        game.start_game()
        File.delete("./saved.yaml")
    end

    def end_game()
        @mistakes = 0
    end

    def start_game()
        until @mistakes == 0
            display()
            guess()
            end_game() if @answer == @guesses.join
        end

        if @guesses.join == @answer
            print "You win, "
        else
            print "You lose, "
        end
        print "the answer was \"#{@answer}\"\n"
    end
    
    def menu()
        print "Start new game or load game? "
        input = gets.chomp
        if input == "1"
            start_game()
        else
            load_game()
        end
    end
end

hangman = Hangman.new()

hangman.menu()
