class SimplePlayer
  def initialize(type)
    @type = type
  end

  CENTER = 4

  def move(board)
    @board = board

    pos = case
      when can_win?
        win
      when they_win_next?
        block_them
      when row_is_mine?
        take_my_row
      when center_empty?
        CENTER
      when row_is_free?
        take_free_row
      else
        first_empty_position
    end

    @board.move @type, pos
  end

  def center_empty?
    @board.at(CENTER).nil?
  end

  def first_empty_position
    (0..8).detect do |i|
      @board.at(i).nil?
    end
  end

  def can_win?
    Board::WINS.select do |indexes|
      indexes.select{|n| @board.at(n) == @type }.length == 2 &&
          indexes.select{|n| @board.at(n).nil? }.length == 1
    end.any?
  end

  def win
    row = Board::WINS.select do |indexes|
      indexes.select{|n| @board.at(n) == @type }.length == 2 &&
          indexes.select{|n| @board.at(n).nil? }.length == 1
    end.first

    row.detect{|n| @board.at(n).nil? }
  end

  def they_win_next?
    Board::WINS.select do |indexes|
      indexes.reject{|n| @board.at(n) == @type || @board.at(n).nil? }.length == 2 &&
          indexes.select{|n| @board.at(n).nil? }.length == 1
    end.any?
  end

  def block_them
    row = Board::WINS.select do |indexes|
      indexes.reject{|n| @board.at(n) == @type || @board.at(n).nil? }.length == 2 &&
          indexes.select{|n| @board.at(n).nil? }.length == 1
    end.first

    row.detect{|n| @board.at(n).nil?}
  end

  def row_is_mine?
    Board::WINS.select do |indexes|
      mine = indexes.select{|n| @board.at(n) == @type }
      empty = indexes.select{|n| @board.at(n) == nil? }

      mine.any? && (mine.length + empty.length == 3)
    end.any?
  end

  def take_my_row
    row = Board::WINS.select do |indexes|
      mine = indexes.select{|n| @board.at(n) == @type }
      empty = indexes.select{|n| @board.at(n) == nil? }

      mine.any? && (mine.length + empty.length == 3)
    end.first

    row.detect{|n| @board.at(n).nil?}
  end


  def row_is_free?
    Board::WINS.select do |indexes|
      indexes.select{|n| @board.at(n) == @type || @board.at(n).nil? }.length == 3
    end.any?
  end

  def take_free_row
    row = Board::WINS.select do |indexes|
      indexes.select{|n| @board.at(n) == @type || @board.at(n).nil? }.length == 3
    end.first

    row.detect{|n| @board.at(n).nil?}
  end

  def to_s
    @type
  end
end
