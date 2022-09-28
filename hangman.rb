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
