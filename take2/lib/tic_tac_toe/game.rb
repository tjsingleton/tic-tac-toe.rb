require_relative "./board_query"

module TicTacToe
  class Game
    class InsufficentPlayers < StandardError; end
    class MaximumPlayers < StandardError; end
    class InvalidState < StandardError; end

    class NOT_STARTED; end
    class STARTED; end
    class FINISHED; end

    attr_writer :board

    def initialize
      @state = NOT_STARTED
      @players = []
      @moves = []
    end

    def start
      raise InvalidState unless not_started?
      raise InsufficentPlayers if need_more_players?

      @next_player = @players.first
      @state = STARTED
    end

    def add_player(player)
      raise MaximumPlayers unless need_more_players?
      @players << player
    end

    def next_turn
      raise InvalidState unless started?

      move = @next_player.select_next_move(@board)
      @board.receive_move(move)
      @moves << move
    end

    def after_turn
      if winner = BoardQuery.detect_winner(@board)
        @winner = winner
        @state = FINISHED

        return
      end

      @next_player = (@players - [@next_player]).first
    end

    def last_move
      @moves.last
    end

    def winner
      raise InvalidState unless finished?
      @winner
    end

    def next_player
      raise InvalidState unless started?
      @next_player
    end

    def need_more_players?
      @players.length < 2
    end

    def not_started?
      @state == NOT_STARTED
    end

    def started?
      @state == STARTED
    end

    def finished?
      @state == FINISHED
    end
  end
end
