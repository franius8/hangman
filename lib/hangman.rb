# frozen_string_literal: true

# Class initializing the game and setting initial parameters
class Hangman
  def initialize
    @guess_number = 10
    @display = Display.new
    @player = Player.new(@display)
    if @player.continue_saved?
      @game_data = SaveLoad.new.load(@player, @display)
      Computer.new.continue_saved_game(@game_data, @player, @display)
    else
      @display.initial_message(@guess_number)
      @computer = Computer.new
      @computer.initialize_game(@guess_number, @display, @player)
    end
  end
end

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
    unless guess_valid?(guess)
      @display.invalid_guess_message
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

# Class handling all messages to the player
class Display
  def load_saved_game_message
    print 'Do you want to load a saved game? Type Y to load, anything else to play a new game: '
  end

  def initial_message(guess_number)
    puts '--------------------------------------------------------------'
    puts 'Welcome to Hangman!'
    puts 'The computer will now draw a word between 5 and 12 characters.'
    puts "You may enter up to #{guess_number} incorrect guesses."
    puts 'Type "save" instead of enterimg your guess to save the game.'
    puts '--------------------------------------------------------------'
  end

  def print_word(guessed_letters)
    puts "The word is currently: #{guessed_letters.join(' ')}"
  end

  def play_again_message
    print 'The game ended. Type Y to play again, anthing else to exit: '
  end

  def collect_guess_message
    print 'Enter your guess: '
  end

  def invalid_guess_message
    puts 'Guess invalid. Enter it again.'
  end

  def no_character_message
    puts 'This character is not present in the word!'
  end

  def message_after_guess(guess_number, previous_guesses)
    guess_form = if guess_number == 1
                   'guess'
                 else
                   'guesses'
                 end
    puts "You have #{guess_number} #{guess_form} left. Your previous guesses are #{previous_guesses.join(' ')}"
  end

  def lost_game_message(word)
    puts "You ran out of guesses! The word was '#{word}'"
  end

  def won_game_message(guess_number)
    puts "You correctly guessed the word with #{guess_number} guesses remaining! Congrats!"
  end

  def collect_savefile_name_message
    print 'Enter the name of your save. Only letters are allowed up to 12 characters (case insensitive): '
  end

  def succesful_save_message
    puts 'Game saved succesfully.'
  end

  def incorrect_savefile_name_message
    puts 'Incorrect save name. Enter it again.'
  end

  def collect_loadfile_name_message
    print 'Enter the name of the save to load (case insensitive): '
  end
end

# Class handling all input from the player
class Player
  def initialize(display)
    @display = display
  end

  def play_again?
    @display.play_again_message
    return true if gets.chomp.downcase == 'y'
  end

  def continue_saved?
    @display.load_saved_game_message
    return true if gets.chomp.downcase == 'y'
  end

  def collect_guess
    @display.collect_guess_message
    gets.chomp.downcase
  end

  def collect_savefile_name
    @display.collect_savefile_name_message
    gets.chomp.downcase
  end

  def collect_loadfile_name
    @display.collect_loadfile_name_message
    gets.chomp.downcase
  end
end

# Class to draw word for the game
class WordDrawer
  def initialize
    word_list = File.read('google-10000-english-no-swears.txt').split("\n")
    @filtered_word_list = word_list.each_with_object([]) do |word, filtered_list|
      filtered_list << word if word.length.between?(5, 12)
    end
  end

  def draw_word
    @filtered_word_list.sample
  end
end

# Class for saving and loading the game.
class SaveLoad
  def save(game_data, player, display)
    @game_data = game_data
    @player = player
    @display = display
    make_save_dir
    @savefile_name = collect_and_check_savefile_name
    create_savefile
    exit(true)
  end

  def collect_and_check_savefile_name
    loop do
      savefile_name = @player.collect_savefile_name
      return savefile_name if savefile_name_valid?(savefile_name)

      @display.incorrect_savefile_name_message
    end
  end

  def savefile_name_valid?(savefile_name)
    savefile_name.split('').all? { |letter| letter.ord.between?(97, 122) }
  end

  def make_save_dir
    Dir.mkdir('saves') unless File.exist?('saves')
  end

  def create_savefile
    @game_data[2] = @game_data[2].join('^')
    @game_data[3] = @game_data[3].join('^')
    File.open("saves/#{@savefile_name}.txt", 'w') { |file| file.write(@game_data.join('*')) }
    @display.succesful_save_message
  end

  def load(player, display)
    @player = player
    @display = display
    @loadfile_name = @player.collect_loadfile_name
    prepare_loaded_data
    @game_data
  end

  def prepare_loaded_data
    @game_data = File.open("saves/#{@loadfile_name}.txt", 'r').read.split('*')
    @game_data[1] = @game_data[1].to_i
    @game_data[2] = @game_data[2].split('^')
    @game_data[3] = @game_data[3].split('^')
    @game_data[4] = @game_data[4].to_i
  end
end

Hangman.new
