require_relative "../lib/player"
require_relative "../lib/point"

describe Player do
  it "analyzes the best position when presented a board and returns a move event" do
    strategy = double
    board  = double
    player = Player.new("Emily", strategy)
    best_move = Point[1,1]

    strategy.should_receive(:select_best_move).with(board, player){ best_move }
    move = player.select_next_move(board)
    move.player.should == player
    move.position.should == best_move
  end
end
