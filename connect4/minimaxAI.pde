class MiniMax {
  
  ArrayList<Integer> evaluated_state = new ArrayList<Integer> ();  // current evaluated state
  int max_depth;
  
  MiniMax(int depth) {
    max_depth = depth;
  }
  
  float deep_evaluate(Game game, int depth) {
    
    GameEvaluation game_eval = new GameEvaluation(game);
    
    if (depth == 0 || game.player_won != 0) {
      float evaluation = game_eval.evaluate();
      // println(evaluated_state, evaluation, " (for player", game.player_index_turn, ")");
      return evaluation;
    }
    
    float evaluation;
    float max_evaluation = -10000;
    for (int col = 0; col < game.cols; col++) {
      if (game.rows - game.col_height[col] > 0) {  // ensure only valid moves are considered 
      
        // add piece to the studied game state
        game.add_piece(col);
        evaluated_state.add(col);
        
        // deeply evaluate game state after adding piece
        evaluation = -deep_evaluate(game, depth - 1);
        max_evaluation = max(evaluation, max_evaluation);
        
        // remove piece from the studied game state
        game.go_back();
        evaluated_state.remove(evaluated_state.size() - 1);
      
      }
    }
    
    // println(evaluated_state, max_evaluation, " (for player", game.player_index_turn, ")");
    return max_evaluation;
    
  }
  
  int choose_column(Game game) {
    
    int chosen_col = 0;
    float evaluation;
    float max_evaluation = -10000;
     //<>//
    if (game.player_won == 0) {  // only do stuff if game hasn't finished yet; otherwise, this will break things
      for (int col = 0; col < game.cols; col++) {
        if (game.rows - game.col_height[col] > 0) {
          
          game.add_piece(col);
          evaluated_state.add(col); 
          
          // deeply evaluate the game state after each move, taking the best one
          evaluation = -deep_evaluate(game, max_depth);
          if (evaluation > max_evaluation) {
             max_evaluation = evaluation;
             chosen_col = col;
          }
          
          game.go_back();
          evaluated_state.remove(evaluated_state.size() - 1);
          
        }
      }
    }
    
    return chosen_col;
    
  }
  
}
