class Board
  WINS = [[0,1,2],
          [3,4,5],
          [6,7,8],
          [0,3,6],
          [1,4,7],
          [2,5,8],
          [0,4,8],
          [2,4,6]]

  def initialize(positions = [])
    @positions = positions
  end

  def at(i)
    @positions[i]
  end

  def move(player, i)
    @positions[i] = player
  end

  def full?
    @positions.length == 9 && @positions.all?
  end

  def three_in_a_row?
    WINS.any? &method(:detect_three_in_a_row)
  end

  def winner
    row_indexes = WINS.detect(&method(:detect_three_in_a_row))
    row_indexes && @positions[row_indexes.first]
  end

  def over?
    three_in_a_row? || full?
  end

  def to_s
    divider = "-------\n"

    positions = (0..8).map {|n| @positions[n] || n }
    positions.each_slice(3).map do |a,b,c|
      " #{a}|#{b}|#{c}\n"
    end.join(divider)
  end

  private
  def detect_three_in_a_row(indexes)
    row = indexes.map &@positions.method(:[])
    row.length == 3 && row.all? && row[0] == row[1] && row[1] == row[2]
  end
end
