require_relative "../lib/game"
require_relative "../lib/board"

describe Game do

  let(:nought) { double("naught") }
  let(:cross) { double("cross") }
  let(:starting_board) { Board.new }
  let(:game) { Game.new nought: nought, cross: cross, board: starting_board }

  def create_boards(*positions)
    lambda {
      Board.new positions.shift
    }
  end

  it "begins with X making a move" do
    cross.should_receive(:move).with(starting_board)

    game.take_turn
  end

  it "after X moves, it is O's turn" do
    board_after_move = Board.new [:x]

    cross.should_receive(:move).with(starting_board).and_yield board_after_move
    game.take_turn

    nought.should_receive(:move).with(board_after_move)
    game.take_turn
  end

  it "is over if a player gets three in a row" do
    moves = create_boards [:x],
                          [:x, nil, nil,
                           :o],
                          [:x, :x, nil,
                           :o],
                          [:x, :x, nil,
                           :o, :o],
                          [:x, :x, :x,
                           :o, :o]

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    nought.should_receive(:move).and_yield moves.call
    game.take_turn

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    nought.should_receive(:move).and_yield moves.call
    game.take_turn

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    game.should be_over
    game.winner.should eq(cross)
  end

  it "is over if there are no spaces open" do
    moves = create_boards [:x],

                          [:x, nil, :o],
                          [:x, :x, :o],
                          [ :x,  :x, :o,
                           nil, nil, :x],
                          [ :x,  :x,  :o,
                            :o, nil,  :x],
                          [ :x,  :x,  :o,
                            :o, nil,  :x,
                            :x],
                          [:x, :x, :o,
                           :o, :o, :x,
                           :x],
                          [:x, :x, :o,
                           :o, :o, :x,
                           :x, :o],
                          [:x, :x, :o,
                           :o, :o, :x,
                           :x, :o, :x]

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    nought.should_receive(:move).and_yield moves.call
    game.take_turn

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    nought.should_receive(:move).and_yield moves.call
    game.take_turn

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    nought.should_receive(:move).and_yield moves.call
    game.take_turn

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    nought.should_receive(:move).and_yield moves.call
    game.take_turn

    cross.should_receive(:move).and_yield moves.call
    game.take_turn

    game.should be_over
    game.winner.should be_nil
  end
end
