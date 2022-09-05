Game game;
MiniMax minimax;
ArrayList<Integer> current_state = new ArrayList<Integer> ();  // current board position (as the sequence of moves played)

void setup() {
  
  size(700, 600);
  game = new Game();
  minimax = new MiniMax();
  // check_bad_ai_1();
  
}

void draw() {
  
  game.show();
  
}

void mousePressed() {
  
  if (mouseButton == RIGHT) {  // undo button
    
    // game should go back twice to undo both the human (player 1) and AI (player 2)'s moves
    // but, if the human has won (so the AI didn't make any move), the game should only go back once
    if (game.player_won != 1) {
      game.go_back();
      current_state.remove(current_state.size() - 1);
    }
    game.go_back();
    current_state.remove(current_state.size() - 1);
    println(current_state, "is the current game state now");
    
    // put game back into an unfinished state
    game.player_won = 0;
    
    return;
  }
  
  int chosen_col;
  
  // player 1 (human)'s turn
  chosen_col = floor(float(mouseX)/width*game.cols);
  if (!(game.rows - game.col_height[chosen_col] > 0) || game.player_won != 0) return;
  // if human's move is not valid, or game is already finished, don't do anything
  game.add_piece(chosen_col);
  current_state.add(chosen_col);
  println(current_state, "is the current game state now");
  
  // player 2 (AI)'s turn
  chosen_col = minimax.choose_column(game);
  game.add_piece(chosen_col);
  current_state.add(chosen_col);
  println(current_state, "is the current game state now");
  println();
  
}

void check_bad_ai_1() {
  
 // ---- this particular set of moves (among others) puts ai into losing position
  
  // i should try to change the heuristic to avoid this, or simply try with depth > 0
  
  game.add_piece(1);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(3);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(0);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(4);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(6);
  game.add_piece(minimax.choose_column(game));
  
  // ----
  
}

void check_bad_ai_2() {
  
  // ---- this particular set of moves (among others) puts ai into losing position
  
  // UPDATE: fixed! I just changed the evalution function, giving more weight to alignments with more than one hole
  
  game.add_piece(2);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(3);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(4);
  game.add_piece(minimax.choose_column(game));
  
  // ----
  
}
