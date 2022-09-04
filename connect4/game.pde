class Game {
  
  int cols = 7;
  int rows = 6;
  // note that col = 0 will be the upper one, while col = cols - 1 will be the lower one (due to Processing's coordinate system)
  
  // representation of each game state
  // matrix with 0 when there is no piece, 1 when there is a piece of the 1st player, and 2 when there is a piece of the 2nd
  int board[][] = new int[cols][rows];
  
  // number of positions occupied in each column
  int col_height[] = new int[cols];  // source: https://stackoverflow.com/questions/2154251/any-shortcut-to-initialize-all-array-elements-to-zero
  
  // which player has the next move?
  boolean player1_turn = true;
  
  // record each player's positions - each position corresponds to a hole in the board, identified with [col, row]
  ArrayList<int[]> player1_positions = new ArrayList<int[]>(); 
  ArrayList<int[]> player2_positions = new ArrayList<int[]>(); 
  // ArrayList is like a regular array, but with more methods (like add, remove, or clear):
  // Processing reference: https://processing.org/reference/ArrayList.html
  // Java reference: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html 
  // Instead of two ArrayLists, I tried having an array (or ArrayList) with two ArrayLists, but I couldn't work with this
  
  // record the winning player and the positions pieces that made them win
  int player_won = 0;  // 0 if no player has yet won, 1 if the 1st has won, and 2 if the 2nd has won
  ArrayList<int[]> winning_positions = new ArrayList<int[]>();  // ArrayList of arrays
  
  
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
    if (rows - col_height[col] - 1 < 0 || player_won != 0) return;
    
    // position in which to put the piece
    int[] position = {col, rows - col_height[col] - 1};
    
    // udate the board, the height of the corresponding column, and the player's positions history
    board[position[0]][position[1]] =  player1_turn ? 1 : 2;
    col_height[col]++;
    (player1_turn ? player1_positions : player2_positions).add(position);
    
    // change turn
    player1_turn = !player1_turn;
    
    // check if a player has won after the move
    game.check_win();
    
    // ------ test of GameEvaluation
    GameEvaluation game_eval = new GameEvaluation(this);
    game_eval.evaluate();
    
  }
  
  void go_back() {
    
    /**
     * Rewinds back to the previous move
     * Used for the undo button
     * Also useful to search through several game states and then go back to the current state
     */
     
    // if previous player has no recorded positions (meaning we are at the beginning), don't do anything
    if ((player1_turn ? player2_positions : player1_positions).size() == 0) return;
     
    // get the last position from the previous player
    int[] last_position = player1_turn ? player2_positions.get(player2_positions.size()-1) : player1_positions.get(player1_positions.size()-1);
    
    // remove it from the board, the column's height record, and the player's positions history
    board[last_position[0]][last_position[1]] =  0;
    col_height[last_position[0]]--;
    (player1_turn ? player2_positions : player1_positions).remove(last_position);
    // println("removed [", last_position[0], ", ", last_position[1], "] from player", player1_turn ? "1" : "2");
    
    // change turn
    player1_turn = !player1_turn;
    
    // put game back into an unfinished state
    player_won = 0;
    
  }
  
  boolean check_alignment(int[] position, int[] step, int pieces_aligned, int player_index) {
    
    /**
     * Recursive function that detects if 4 pieces of the indicated player are aligned in a particular direction
     * @param position: current hole being visited, identified with [col, row]
     * @param step: the direction in question; vector [dif_col, dif_row] that gets added to position to calculate the new one
     * @param pieces_aligned: number of pieces of the player found consecutively in the direction considered
     * @param player_index: 1 or 2
     * @return: true if pieces_aligned reaches 4, false otherwise
     */
    
    // BASE CASE
    
    // true if we get to 4 pieces aligned
    if (pieces_aligned >= 4)
    {
      return true;
    }
    
    winning_positions.add(position);
    
    // false if we get out of board, or find a non-friendly piece
    if (position[0] < 0 || position[0] >= cols ||
        position[1] < 0 || position[1] >= rows ||
        board[position[0]][position[1]] != player_index)
    { 
      winning_positions.clear();
      return false; 
    }
    
    // RECURSIVE STEP
    
    int[] new_position = new int[2];
    new_position[0] = position[0] + step[0];
    new_position[1] = position[1] + step[1];
    
    return check_alignment(new_position, step, pieces_aligned + 1, player_index);
    
  }
  
  void check_win() {
    
    /**
     * Check if each player already has 4 pieces aligned and update player_won if necessary
     */
    
    for (int player_index = 1; player_index <= 2; player_index++) {
      for (int[] player_position : (player_index == 1 ? player1_positions : player2_positions)) {
        // this is for-each in Java ("enhanced for"); https://www.geeksforgeeks.org/for-each-loop-in-java/
        for (int[] step : steps) {
          if (check_alignment(player_position, step, 0, player_index)) {
            player_won = player_index;
            return;
          }
        }
      }
    }
    
  }
  
  
  int evaluate() { //<>//
    
    /**
     * Heuristic method to evaluate the current state of the game from the current player's perspective
     */
     
    // ... 
     
    return 0;
    
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
    color filling_color;
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {
        
        // show the pieces inside
        filling_color = color(255, 255, 255);  // white (no piece)
        if (board[col][row] == 1) filling_color = color(230, 49, 35);  // red (player 1's piece) //<>//
        if (board[col][row] == 2) filling_color = color(249, 224, 1);  // yellow (player 2's piece)
        
        // show shadows in holes if mouse is hovering over column and the game is yet to finish
        if (floor(float(mouseX)/width*cols) == col && rows - row > col_height[col] && player_won == 0) {
          if (player1_turn) filling_color = color(247, 191, 187);  // lighter red
          else filling_color = color(254, 241, 125);  // lighter yellow
        }
        
        // highlight the winning pieces if the game has finished
        if (player_won != 0) {
          // winning_positions.contains(winning_pos)  returns always false for some reason, so I have to do this:
          for (int[] winning_pos : winning_positions) {
            if (winning_pos[0] == col && winning_pos[1] == row) {
              filling_color = lerpColor(filling_color, color(255, 255, 255), sin(millis() / 100) * sin(millis() / 100));
            }
          }
        }
        
        fill(filling_color);
        ellipse(width*col/cols + diameter/2 + margin/2, height*row/rows + diameter/2 + margin/2, diameter, diameter);
        
      }
    }
    
  }
  
}


class GameEvaluation {
  
  Game game;
  ArrayList<ArrayList<int[]>> positions_visited = new ArrayList<>();
  
  GameEvaluation(Game game) {
    
    this.game = game;
    for (int[] step : game.steps) {
      positions_visited.add(new ArrayList<int[]>());
    }
    
  }
  
  int count_pieces_aligned(int[] position, int direction_index, int player_index) {
   
    /*
     * Counts the number of pieces of the specified player in the given direction, starting from the indicated position
     * @return: [ number of pieces aligned (int >= 0), number of holes on either side (0, 1 or 2) ]
     */
    
    /* if (positions_visited.contains(position))
    {
      return 0;
    } */
    // as explained bellow, 'contains' doesn't work as expected, so doing this is necessary...
    for (int[] pos_visited : positions_visited.get(direction_index)) {
      if (pos_visited[0] == position[0] && pos_visited[1] == position[1]) {
        return 0;
      }
    }
    
    // ArrayList<int[]> new_positions_visited = new ArrayList<>(positions_visited);
    // ^^ unnecesary, you can modify the parameter with no trouble
    
    positions_visited.get(direction_index).add(position);
    
    if (position[0] < 0 || position[0] >= game.cols ||
        position[1] < 0 || position[1] >= game.rows ||
        game.board[position[0]][position[1]] != player_index)
    { 
      return 0;
    }
    
    int[] new_position1 = new int[2];
    int[] new_position2 = new int[2];  // we will explore in the opposite direction too
    
    int[] direction = game.steps[direction_index];
    
    new_position1[0] = position[0] + direction[0];
    new_position1[1] = position[1] + direction[1];
    
    new_position2[0] = position[0] - direction[0];
    new_position2[1] = position[1] - direction[1];
    
    return count_pieces_aligned(new_position1, direction_index, player_index) +
           count_pieces_aligned(new_position2, direction_index, player_index) + 1;
    
  }
  
  void evaluate() {
    
    for (int player_index = 1; player_index <= 2; player_index++) {
      // player_index = game.player1_turn ? 1 : 2 
      for (int step_index = 0; step_index < game.steps.length; step_index++) {  // 'size()' with ArrayInt, 'length' with array
        for (int[] player_position : (player_index == 1 ? game.player1_positions : game.player2_positions)) {
          int num_pieces_aligned = count_pieces_aligned(player_position, step_index, player_index);
          if (num_pieces_aligned > 1) {
              println("player ", player_index, "'s pieces aligned",
                      " in direction [", game.steps[step_index][0], ", ", game.steps[step_index][1], "] ",
                      "counting from [", player_position[0], ", ", player_position[1], "]: ",
                      num_pieces_aligned);
            }
        }
      }
    }
    println();
    
  }
  
}
