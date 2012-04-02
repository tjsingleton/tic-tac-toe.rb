class Game
  def initialize(options = {})
    @cross  = options[:cross]
    @nought = options[:nought]
    @board  = options[:board]
    @current_player = @cross
  end

  attr_reader :board

  def run
    loop do
      take_turn
      break if over?
    end
  end

  def take_turn
    @current_player.move @board do |changed_board|
      @board = changed_board
    end

    next_turn unless over?
  end

  def over?
    @board.over?
  end

  def winner
    sym = @board.winner

    if  sym == :x
      @cross
    elsif sym  == :o
      @nought
    end
  end

  private
  def next_turn
    if @current_player == @nought
      @current_player = @cross
    else
      @current_player = @nought
    end
  end
end
