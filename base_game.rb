module Base; end
class Base::Game

  attr_accessor :client, :data, :current_question, :data, :current_game, :inputs

  def initialize
    @data ||= {}
    @inputs ||= ""
  end

  def speak(text)
    @current_question = text
    system("say", @current_question)
    client.write("⭐ " << @current_question << "\n")
  end

  def ask(question, key)
    speak(question)
    
    until client.eof?
      inputs = client.read(1024)
      client.write "received"
    end
    data[key] = inputs.chomp
  end
end