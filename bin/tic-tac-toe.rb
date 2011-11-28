require_relative "../lib/board"
require_relative "../lib/game"
require_relative "../lib/human_player"
require_relative "../lib/simple_player"

game = Game.new cross: SimplePlayer.new(:x),
                nought: HumanPlayer.new(:o),
                board: Board.new

game.run
puts game.board

winner = game.winner

puts "Winner: #{winner.to_s || "cat"}"
