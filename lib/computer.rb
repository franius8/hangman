require_relative 'saveload'
require_relative 'worddrawer'

# Class handling all backend operations during the game
class Computer
    
    def initialize_game(guess_number, display, player)
      @guess_number = guess_number
      @initial_guess_number = guess_number
      @display = display
      @player = player
      @save_load = SaveLoad.new
      play_game
    end
  
    def continue_saved_game(game_data, player, display)
      return Hangman.new if game_data.nil?
  
      @display = display
      @player = player
      @word, @guess_number, @guessed_letters, @previous_guesses, @initial_guess_number = game_data
      @save_load = SaveLoad.new
      @display.message_after_guess(@guess_number, @previous_guesses)
      @display.print_word(@guessed_letters)
      process_guess while @guessed_letters.any?('_') && @guess_number.positive?
      play_game
    end
  
    private
  
    def play_game
      loop do
        prepare_variables
        @display.print_word(@guessed_letters)
        process_guess while @guessed_letters.any?('_') && @guess_number.positive?
        return unless @player.play_again?
  
        @guess_number = @initial_guess_number
      end
    end
  
    def prepare_variables
      @word = WordDrawer.new.draw_word
      create_guessed_list
      @previous_guesses = []
    end
  
    def process_guess
      guess = @player.collect_guess
      @game_data = [@word, @guess_number, @guessed_letters, @previous_guesses, @initial_guess_number]
      @save_load.save(@game_data, @player, @display) if guess == 'save'
      unless guess_valid?(guess) && @previous_guesses.none?(guess)
        @display.invalid_guess_message unless guess_valid?(guess)
        @display.previously_guessed unless @previous_guesses.none?(guess)
        return
      end
      check_guess(guess)
    end
  
    def create_wordlist
      word_list = File.read('google-10000-english-no-swears.txt').split("\n")
      @filtered_word_list = word_list.each_with_object([]) do |word, filtered_list|
        filtered_list << word if word.length.between?(5, 12)
      end
    end
  
    def create_guessed_list
      @guessed_letters = Array.new(@word.length, '_')
    end
  
    def update_guessed_list(guess)
      @guessed_letters.each_index do |index|
        @guessed_letters[index] = guess if @word[index] == guess
      end
    end
  
    def check_guess(guess)
      if @word.include?(guess)
        update_guessed_list(guess)
      else
        @display.no_character_message
        finalize_guess(guess)
      end
      @display.print_word(@guessed_letters) unless @guess_number.zero?
      @display.won_game_message(@guess_number) if @guessed_letters.none?('_')
    end
  
    def finalize_guess(guess)
      @previous_guesses << guess
      @guess_number -= 1
      if @guess_number.zero?
        @display.lost_game_message(@word)
      else
        @display.message_after_guess(@guess_number, @previous_guesses)
      end
    end
  
    def guess_valid?(guess)
      guess.length == 1 && guess.downcase.ord.between?(97, 122)
    end
  end