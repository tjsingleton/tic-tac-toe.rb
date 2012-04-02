require_relative "../../lib/tic_tac_toe/strategy"
require_relative "../../lib/point"

describe TicTacToe::Strategy::Naive do
  it "selects the first empty position" do
    board, player = double, double
    point = Point[0,0]
    TicTacToe::BoardQuery.should_receive(:first_empty_position).with(board) { point }

    point = subject.select_best_move(board, player)
    point.should == point
  end
end
