class MiniMax {
  
  Game game;
  
  MiniMax(Game game) {
    this.game = game; 
  }
  
  int choose_column() {
    
    int chosen_col;
    
    do {
      chosen_col = floor(random(game.cols));
    } while(game.rows - game.col_height[chosen_col] - 1 < 0);  // ensure the move is valid
    
    return chosen_col;
    
  }
  
}
