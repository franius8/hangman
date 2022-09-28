class Hangman
  def initialize
    @guess_number = 5
    
    @computer = Computer.new(@guess_number)

    @computer.play_game  
    
  end
end

class Computer
  def draw_word
    create_wordlist if @filtered_word_list.nil?
    @filtered_word_list.sample
  end

  def create_wordlist
    word_list = File.read('google-10000-english-no-swears.txt').split("\n")
    @filtered_word_list = word_list.each_with_object([]) do |word, filtered_list|
      filtered_list << word if word.length.between?(5, 12)
    end
  end
end

class Display
    def initial_message(guess_number)
        puts 'Welcome to Hangman!'
        puts "The computer will now draw a word between 5 and 12 characters."
        puts "You will have #{guess_number} guesses."
    end

    def print_word(guessed_letters)
        puts "The word is currently: #{guessed_letters.join(' ')}"
    end

    def play_again_message
        puts 'The game ended. Type Y to play again, anthing else to exit.'
    end
end

class Player
    def initialize(display)
        @display = display
    end

    def collect_guess
    
    end

    def play_again?
        @display.play_again_message
        return true if gets.chomp.upcase == 'Y' 
    end

    def collect_guess
        @display.collect_guess_message
        gets.chomp
    end
end
