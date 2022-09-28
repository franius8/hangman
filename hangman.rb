# frozen_string_literal: true

# Class initializing the game and setting initial parameters
class Hangman
  def initialize
    @guess_number = 5

    @computer = Computer.new(@guess_number)

    @computer.play_game
  end
end

# Class handling all backend operations
class Computer
  def initialize(guess_number)
    @guess_number = guess_number
    @display = Display.new
    @player = Player.new(@display)
  end

  def play_game
    loop do
      prepare_variables
      @display.initial_message(@guess_number)
      @display.print_word(@guessed_letters)
      process_guess while @guessed_letters.any?('_')
      return unless @player.play_again?
    end
  end

  def prepare_variables
    create_wordlist
    draw_word
    create_guessed_list
  end

  def process_guess
    guess = ''
    loop do
      guess = @player.collect_guess
      return if guess_valid?(guess)

      @display.invalid_guess_message
    end
    check_guess(guess)
  end

  def draw_word
    create_wordlist if @filtered_word_list.nil?
    @word = @filtered_word_list.sample
  end

  def create_wordlist
    word_list = File.read('google-10000-english-no-swears.txt').split("\n")
    @filtered_word_list = word_list.each_with_object([]) do |word, filtered_list|
      if word.length.between?(5, 12)
        filtered_list << word
      end
    end
  end

  def create_guessed_list
    @guessed_letters = Array.new(@word.length, '_')
  end

  def update_guessed_list; end

  def check_guess(guess)
    unless @word.contain?(guess) do
      @display.no_character_message
      return
    end
    @guessed_letters.each_index do |index|
      @guessed_letters[index] = guess if @word[index] == guess
    end
    @display.print_word(@guessed_letters)
    end
  end

  def guess_valid?(guess)
    guess.length == 1 && guess.downcase.ord.between?(97, 122)
  end
end

# Class handling all messages to the player
class Display
  def initial_message(guess_number)
    puts 'Welcome to Hangman!'
    puts 'The computer will now draw a word between 5 and 12 characters.'
    puts "You will have #{guess_number} guesses."
  end

  def print_word(guessed_letters)
    puts "The word is currently: #{guessed_letters.join(' ')}"
  end

  def play_again_message
    puts 'The game ended. Type Y to play again, anthing else to exit.'
  end

  def collect_guess_message
    puts 'Enter your guess and press enter.'
  end

  def invalid_guess_message
    puts 'Guess invalid. Enter it again.'
  end

  def no_character_message
    puts 'This character is not present in the word!'
  end
end

# Class handling all input from the player
class Player
  def initialize(display)
    @display = display
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

Hangman.new
