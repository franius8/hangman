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
  
    def previously_guessed
      puts 'You already tried that.'
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
  
    def no_directory_message
      puts 'Saves directory not found or empty!'
    end
  
    def no_file_message
      puts 'No save found!'
    end
  end