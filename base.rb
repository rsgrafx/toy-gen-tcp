require 'socket'
require_relative "games"

server = TCPServer.new(1337)
$stdout.sync = true

loop do
  client = server.accept
  game = Games.new()
  game.client = client
  game.start_game
  
  yes_no = client.gets
  answer = yes_no.strip.chomp

  if ["yes", "y"].include?(answer)
    game = Games.new()
    game.client = client
    game.start_game
  end

  game.end_game
  client.close
end
