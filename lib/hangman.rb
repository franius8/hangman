# frozen_string_literal: true

require 'yaml'

require_relative 'computer'
require_relative 'display'
require_relative 'player'
require_relative 'saveload'

# Class initializing the game and setting initial parameters
class Hangman
  def initialize
    @guess_number = 10
    @display = Display.new
    @player = Player.new(@display)
    if @player.continue_saved?
      continue_saved
    else
      initialize_new
    end
  end

  private

  def continue_saved
    computer = SaveLoad.new.load(@player, @display)
    computer.continue_saved_game(@player, @display)
  end

  def initialize_new
    @display.initial_message(@guess_number)
    @computer = Computer.new
    @computer.initialize_game(@guess_number, @display, @player)
  end
end

Hangman.new