class Game {
  
  int cols = 7;
  int rows = 6;
  // note that col = 0 will be the upper one, while col = cols - 1 will be the lower one (due to Processing's coordinate system)
  
  // representation of each game state
  // matrix with 0 when there is no piece, 1 when there is a piece of the 1st player, and 2 when there is a piece of the 2nd
  int board[][] = new int[cols][rows];
  
  // number of positions occupied in each column
  int col_height[] = new int[cols];  // source: https://stackoverflow.com/questions/2154251/any-shortcut-to-initialize-all-array-elements-to-zero
  
  // which player has the next move? and, is the game finished?
  boolean player1_turn = true;
  boolean game_finished = false;
  
  // record each player's positions - player 1's positions in positions[0]; player 2's positions in positions[1]
  // each position corresponds to a hole in the board, identified with [col, row]
  int positions[][][] = new int[2][0][2];
  
  // the four directions in which a connect-4 can happen (vertical, horizontal, diagonal, inverse diagonal)
  int[][] steps = new int[][] {{0, 1}, {1, 0}, {1, 1}, {1, -1}};
  
  // diameter of the circles of the board and the margin between them
  float diameter = width/10;
  float margin = width/cols - diameter;
  
  void add_piece(int col) {
    
    /**
     * Adds a piece of the current player to the board, updating the necessary properties
     * @param col: column in which to add the piece
     */
    
    // if column is completely filled, or the game is already finished, don't do anything
    if (rows - col_height[col] - 1 < 0 || game_finished) return;
    
    // put piece on board
    int player_index = player1_turn ? 1 : 2;
    int[] position = {col, rows - col_height[col] - 1};
    board[position[0]][position[1]] = player_index;
    positions[player_index-1] = (int[][]) append(positions[player_index-1], position);
    
    // update the number of holes filled
    col_height[col]++;
    
    // change turn
    player1_turn = !player1_turn;
    
  }
  
  boolean check_alignment(int[] position, int[] step, int holes_visited, int pieces_aligned, int player_index) {
    
    /**
     * Recursive function that detects if 4 pieces of the indicated player are aligned in a particular direction
     * @param position: current hole being visited, identified with [col, row]
     * @param step: the direction in question; vector [dif_col, dif_row] that gets added to position to calculate the new one
     * @param holes_visited: number of holes visited so far
     * @param pieces_aligned: number of pieces of the player found consecutively in the direction considered
     * @param player_index: 1 or 2
     * @return: true if pieces_aligned reaches 4, false otherwise
     */
    
    // BASE CASE
    
    // true if we get to 4 pieces aligned; false if we get to 4 holes visited, or out of board
    if (pieces_aligned >= 4) return true;
    if (holes_visited >= 4 || position[0] < 0 || position[0] >= cols || position[1] < 0 || position[1] >= rows) return false;  
    
    // RECURSIVE STEP
    
    // if this position (continues to) have a piece of the player, increment pieces_aligned; otherwise, reset it back to 0
    int new_pieces_aligned = board[position[0]][position[1]] == player_index ? pieces_aligned + 1 : 0;
    
    int[] new_position = new int[2];
    new_position[0] = position[0] + step[0];
    new_position[1] = position[1] + step[1];
    
    return check_alignment(new_position, step, holes_visited + 1, new_pieces_aligned, player_index);
    
  }
  
  void check_win() {
    
    /**
     * Check if each player already has 4 pieces aligned and update game_finished if necessary
     */
    
    for (int player_index = 1; player_index <= 2; player_index++) {
      for (int[] player_position : positions[player_index-1]) {  // this is for-each in Java; https://www.geeksforgeeks.org/for-each-loop-in-java/
        for (int[] step : steps) {
          if (check_alignment(player_position, step, 0, 0, player_index)) {
            game_finished = true;
            return;
          }
        }
      }
    }
    
  }
  
  void show() {
    
    /**
     * Display the board on screen
     */
    
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
          if (player1_turn) fill(247, 191, 187);  // lighter red
          else fill(254, 241, 125);  // lighter yellow
        }
        
        ellipse(width*col/cols + diameter/2 + margin/2, height*row/rows + diameter/2 + margin/2, diameter, diameter);
        
      }
    }
    
  }
  
}
