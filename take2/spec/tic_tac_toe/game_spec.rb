require_relative "../../lib/tic_tac_toe/game"


describe TicTacToe::Game do
  it "requires two players to start" do
    2.times do
      expect { subject.start }.to raise_error(TicTacToe::Game::InsufficentPlayers)
      subject.add_player double.as_null_object
    end

    subject.start
    subject.should be_started
  end

  it "refuses to add a 3rd player" do
    2.times { subject.add_player double }
    expect { subject.add_player double }.to raise_error(TicTacToe::Game::MaximumPlayers)
  end

  it "refuses to take a turn unless the game state is started" do
    expect { subject.next_turn }.to raise_error(TicTacToe::Game::InvalidState)
  end

  context "started with two players" do
    let(:player_one) { double("first player") }
    let(:player_two) { double("second player") }
    let(:board) { double }
    let(:move) { double }

    before do
      [player_one, player_two].each &subject.method(:add_player)
      subject.board = board
      subject.start
    end

    it "start sets the next player to player one" do
      subject.next_player.should == player_one
    end

    it "next_turn updates the board with the next players move" do
      player_one.should_receive(:select_next_move).with(board) { move }
      board.should_receive(:receive_move).with(move)

      subject.next_turn
    end

    it "after_turn advances the play to the next player" do
      TicTacToe::BoardQuery.should_receive(:detect_winner).with(board) { nil }
      subject.after_turn

      subject.next_player.should == player_two
    end

    it "after_turn sets the state to finished if a player won" do
      TicTacToe::BoardQuery.should_receive(:detect_winner).with(board) { player_one }
      subject.after_turn

      subject.should be_finished
      subject.winner.should == player_one
    end

    it "after_turn sets the state to finished if a player won" do
      TicTacToe::BoardQuery.should_receive(:detect_winner).with(board) { TicTacToe::BoardQuery::CAT }
      subject.after_turn

      subject.should be_finished
      subject.winner.should == TicTacToe::BoardQuery::CAT
    end

    it "refuses to return a winner if the game is not finished" do
      expect { subject.winner }.to raise_error(TicTacToe::Game::InvalidState)
    end
  end
end
