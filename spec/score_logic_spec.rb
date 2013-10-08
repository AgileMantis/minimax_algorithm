require 'spec_helper'

module TicTacToeVariant
  
  describe Game do

    describe "play logic" do

      before(:each) do
        @fixture = Array.new(36, ' ')
        subject = Game.new
      end

      describe "should calulate four in a row" do 

        it "should calculate four Xs in-a-row on first row" do
          @fixture[0,4] = Array['X','X','X','X'] 
          subject.stub(:state) { @fixture }
          subject.markers_in_a_row[:x4].should equal(1)
        end

        it "should calculate four Os in-a-row on second row" do
          @fixture[7,4] = Array['O','O','O','O'] 
          subject.stub(:state) { @fixture }
          subject.markers_in_a_row[:o4].should equal(1)
        end

        it "should calculate four Xs in-a-row on first col" do
          @fixture[0] = @fixture[6] = @fixture[12] = @fixture[18] = 'X'
          subject.stub(:state) { @fixture }
          subject.markers_in_a_row[:x4].should equal(1)
        end

        it "should calculate four Os in-a-row on second col" do
          @fixture[1] = @fixture[7] = @fixture[13] = @fixture[19] = 'O'
          subject.stub(:state) { @fixture }
          subject.markers_in_a_row[:o4].should equal(1)
        end

      end

      # def calc_score(game, state, score) 
      #   game.stub(:state) { state }
      #   game.player_score('X').should equal(score)
      # end

      # it "should calculate player score" do
      #   state = Array.new(36,' ')
      #   game = Game.new
      #   score = 0
      #   calc_score(game, state, score)

      #   # Note: Scores are cumulative in this test
      #   
      #   # Two in a row, additional 10 pts 
      #   state[0] = state[1] = 'X'
      #   calc_score(game, state, score+= 10)
      #   
      #   # Three in a row, additional 100 pts for three
      #   # and an addtional 10, as the three in a row contain
      #   # two two-in-arrow's inside the three
      #   state[2] = 'X'
      #   calc_score(game, state, score+= 110)

      #   # Another two in a row += 10 pts 
      #   state[12] = state[13] = 'X'
      #   calc_score(game, state, score+= 10)
      #   
      #   # Another three in a row += 120 pts, an isolaated
      #   # three in a row
      #   state[24] = state[25] = state[36] = 'X'
      #   calc_score(game, state, score+= 10)

      #   # Player 2s score should have NO effect on player 1
      #   state[18] = state[19] = state[20] = 'O'
      #   calc_score(game, state, score)
      #   state[5] = state[11] = 'O'
      #   calc_score(game, state, score)
      # end

      it "should determine if a game is won" do
        state = Array.new(36,' ')
        game = Game.new
        game.is_won?.should be_false
        game.winner.should be_nil

        # Xs
        4.times { |x| state[x] = 'X' }
        game = Game.new
        game.stub(:state) { state }
        game.is_won?.should be_true
        game.winner.should =='X'

        4.times { |x| state[x] = ' ' }
        game = Game.new
        game.stub(:state) { state }
        game.is_won?.should be_false
        game.winner.should be_nil

        # Os
        4.times { |x| state[12+x] = 'O' }
        game = Game.new
        game.stub(:state) { state }
        game.is_won?.should be_true
        game.winner.should =='O'

        4.times { |x| state[12+x] = ' ' }
        game = Game.new
        game.stub(:state) { state }
        game.is_won?.should be_false
        game.winner.should be_nil
      end

      it "should not determine if a game is won when its not" do
        state = Array.new(36,' ')
        game = Game.new

        # Xs
        3.times { |x| state[x] = 'X' }
        game.stub(:state) { state }
        game.is_won?.should be_false
        game.winner.should be_nil

        3.times { |x| state[x] = ' ' }
        game.stub(:state) { state }
        game.is_won?.should be_false
        game.winner.should be_nil

        # Os
        3.times { |x| state[12+x] = 'O' }
        game.stub(:state) { state }
        game.is_won?.should be_false
        game.winner.should be_nil

        3.times { |x| state[12+x] = ' ' }
        game.stub(:state) { state }
        game.is_won?.should be_false
        game.winner.should be_nil
      end

    end

  end

end

