class HumanPlayer
  def initialize(type)
    puts "What's your name?"
    @name = gets.chomp
    @type = type
  end

  def move(board)
    puts "What's your move?"
    puts board

    i = gets.chomp.to_i

    if (0..8).include? i
      board.move(@type, i)
    else
      puts "invalid move"
      move(board)
    end
  end

  def to_s
    @name
  end
end
