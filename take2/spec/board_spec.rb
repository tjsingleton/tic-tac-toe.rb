require_relative "../lib/board"
require_relative "../lib/move_event"
require_relative "../lib/point"

describe Board do
  let(:grid) { double }
  let(:board) { described_class.new(grid) }

  it "stores a valid move" do
    move_event = MoveEvent.new(
        position: Point[1,1],
        player: double
    )

    grid.should_receive(:set).with(move_event.position, move_event.player)
    board.receive_move(move_event)
  end

  it "delegates each to the grid" do
    grid.should_receive :each
    board.positions
  end

  it "combines rows, columns, and diagnols" do
    grid.should_receive(:each_row) { [[:row]].each }
    grid.should_receive(:each_column) { [[:column]].each }
    grid.should_receive(:each_diagonal) { [[:diagonal]].each }

    board.lines.to_a.should == [
      [:row], [:column], [:diagonal]
    ]
  end
end
