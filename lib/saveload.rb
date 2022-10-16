# Class for saving and loading the game.
class SaveLoad
    def save(player, display, computer)
      @player = player
      @display = display
      @computer = computer
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
      savefile_name.split('').all? { |letter| letter.ord.between?(97, 122) } && savefile_name.length < 13
    end
  
    def make_save_dir
      Dir.mkdir('saves') unless File.exist?('saves')
    end
  
    def create_savefile
      File.open("saves/#{@savefile_name}.yml", 'w') { |file| YAML.dump(@computer, file) }
      @display.succesful_save_message
    end
  
    def load(player, display)
      @player = player
      @display = display
      unless File.exist?('saves') && !Dir.empty?('saves')
        @display.no_directory_message
        return nil
      end
      @loadfile_name = collect_loadfile_name
      File.open("saves/#{@loadfile_name}.yml", 'r') do |file|
        YAML.safe_load(file, permitted_classes: [Computer, Display, Player, SaveLoad], aliases: true)
      end
    end
  
    def collect_loadfile_name
      loop do
        loadfile_name = @player.collect_loadfile_name
        return loadfile_name if File.exist?("saves/#{loadfile_name}.yml")
        
        @display.no_file_message
      end
    end
  end