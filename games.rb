require_relative "math"
require_relative "simple"
require_relative 'base_game'

class Games < Base::Game
  attr_accessor :client, :data, :current_question, :data, :current_game

  def initialize
    @data ||= {}
  end

  def start_game
    speak("Lets begin:")
    speak("I have 2 games:\n1. Math and 2. simple game.")
    speak("type math for the math game or hit any key for the other")
    
    ask("Can you tell what game you want to play", "game")
    if @data["game"] == "math" 
      @current_game = MathGame.new()
      @current_game.client = client
      @current_game.start_game
    else
      @current_game = SimpleGame.new()
      @current_game.client = client
      @current_game.start_game
    end
    ask("Do you want to play again?", :bool)
  end

  def end_game
    speak("thank you for playing with me.\n Good bye")
  end

  def repeat_question 
    system("say", current_question)
    client.write("⭐ " << @current_question << "\n")
  end

end