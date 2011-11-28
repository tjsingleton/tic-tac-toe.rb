require_relative "../lib/board"

describe "Board" do
  it "a board is full when all 9 spots are filled" do
    board = Board.new [:o, :x, :x,
                       :o, :x, :o,
                       :x, :o, :x]
    board.should be_full
  end

  it "detects 3 in a row" do
    [[
      :x,:x,:x,
      :x,:o,:o,
      :o,:o,:x
     ],[
      :o,:x,:o,
      :x,:x,:x,
      :o,:o,:x
     ],[
      :o,:x,:o,
      :o,:o,:x,
      :x,:x,:x
     ],[
      :x,:x,:o,
      :x,:o,:o,
      :x,:o,:x
     ],[
      :x,:x,:o,
      :o,:x,:o,
      :x,:o,:x
    ],[
      :x,:o,:x,
      :o,:o,:x,
      :o,:x,:x
    ],[
      :x,:o,:o,
      :x,:x,:o,
      :o,:x,:x
     ],[
      :o,:x,:x,
      :o,:x,:o,
      :x,:o,:x
    ]].each do |positions|
      board = Board.new positions
      board.should be_three_in_a_row
    end

    [[
      :x,:o,:x,
      :x,:x,:o,
      :o,:x,:o
     ],[
      :o,:x,:o,
      :x,:o,:x,
      :x,:o,:x
     ],[
      :x,:x,:o,
      :o,:x,:x,
      :x,:o,:o
     ]].each do |positions|
      board = Board.new positions
      board.should_not be_three_in_a_row
    end
  end
end
