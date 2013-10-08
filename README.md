minimax_algorithm
=================

Minimax algorithm implemented via a Tic-Tac-Toe variant using a 6x6 grid where 4 in a row wins.

See [ledsworth.com](http://www.ledsworth.com/samples/minimax_algorithm) for more details about the algorithm 
and a live/playable version.

Running the game
----------------
Below is how I spawn/run a game from within IRB.  It's not user friendly....But it works.

    load "./tic_tac_toe_variant.rb"  
    game=TicTacToeVariant::Game.new(true)

You can them call `game.make_move %sq%` to get started (e.g. `game.make_move 0`).  

The key is knowing the squares, 0 for upper left, 35 for lower right.  

The algorithm will play it's move and then display of the board state.  You can then make your next move.
