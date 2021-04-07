require_relative 'base_game'

class SimpleGame < Base::Game
  attr_accessor :client, :data

  def initialize 
    @data ||= {}
  end

  def start_game
    speak("You chose the simple game:")
    ask("Can you tell me your name?", "name")
    ask("Can you tell me your age?", "age")
    ask("Can you tell me where you live?", "live")
    ask("Can you tell me your favorite color?", "color")

    speak("Thank you")
    speak("Here is what you told me so far.")

    @data.keys.each {|item|
      speak("You told me your #{item} was #{@data[item]} .")
    }
  end

  def speak(text)
    system("say", text)
    client.write("🟢 " << text << "\n")
  end
end