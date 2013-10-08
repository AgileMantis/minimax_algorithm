module TicTacToeVariant 

  # TicTacToeVariant is played like Tic Tac Toe, except on a 6x6 grid,
  # with 4 in a row required for a win.
  #  
  # The data structure representing the game state consists of a 
  # single 36 dimentional array.  ' '=Empty square, 'X'=Player 1 and 
  # 'O'=Player 2.

  class Game

    def initialize(print_state=false)
      @state = Array.new(36,' ') 
      @player_turn = 1
      reset_winner_state
      setup_ranges
      # A move order is specified, such that for best move ties, the move
      # closest to the center is chosen.
      @move_order =  [ 20,21,15,14,7,13,19,25,26,27,28,22,16,10,9,8,6,12 ]
      @move_order.concat [ 18,24,30,31,32,33,34,35,29,23,17,11,5,4,3,2,1,0 ]
      @print_state = print_state
      @n=0
    end

    attr_reader :state, :winner, :last_comp_move, :n

    def reset_winner_state
      @won = false
      @winner = nil
      @last_comp_move = nil
    end

    def setup_ranges
      @ranges = Array.new
      # Rows
      inc = 1
      6.times do |r| 
        @ranges << { start: r*6, stop: (r*6)+5, inc: inc }
      end
      # Cols
      inc = 6
      6.times do |c| 
        @ranges << { start: c, stop: c+30, inc: inc }
      end
      # Diags (left to right)
      inc = 7
      diags = [ [24,31], [18,32], [12,33], [6,34], [0,35], [1,29], [2,23], [3,17], [4,11] ] 
      diags.each { |diag| @ranges << { start: diag[0], stop: diag[1], inc: inc } }
      # Diags (right to left)
      inc = 5
      diags = [ [29,34], [23,33], [17,32], [11,31], [5,30], [4,24], [3,18], [2,12], [1,6] ] 
      diags.each { |diag| @ranges << { start: diag[0], stop: diag[1], inc: inc } }
    end

    def print_state()
      puts "\n"
      6.times do |r|
        puts state[(r*6),6].join.gsub(' ','-')
      end
      puts "\n"
      puts "n: #{@n}"
    end

    def legal_moves()
      @move_order.select { |sqr| can_move?(sqr) }
    end

    def can_move?(square)
      state[square]==' '
    end

    def full_board?()
      state.join.gsub(' ','').length==36
    end

    def make_move(square, player=1)
      if can_move?(square) && player==@player_turn && !@won
        case player
          when 1
            state[square] = 'X'
            @n=0
            if @print_state
              print_state 
              puts "Thinking...."
            end
            if !is_won?
              t1 = Time.now
              # @last_comp_move = best_comp_move
              @last_comp_move = best_move
              puts "Time: #{Time.now-t1}" if @print_state
              state[@last_comp_move] = 'O'
            else
              @last_comp_move = nil   # X won, no move
            end
            print_state if @print_state
          else
            return false
        end
        if is_won?
          @won = true
          puts "Winner!" if @print_state
        end
        return true
      end
      return false
    end

    def best_move(max_player=true, ply=0, alpha=-99999, beta=99999)
      # Terminal conditions
      if is_won? 
        # @n+=1
        reset_winner_state  # Undo winner state
        return (max_player ? (-9999+ply) : ( 9999-ply))
      end
      return 0 if full_board?
      if ply >= 3
        return score
      end
    
      best_move = 0
      value = (max_player ? -99999 : 99999)
      legal_moves.each do |sqr|

        state[sqr] = (max_player ? 'O' : 'X')
        response = best_move(!max_player,ply+1,alpha,beta)
        state[sqr] = ' '  # Undo move

        if max_player && response > value  
          value = alpha = response
          best_move = sqr
          if ply.zero? && @print_state then puts "New best value #{response} from sqr #{sqr}" end
        end
        if !max_player && response < value  
          value = beta = response
        end
        # Alpha-beta cut-off
        if beta <= alpha   
          break
        end
      end

      return (ply.zero? ? best_move : value)
    end

    def best_comp_move(ply=0, alpha=-99999, beta=99999)
      if is_won?  # Human won before comp move
        @n+=1
        reset_winner_state
        return -9999+ply  # A Win closer to root is better than one deeper in the tree
      end
      return 0 if full_board?
      value = -99999
      best_move = 0
      legal_moves.each do |sqr|
        state[sqr] = 'O'
        response = best_human_move(ply+1,alpha,beta)
        state[sqr] = ' ' 
        if response > value  
          if ply.zero? then puts "New best value #{response} from sqr #{sqr}" end
          value = alpha = response
          best_move = sqr
        end
        if beta <= alpha
          break
        end
      end
      return best_move if ply.zero?
      value
     end

    def best_human_move(ply,alpha,beta)
      if is_won?  # Comp won before human move
        @n+=1
        reset_winner_state
        return 9999-ply  # A Win closer to root is better than one deeper in the tree
      end
      return 0 if full_board?
      if ply >= 3
        return score
      end
      value = 99999 
      legal_moves.each do |sqr|
        state[sqr] = 'X'
        response = best_comp_move(ply+1,alpha,beta)
        state[sqr] = ' ' 
        if response < value  
          value = beta = response
        end
        if beta <= alpha
          break
        end
      end
      value
    end

    def is_won?
      in_a_row = markers_in_a_row
      @winner = nil
      @winner = 'X' if ( in_a_row[:x4] >=1 )
      @winner = 'O' if ( in_a_row[:o4] >=1 )
      @winner
    end

    def score
      @n+=1
      score = 0
      in_a_row = markers_in_a_row
      score += (10 * in_a_row[:o2])
      score += (90 * in_a_row[:o3])
      score += (350 * in_a_row[:o3p])
      score -= (450 * in_a_row[:x3p])
      score -= (100 * in_a_row[:x3])
      score -= (20 * in_a_row[:x2])
      score
    end
    
    def markers_in_a_row
      results = { :x4 => 0, :o4 => 0, :x3 => 0, :o3 => 0, :x3p => 0, :o3p => 0, :x2 => 0, :o2 => 0 }
      @ranges.each do |range|
        s = ''
        sqr = range[:start]
        while sqr <= range[:stop]
          s << state[sqr]
          sqr += range[:inc]
        end
        # 4 in a row
        results[:x4] += 1 if s =~ /xxxx/i 
        results[:o4] += 1 if s =~ /oooo/i 
        # 3 in a row
        results[:x3] += 1 if s =~ /xxx/i 
        results[:o3] += 1 if s =~ /ooo/i 
        # Almost 3 in a row, see note*
        results[:x3p] += 1 if s =~ /xx\s/i 
        results[:x3p] += 1 if s =~ /xx\s/i 
        results[:o3p] += 1 if s =~ /\sxx/i 
        results[:o3p] += 1 if s =~ /\sxx/i 
        # # 2 in a row
        results[:x2] += 1 if s =~ /xx/i 
        results[:o2] += 1 if s =~ /oo/i 
      end
      results
      # Note, a player may force 3 in a row if they have a space on either side of 2 in a row.  
      # However, MiniMax will see this as a no win situation (as it cannot prevent 3 in a row).
      # Thefore, it will not attempt to block one side or the other.  This is because, based 
      # upon how the algorithm works, every move attempted by the computer results in the same 
      # (three in a row).  To rectify this, this routine finds 2 in a row followed by a space, 
      # and scores it as if its three in a row, and thus the algorithm should see marking the 
      # space on the right prevents it.  Note: A possible 3 in a row on edges don't need this, 
      # as blocking it on the non edge side is covered by the algorithm.
    end

  end

end
