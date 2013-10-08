require 'spec_helper'

module TicTacToeVariant
  
  describe Game do

    describe "play logic" do

      before(:each) do
        @game = Game.new
        @state = Array.new(36, ' ')
      end

      it "should determine if player can make legal move" do
        @state[0] = 'O'
        @state[1] = 'X'
        @game.stub(:state) { @state }
        @game.can_move?(0).should be_false
        @game.can_move?(1).should be_false
        (2..35).each { |sqr| @game.can_move?(sqr).should be_true }
      end

      it "should calculate legal moves" do
        @state[10] = 'X'
        @state[12] = 'O'
        @game.stub(:state) { @state }
        @game.legal_moves.size.should == 34
      end

      it "should allow moves when its the players turn" do
        @game.stub(:best_comp_move).and_return(35)
        @game.make_move(0,1).should be_true    # Square 0, player 1
        @game.stub(:best_comp_move).and_return(34)
        @game.make_move(6,1).should be_true    # Square 6, player 1

        @state = Array.new(36, ' ')
        @state[0] = @state[6] = 'X'
        @state[35] = @state[34] = 'O'
        @game.state.should =~ @state
      end

      it "should not allow moves when its not the players turn" do
        @game.stub(:best_comp_move).and_return(35)

        # When it's player 1s turn
        @game.make_move(2,2).should be_false

        # When it's player 2s turn
        @game.instance_variable_set("@player_turn", 2) # player 1 moves
        @game.make_move(1).should be_false
      end

      it "should know when the board is full" do
        @game.full_board?.should be_false
        @game.stub(:state) { Array.new(36,'-') }
        @game.full_board?.should be_true
      end

      it "keep track of last computer move" do
        puts "Computer is thinking...."
        @game.make_move(1).should be_true
        @game.last_comp_move.should equal(8)
      end

      it "Minimax should prevent three in a row (non edge)" do
        @state[9] = 'X'
        @state[20] = 'O'
        @game.instance_variable_set("@state", @state)
        puts "Computer is thinking...."
        @game.make_move(21).should be_true
        @game.state[15].should == 'O'
      end

      it "Minimax should counter four in a row (edge)" do
        @state[3] = @state[9] = 'X'
        @game.instance_variable_set("@state", @state)
        puts "Computer is thinking..."
        @game.make_move(15).should be_true
        @game.state[21].should == 'O'
      end

      it "Minimax should play certain moves based upon defined human moves" do
        puts "Computer is thinking..."
        @game.make_move(16).should be_true
        @game.state[20].should == 'O'
        @game.make_move(9).should be_true
        @game.state[23].should == 'O'
        @game.make_move(14).should be_true
        @game.state[21].should == 'O'
        @game.make_move(22).should be_true
        @game.state[19].should == 'O'
        @game.make_move(18).should be_true
        @game.state[28].should == 'O'
      end

    end

  end

end

