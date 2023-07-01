Game game;
GameEvaluation game_eval;
MiniMax minimax;
ArrayList<Integer> current_state = new ArrayList<Integer> ();  // current board position (as the sequence of moves played)

void setup() {
  
  size(700, 600);
  game = new Game();
  minimax = new MiniMax(3);
  
  /* int[] starting_state = {1, 0, 2, 3, 2, 0, 2, 2, 4};
  for (int move: starting_state) {
    game.add_piece(move);
    current_state.add(move);
  }
  if (game.player_index_turn == 2) {  // let AI take its first turn
    int chosen_col = minimax.choose_column(game);
    game.add_piece(chosen_col);
    current_state.add(chosen_col);
    println(current_state, "is the current game state now");
  } */
  
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
  
  // PLAYER 1 (HUMAN)'S TURN
  
  chosen_col = floor(float(mouseX)/width*game.cols);
  
  if (!(game.rows - game.col_height[chosen_col] > 0) || game.player_won != 0) return;
  // if human's move is not valid, or game is already finished, don't do anything
  
  game.add_piece(chosen_col);
  current_state.add(chosen_col);
  println(current_state, "is the current game state now");
  
  game_eval = new GameEvaluation(game);
  println("Evaluation for player 1:", game_eval.evaluate_player(1));
  println("Evaluation for player 2:", game_eval.evaluate_player(2));
  
  // PLAYER 2 (AI)'S TURN
  // (Comment out this whole section to play human vs. human)
  
  chosen_col = minimax.choose_column(game);
  
  game.add_piece(chosen_col);
  current_state.add(chosen_col);
  println(current_state, "is the current game state now");
  
  game_eval = new GameEvaluation(game);
  println("Evaluation for player 1:", game_eval.evaluate_player(1));
  println("Evaluation for player 2:", game_eval.evaluate_player(2));
  
  println();
  
}
