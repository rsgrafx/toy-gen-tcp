require_relative 'base_game'

class MathGame < Base::Game
  attr_accessor :client, :data

  def initialize 
    @data ||= {}
  end

  def start_game
    speak("Good choice.  Math is my favorite")
    ask("What is 1 * 100", "tens")
    ask("What shape has 4 sides", "square")
    ask("What shape had 3 sides", "triangle")
    ask("How many sides in circle", "cirle")

    speak("Thank you")
    speak("Here is what you told me so far.")

    @data.keys.each {|item|
      speak("You told me a #{item} has #{@data[item]} .")
    }
  end

end