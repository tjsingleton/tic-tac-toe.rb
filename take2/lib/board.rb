class Board
  # @param grid [Grid]
  def initialize(grid)
    @grid = grid
  end

  # @param move [MoveEvent]
  def receive_move(move)
    @grid.set(move.position, move.player)
  end

  # @return [Array]
  def positions
    @grid.each.to_a
  end

  # @return [Array]
  def lines
    [
        @grid.each_row,
        @grid.each_column,
        @grid.each_diagonal
    ].map(&:to_a).flatten(1)
  end
end

