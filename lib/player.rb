# Class handling all input from the player
class Player
    def initialize(display)
      @display = display
    end
  
    # Methods used during initialization
    def play_again?
      @display.play_again_message
      return true if gets.chomp.downcase == 'y'
    end
  
    def continue_saved?
      @display.load_saved_game_message
      return true if gets.chomp.downcase == 'y'
    end
  
    # Methods used during the game
    def collect_guess
      @display.collect_guess_message
      gets.chomp.downcase
    end
  
    # Methods used during saving/loading
    def collect_savefile_name
      @display.collect_savefile_name_message
      gets.chomp.downcase
    end
  
    def collect_loadfile_name
      @display.collect_loadfile_name_message
      gets.chomp.downcase
    end
  end