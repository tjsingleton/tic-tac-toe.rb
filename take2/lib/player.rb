require_relative "./move_event"

class Player
  # @param name [String]
  # @param strategy [GameStrategy]
  def initialize(name, strategy)
    @name, @strategy = name, strategy
  end

  attr_reader :name

  # @param board [Board]
  # @return [MoveEvent]
  def select_next_move(board)
    position = @strategy.select_best_move(board, self)
    MoveEvent[position, self]
  end

  # @return [String]
  def to_s
    "<Player: #{@name}>"
  end
end
