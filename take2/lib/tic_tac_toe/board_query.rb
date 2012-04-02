require_relative "../player"

module TicTacToe
  module BoardQuery
    extend self

    CAT = Player.new "CAT", nil

    # @param board [Board]
    # @return [Point]
    def first_empty_position(board)
      point, _ = board.positions.detect &method(:empty_cell?)
      point
    end

    def empty_positions(board)
      cells = board.positions.select &method(:empty_cell?)
      cells.map{|point, _| point }
    end

    def random_empty_position(board)
      positions = empty_positions(board)
      positions.shuffle.first
    end

    def detect_win(board)
      board.lines.detect &method(:winning_line?)
    end

    def detect_cat(board)
      board.lines.all? &method(:stalemate_line?)
    end

    def detect_winner(board)
      board_winner(board) ||
          (detect_cat(board) && CAT)
    end

    private
    def winning_line?(line)
      !any_empty?(line) && all_same_player?(line)
    end

    def stalemate_line?(line)
      player_cells = line.reject &method(:empty_cell?)
      player_cells.length > 2 && !all_same_player?(player_cells)
    end

    def any_empty?(line)
      line.any?(&method(:empty_cell?))
    end

    def all_same_player?(line)
      line.each_cons(2).all?{|(_, a), (_, b)| a == b }
    end

    def empty_cell?(cell)
      _, value = cell
      value == Grid::EMPTY_POSITION
    end

    def board_winner(board)
      winning_row = detect_win(board)
      _, value = winning_row && winning_row.first
      value
    end
  end
end
