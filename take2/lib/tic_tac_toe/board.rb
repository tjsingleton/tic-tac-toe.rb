require_relative "../board"
require_relative "../point"
require_relative "../grid"

module TicTacToe
  class Board < ::Board
    DEFAULT_BOUNDS = Point[2,2]

    def initialize(grid = Grid::WriteOnce.new(DEFAULT_BOUNDS))
      super
    end
  end
end
