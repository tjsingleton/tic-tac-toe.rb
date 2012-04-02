require_relative "../../lib/tic_tac_toe/board"
require_relative "../../lib/tic_tac_toe/board_query"
require_relative "../../lib/move_event"

describe TicTacToe::BoardQuery do
  let(:board) { TicTacToe::Board.new }
  let(:player) { double "first player" }
  let(:other_player) { double "second player" }

  def make_move(x,y, move_player = player)
    position = Point[x,y]
    move = MoveEvent[position, move_player]
    board.receive_move(move)
  end

  def other_player_make_move(x,y)
    make_move x, y, other_player
  end

  def player_point(x,y)
    [Point[x,y], player]
  end

  def board_is_not_winner
    described_class.detect_win(board).should be_false
  end

  def board_is_not_cat
    described_class.detect_cat(board).should be_false
  end

  def board_is_a_cat
    described_class.detect_cat(board).should be_true
  end

  def moves_should_be_a_winner(*winning_row)
    winning_row.map {|x,y| make_move(x,y) }
    described_class.detect_win(board).should == winning_row.map{|x,y| player_point(x,y)}
  end

  def with_a_cat_game
    [[0,0], [1,1], [1,2], [2,0], [2,1]].each do |x,y|
      make_move x, y
    end

    [[0,1], [0,2], [1,0], [2,2]].each do |x,y|
      other_player_make_move x, y
    end
  end

  def the_winner_is(winner)
    TicTacToe::BoardQuery.detect_winner(board).should == winner
  end

  it "selects 0,0 if the board is empty" do
    position = described_class.first_empty_position(board)
    position.should == Point[0,0]
  end

  it "selects 0,1 if 0,0 is the only selected position" do
    make_move(0,0)

    position = described_class.first_empty_position(board)
    position.should == position
  end

  it "does not detects a win where there is an empty cell" do
    board_is_not_winner
    make_move(0,0)
    board_is_not_winner
    make_move(0,1)
    board_is_not_winner
  end

  it "does not detect a win if one move on a line was by a different player" do
    make_move(0,0)
    make_move(0,1)
    other_player_make_move(0,2)
    board_is_not_winner
  end

  it "detects a win when there are 3 moves by the same player in a row" do
    moves_should_be_a_winner [0,0], [0,1], [0,2]
  end

  it "detects a win when there are 3 moves by the same player in a column" do
    moves_should_be_a_winner [0,0], [1,0], [2,0]
  end

  it "detects a win when there are 3 moves by the same player in a diagonal" do
    moves_should_be_a_winner [0,0], [1,1], [2,2]
  end

  it "does not detect a cat when there is no moves" do
    board_is_not_cat
  end

  it "does not detect a cat when there is 1 move on a line" do
    with_a_cat_game
    board_is_a_cat
  end

  it "detects the winner as CAT when it is a cat game" do
    with_a_cat_game
    the_winner_is(TicTacToe::BoardQuery::CAT)
  end

  it "detects the winner as a player when the player won" do
    moves_should_be_a_winner [0,0], [1,1], [2,2]
    the_winner_is(player)
  end
end
