class MiniMax {
  
  ArrayList<Integer> evaluated_state = new ArrayList<Integer> ();  // current evaluated state
  
  float deep_evaluate(Game game, int depth) {
    
    GameEvaluation game_eval = new GameEvaluation(game);
    
    if (depth == 0 || game.player_won != 0) {
      float evaluation = -game_eval.evaluate();
      println(evaluated_state, evaluation);
      return evaluation;
    }
    
    // ---- so far only tested for depth == 0. What follows is unexplored territory
    float evaluation;
    float max_evaluation = -10000;
    for (int col = 1; col < game.cols; col++) {
      
      // add piece to the studied game state
      game.add_piece(col);
      evaluated_state.add(col);
      
      // deeply evaluate game state after adding piece
      evaluation = -deep_evaluate(game, depth - 1);
      max_evaluation = max(evaluation, max_evaluation);
      
      // remove piece from the studied game state
      game.go_back();
      Object col_obj = (Integer) col;  // cast int into Object to use remove; see https://stackoverflow.com/questions/24115021/casting-int-to-object-on-java
      evaluated_state.remove(col_obj);
      
    }
    
    println(max_evaluation, -game_eval.evaluate());
    return max_evaluation;
    // ----
    
  }
  
  int choose_column(Game game) {
    
    int chosen_col = 0;
    float evaluation;
    float max_evaluation = -10000; //<>//
    
    if (game.player_won == 0) {  // only do stuff if game hasn't finished yet; otherwise, this will break things
      for (int col = 0; col < game.cols; col++) {
        if (game.rows - game.col_height[col] > 0) { // ensure moves considered are valid 
          
          game.add_piece(col);
          evaluated_state.add(col); 
          
          // deeply evaluate the game state after each move, taking the best one
          evaluation = deep_evaluate(game, 0);
          if (evaluation > max_evaluation) {
             max_evaluation = evaluation;
             chosen_col = col;
          }
          
          game.go_back();
          Object col_obj = (Integer) col;
          evaluated_state.remove(col_obj);
          
        }
      }
    }
    println();
    
    return chosen_col;
    
  }
  
}
