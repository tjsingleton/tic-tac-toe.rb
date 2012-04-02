require_relative "../event_loop"
require_relative "../player"
require_relative "./game"
require_relative "./strategy"
require_relative "./board"
require_relative "./printer"

module TicTacToe
  class CLI
    def self.run
      computer_strategy = Strategy::Emily.new
      human_strategy = Strategy::CLI.new

      event_loop     = EventLoop.new
      board          = Board.new
      game           = Game.new
      printer        = Printer.new
      player_x       = Player.new("1", human_strategy)
      player_o       = Player.new("2", computer_strategy)

      game.add_player player_x
      game.add_player player_o
      game.board = board
      game.start

      printer.set_glyph("X", player_x)
      printer.set_glyph("O", player_o)

      printer.print_board(board)
      event_loop.each_tick do
        game.next_turn
        printer.print_move(game.last_move)
        game.after_turn

        event_loop.stop if game.finished?
      end

      event_loop.start
      printer.print_winner(game.winner)
    end
  end
end
