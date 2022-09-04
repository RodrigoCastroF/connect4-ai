class MiniMax {
  
  float deep_evaluate(Game game, int depth) {
    
    GameEvaluation game_eval = new GameEvaluation(game);
    
    if (depth == 0) {
      return -game_eval.evaluate();
    }
    
    // ---- so far only tested for depth == 0. What follows is unexplored territory
    float evaluation;
    float max_evaluation = -10000;
    for (int col = 1; col < game.cols; col++) {
      game.add_piece(col);
      evaluation = deep_evaluate(game, depth - 1);
      max_evaluation = max(evaluation, max_evaluation);
      game.go_back();
    }
    return max_evaluation;
    // ----
    
  }
  
  int choose_column(Game game) {
    
    int chosen_col = -1;
    float evaluation;
    float max_evaluation = -10000;
     
    /* do {
      chosen_col = floor(random(game.cols));
    } while(game.rows - game.col_height[chosen_col] - 1 < 0);  // ensure the move is valid */
    
    for (int col = 0; col < game.cols; col++) {
      game.add_piece(col);
      evaluation = deep_evaluate(game, 0);
      println(col, evaluation);
      if (evaluation > max_evaluation) {
         max_evaluation = evaluation;
         chosen_col = col;
      }
      game.go_back();
    }
    println();
    
    return chosen_col;
    
  }
  
}
