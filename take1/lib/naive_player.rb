class NaivePlayer
  def initialize(type)
    @type = type
  end

  def move(board)
    first_empty_pos = (0..8).detect do |i|
      board.at(i).nil?
    end

    board.move @type, first_empty_pos
  end

  def to_s
    @type
  end
end
