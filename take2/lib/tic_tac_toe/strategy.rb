require_relative "./board_query"

module TicTacToe
  class Strategy
    class AbstractMethodError < StandardError; end

    # @param board [Board]
    # @param player [Player]
    # @return [Point]
    def select_best_move(board, player)
      raise AbstractMethodError
    end
  end

  # Always selects the first empty position
  class Strategy::Naive < Strategy
    def select_best_move(board, player)
      BoardQuery.first_empty_position(board)
    end
  end

  # Selects random empty position
  class Strategy::Random < Strategy
    def select_best_move(board, player)
      BoardQuery.random_empty_position(board)
    end
  end

  class Strategy::CLI < Strategy
    def select_best_move(board, player)
      selection = gets.chomp!.to_i
      position, _ = board.positions[selection]
      position
    end
  end

  class Strategy::Emily < Strategy
    # @param board [Board]
    def select_best_move(board, player)
      @board, @player = board, player
      position = detect_row_to_complete
      position ||= detect_row_to_defend
      position ||= detect_row_to_continue
      position ||= take_center # may not be needed, start_empty_row may handle
      position ||= start_empty_row
      position ||= block_them
      position || BoardQuery.random_empty_position(@board)
    end

    private
    # win if I can
    def detect_row_to_complete
      winning_line = @board.lines.detect do |line|
        line_needs_one_more_to_win(line)
      end

      winning_line && first_empty_position(winning_line)
    end

    # block them if they are about to win
    def detect_row_to_defend
      losing_line = @board.lines.detect do |line|
        line_needs_one_more_to_lose(line)
      end

      losing_line && first_empty_position(losing_line)
    end

    # add a second mark on a line
    # tries to pick the cell that is in the most lines
    def detect_row_to_continue
      my_lines = @board.lines.select {|line| player_cells(line).any? && !other_player_cells(line).any? }
      find_position_in_most_lines my_lines
    end


    # take center if it's empty
    def take_center
      positions = @board.positions
      middle = positions.length / 2
      position, value = positions[middle]
      position if value == Grid::EMPTY_POSITION
    end

    # start an empty row
    def start_empty_row
      empty_lines = @board.lines.select {|line| empty_cells(line).length == line.length }
      find_position_in_most_lines empty_lines
    end

    # block them if I can
    def block_them
      their_lines = @board.lines.select {|line| other_player_cells(line).any? }
      find_position_in_most_lines their_lines
    end

    # tries to pick the cell that is in the most lines
    def find_position_in_most_lines(lines)
      cell_counts = Hash.new { 0 }
      lines.each {|line| tally_empty_cells(line, cell_counts) }
      _, max = cell_counts.to_a.max {|(_, a), (_, b)| a <=> b }
      cell_counts.select{|_, count| count == max }.keys.shuffle.first
    end

    # @param cells [Array]
    def tally_empty_cells(cells, counts)
      empty_cells = cells.select{|_, value| value == Grid::EMPTY_POSITION }
      empty_cells.each {|position, _| counts[position] += 1 }
    end

    def first_empty_position(line)
      position, _ = line.detect {|_, value| value == Grid::EMPTY_POSITION }
      position
    end

    # @param cells [Array]
    # @return [Array]
    def empty_cells(cells)
      cells.select {|_, value| value == Grid::EMPTY_POSITION }
    end


    # @param cells [Array]
    # @return [Array]
    def player_cells(cells)
      cells.select {|_, value| value == @player }
    end

    # @param cells [Array]
    # @return [Array]
    def other_player_cells(cells)
      cells.select {|_, value| value != @player && value != Grid::EMPTY_POSITION }
    end

    # @param cells [Array]
    # @return [true,false]
    def line_needs_one_more_to_win(cells)
      player_cells = player_cells(cells)
      player_cells.length == (cells.length - 1)
    end

    # @param cells [Array]
    # @return [true,false]
    def line_needs_one_more_to_lose(cells)
      player_cells = other_player_cells(cells)
      player_cells.length == (cells.length - 1)
    end
  end
end
