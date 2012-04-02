module ANSI
  extend self

  CSI = "\e["
  GREEN = "2"
  WHITE = "7"

  def clear_screen
    print "#{CSI}2J"
    print_at 2,1
  end

  def print_at(row, column, string = "")
    print "#{CSI}#{row};#{column}H#{string}"
  end

  def set_fg_color(color)
    print "#{CSI}3#{color}m"
  end
end


module TicTacToe
  class Printer
    BAR_PADDING = 3
    LINE_LENGTH = 11

    def initialize
      @glyphs = {}
    end

    def set_glyph(glyph, player)
      @glyphs[player] = glyph
    end

    def print_board(board)
      ANSI.clear_screen
      print_bars
      print_line
      print_bars
      print_line
      print_bars
      print_numbers
      ANSI.print_at 8, 1
    end

    def print_numbers
      i = 0
      3.times do |x|
        3.times do |y|
          column = pad_column(y)
          row    = pad_row(x)

          ANSI.print_at row, column, i

          i = i + 1
        end
      end
    end

    def print_move(move)
      glyph  = get_glyph(move.player)
      column = pad_column(move.position.y)
      row    = pad_row(move.position.x)

      ANSI.set_fg_color ANSI::GREEN
      ANSI.print_at row, column, glyph
      ANSI.set_fg_color ANSI::WHITE

      $i ||= 0
      $i += 1
      ANSI.print_at $i, 18, "#{glyph}: #{move.position.inspect}"

      ANSI.print_at 8, 1
    end

    def print_winner(player)
      glyph = get_glyph(player)
      ANSI.print_at(8, 1, "Winner: #{glyph} - #{player.name}\n\n")
    end

    private
    def pad_column(n)
      ((n+1) *4) - 2
    end

    def pad_row(n)
      (n+1) * 2
    end

    def get_glyph(player)
      @glyphs.fetch(player, "?")
    end

    def print_bars
      space = " " * BAR_PADDING
      puts "#{space}|#{space}|"
    end

    def print_line
      puts("-" * LINE_LENGTH)
    end
  end
end
