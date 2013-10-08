require 'spec_helper'

module TicTacToeVariant
  
  describe Game do

    describe "start" do
      it "initializes game state" do
        subject.state.should =~ Array.new(36,' ')
      end

      it "sets isWon to false" do
        subject.is_won?.should be_false
      end

      it "sets winner to nil" do
        subject.winner.should be_nil
      end

      it "sets player turn to player 1" do
        subject.instance_variable_get("@player_turn").should equal(1)
      end

      it "has a move order which is inner circle centric" do
        total = 0
        move_order = subject.instance_variable_get("@move_order")
        move_order.each { |sqr| total += sqr } 
        series_sum = (35*(1+35)/2) # 1..35 series sum
        total.should equal(series_sum)
      end

    end

  end

end

