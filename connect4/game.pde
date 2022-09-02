class Game {
  
  int cols = 7;  // "final" is the "const" of Java for primitives; see https://www.javamex.com/java_equivalents/const_java.shtml
  int rows = 6;
  // note that col = 0 will be the upper one, while col = cols - 1 will be the lower one (due to Processing's coordinate system)
  
  // representation of each game state
  // matrix with 0 when there is no piece, 1 when there is a piece of the 1st player, and 2 when there is a piece of the 2nd
  int board[][] = new int[cols][rows];
  
  // number of positions occupied in each column
  int col_height[] = new int[cols];  // source: https://stackoverflow.com/questions/2154251/any-shortcut-to-initialize-all-array-elements-to-zero
  
  // which player has the next move?
  boolean player1 = true;
  
  // is the game finished?
  boolean game_finished = false;
  
  // diameter of circles and margin between them
  float diameter = width/10;
  float margin = width/cols - diameter;
  
  void add_piece(int col) {
    
    // if column is completely filled, don't do anything
    if (rows - col_height[col] - 1 < 0) return;
    
    // if game is already finished, don't do anything either
    if (game_finished) return;
    
    // put piece on board
    board[col][rows - col_height[col] - 1] = player1 ? 1 : 2;  // both C++ and Java have "?" 
    
    // update the number of holes filled
    col_height[col]++;
    
    // change turn
    player1 = !player1;
    
  }
  
  boolean check_vertical_alignment(int col, int row, int pieces_aligned, int player_index) {
    
    /**
     * Returns true when player of the specified 'player_index' (1 or 2) has 4 pieces vertically aligned
     * In order to check for vertical alignment overall, this method should be called for all columns 'col'
     * The parameters 'row' and 'pieces_aligned' should be 0 when the method is called
     */
    
    // base cases: 4 pieces aligned, or reached end of board
    if (pieces_aligned >= 4) return true;
    if (row >= rows) return false;  
    
    // recursive step
    return check_vertical_alignment(col, row + 1, board[col][row] == player_index ? pieces_aligned + 1 : 0, player_index);
    
  }
  
  boolean check_horizontal_alignment(int col, int row, int pieces_aligned, int player_index) {
    
    /**
     * Returns true when player of the specified 'player_index' (1 or 2) has 4 pieces horizontally aligned
     * In order to check for horizontal alignment overall, this method should be called for all rows 'row'
     * The parameters 'col' and 'pieces_aligned' should be 0 when the method is called
     */
    
    if (pieces_aligned >= 4) return true;
    if (col >= cols) return false;  
    
    return check_horizontal_alignment(col + 1, row, board[col][row] == player_index ? pieces_aligned + 1 : 0, player_index);
    
  }
  
  boolean check_diagonal_alignment(int col, int row, int pieces_aligned, int player_index) {
    
    /**
     * Returns true when player of the specified 'player_index' (1 or 2) has 4 pieces diagonally aligned
     * The pieces need to be parallel to the "MAIN" diagonal, from the top-left to the bottom-right corner
     * In order to check for diagonal alignment overall, this method should be called for all holes ('col', 'row')
       that have either col=0 or row=0
     * The parameter 'pieces_aligned' should be 0 when the method is called
     */
    
    if (pieces_aligned >= 4) return true;
    if (row >= rows || col >= cols) return false;  
    
    return check_diagonal_alignment(col + 1, row + 1, board[col][row] == player_index ? pieces_aligned + 1 : 0, player_index);
    
  }
  
  boolean check_inverse_diagonal_alignment(int col, int row, int pieces_aligned, int player_index) {
    
    /**
     * Returns true when player of the specified 'player_index' (1 or 2) has 4 pieces aligned parallely to the "inverse" diagonal
     * The "INVERSE" diagonal comes from the bottom-left to the top-right corner
     * In order to check for "inverse" diagonal alignment overall, this method should be called for all holes ('col', 'row')
       that have either col=0 or row=rows-1
     * The parameter 'pieces_aligned' should be 0 when the method is called
     */
    
    if (pieces_aligned >= 4) return true;
    if (row < 0 || col >= cols) return false;  
    
    return check_inverse_diagonal_alignment(col + 1, row - 1, board[col][row] == player_index ? pieces_aligned + 1 : 0, player_index);
    
  }
  
  void check_win() {
    
    /**
     * Check if a player already has 4 pieces aligned
     * Uses the previous four methods
     */
    
    // check vertical alignments
    for (int col = 0; col < cols; col++) {
       if (check_vertical_alignment(col, 0, 0, 1) || check_vertical_alignment(col, 0, 0, 2)) {
         game_finished = true;
       }
    }
    
    // check horizontal alignments
    for (int row = 0; row < rows; row++) {
       if (check_horizontal_alignment(0, row, 0, 1) || check_horizontal_alignment(0, row, 0, 2)) {
         game_finished = true;
       }
    }
    
    // check diagonal alignments
    for (int col = 0; col < cols; col++) {
       if (check_diagonal_alignment(col, 0, 0, 1) || check_diagonal_alignment(col, 0, 0, 2)) {
         game_finished = true;
       }
    }
    for (int row = 0; row < rows; row++) {
       if (check_diagonal_alignment(0, row, 0, 1) || check_diagonal_alignment(0, row, 0, 2)) {
         game_finished = true;
       }
    }
    
    // check inverse diagonal alignments
    for (int col = 0; col < cols; col++) {
       if (check_inverse_diagonal_alignment(col, rows - 1, 0, 1) || check_inverse_diagonal_alignment(col, 0, 0, 2)) {
         game_finished = true;
       }
    }
    for (int row = 0; row < rows; row++) {
       if (check_inverse_diagonal_alignment(0, row, 0, 1) || check_inverse_diagonal_alignment(0, row, 0, 2)) {
         game_finished = true;
       }
    }
    
  }
  
  void show() {
    
    // give the background blue color
    background(0, 116, 179);
    
    // give the outline of the holes a darker blue color and make it thicker
    stroke(1, 74, 114);
    strokeWeight(5);
  
    // show the holes
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {
        
        // show the pieces inside
        fill(255, 255, 255);  // white (no piece)
        if (board[col][row] == 1) fill(230, 49, 35);  // red (player 1's piece)
        if (board[col][row] == 2) fill(249, 224, 1);  // yellow (player 2's piece)
        
        // show shadows in holes if mouse is hovering over column and the game is yet to finish
        if (floor(float(mouseX)/width*cols) == col && rows - row > col_height[col] && !game_finished) {
          if (player1) fill(247, 191, 187);  // lighter red
          else fill(254, 241, 125);  // lighter yellow
        }
        
        ellipse(width*col/cols + diameter/2 + margin/2, height*row/rows + diameter/2 + margin/2, diameter, diameter);
        
      }
    }
    
  }
  
}
