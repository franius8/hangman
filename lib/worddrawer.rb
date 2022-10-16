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