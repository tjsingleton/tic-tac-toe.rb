require_relative "../lib/game"
require_relative "../lib/board"
require_relative "../lib/naive_player"

describe "Game" do
  let(:nought) { NaivePlayer.new(:o) }
  let(:cross) { NaivePlayer.new(:x) }
  let(:starting_board) { Board.new }
  let(:game) { Game.new nought: nought, cross: cross, board: starting_board }

  it "runs until it's over" do
    game.run
    puts game.winner.to_s
    puts game.board
  end

end
