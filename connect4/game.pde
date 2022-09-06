class Game {
  
  int cols = 7;
  int rows = 6;
  // note that col = 0 will be the upper column, while col = cols - 1 will be the lower one (due to Processing's coordinate system)
  
  // representation of each game state
  // matrix with 0 when there is no piece, 1 when there is a piece of the 1st player, and 2 when there is a piece of the 2nd
  int board[][] = new int[cols][rows];
  
  // number of positions occupied in each column
  int col_height[] = new int[cols];  // this initializes as an array of 0s, source: https://stackoverflow.com/questions/2154251/any-shortcut-to-initialize-all-array-elements-to-zero
  
  // index (1 or 2) of the player that has the next move (initially player 1)
  int player_index_turn = 1;
  
  // record each player's positions - the first ArrayList corresponds to player 1's positions; the second to player 2's positions;
  // and the ArrayList inside each of them contains the arrays [col, row] that represent the positions of the corresponding player
  ArrayList<ArrayList<int[]>> players_positions = new ArrayList<ArrayList<int[]>>();
  // ArrayList is like a regular array, but with more methods (like add, remove, or clear):
  // Processing reference: https://processing.org/reference/ArrayList.html
  // Java reference: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html 
  
  // record the winning player and the positions pieces that made them win
  int player_won = 0;  // 0 if no player has yet won, 1 if player 1 has won, and 2 if player 2 has won
  ArrayList<int[]> winning_positions = new ArrayList<int[]>();  // ArrayList of arrays
  
  // the four directions in which a connect-4 can happen (vertical, horizontal, diagonal, inverse diagonal)
  int[][] steps = new int[][] {{0, 1}, {1, 0}, {1, 1}, {1, -1}};
  
  // diameter of the circles of the board and the margin between them
  float diameter = width/10;
  float margin = width/cols - diameter;
  
  Game() {
    
    // initialize the positions occupied by each player
    for (int player_index = 1; player_index <= 2; player_index++) {
      players_positions.add(new ArrayList<int[]>());
    }
    
  }
  
  void add_piece(int col) {
    
    /**
     * Adds a piece of the current player to the board, updating the necessary properties
     * @param col: column in which to add the piece
     */
    
    // if column is completely filled, don't do anything
    if (rows - col_height[col] - 1 < 0) return;
    
    // position in which to put the piece
    int[] position = {col, rows - col_height[col] - 1};
    
    // udate the board, the height of the corresponding column, and the player's positions history
    board[position[0]][position[1]] =  player_index_turn;
    col_height[col]++;
    players_positions.get(player_index_turn-1).add(position);
    
    // change turn (1 --> 2;  2 --> 1)
    player_index_turn = 3 - player_index_turn;
    
    // check if a player has won after the move
    game.check_win();
    
  }
  
  void go_back() {
    
    /**
     * Rewinds back to the previous move
     * Used for the undo button in the main program
     * Also used by MiniMax to search through several game states and then go back to the current state
     */
     
    int previous_player_index = 3 - player_index_turn;
     
    // if previous player has no recorded positions (meaning we are at the beginning), don't do anything
    if (players_positions.get(previous_player_index-1).size() == 0) return;
     
    // get the last position from the previous player
    int[] last_position = players_positions.get(previous_player_index-1).get( players_positions.get(previous_player_index-1).size() - 1 );
    
    // remove it from the board, the column's height record, and the previous player's positions history
    board[last_position[0]][last_position[1]] =  0;
    col_height[last_position[0]]--;
    players_positions.get(previous_player_index-1).remove(last_position);
    
    // change turn
    player_index_turn = 3 - player_index_turn;
    
    // put game back into an unfinished state
    game.player_won = 0;
    
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
      for (int[] player_position : players_positions.get(player_index-1)) {
        // this is for-each in Java ("enhanced for"); https://www.geeksforgeeks.org/for-each-loop-in-java/
        for (int[] step : steps) {
          if (check_alignment(player_position, step, 0, player_index)) {
            player_won = player_index; //<>//
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
    color filling_color;
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {
        
        // show the pieces inside
        filling_color = color(255, 255, 255);  // white (no piece)
        if (board[col][row] == 1) filling_color = color(230, 49, 35);  // red (player 1's piece)
        if (board[col][row] == 2) filling_color = color(249, 224, 1);  // yellow (player 2's piece)
        
        // show shadows in holes if mouse is hovering over column and the game is yet to finish
        if (floor(float(mouseX)/width*cols) == col && rows - row > col_height[col] && player_won == 0) {
          filling_color = player_index_turn == 1 ? color(247, 191, 187) : color(254, 241, 125);  // lighter red or yellow 
        }
        
        // highlight the winning pieces if the game has finished
        if (player_won != 0) {
          // winning_positions.contains(winning_pos)  returns always false for some reason, so I have to do this:
          for (int[] winning_pos : winning_positions) {
            if (winning_pos[0] == col && winning_pos[1] == row) { //<>//
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
  
  // the pieces' positions that have already been visited in each direction -
  // we have an ArrayList of arrays for each of the 4 directions, contained in another ArrayList
  ArrayList<ArrayList<int[]>> positions_visited = new ArrayList<>();
  
  // holes enclosing the aligned pieces of each player, for every direction, and for every starting position
  // and, in each case, the ArrayList has 0, 1 or 2 positions
  ArrayList<ArrayList<ArrayList<ArrayList<int[]>>>> enclosing_holes = new ArrayList<>();
  
  GameEvaluation(Game game) {
    
    this.game = game;
    
    // initialize the positions visited
    for (int step_index = 0; step_index < game.steps.length; step_index++) {
      positions_visited.add(new ArrayList<int[]>());
    }
    
    // initialize the enclosing holes
    for (int player_index = 1; player_index <=2; player_index++) {
      enclosing_holes.add(new ArrayList<ArrayList<ArrayList<int[]>>>());
      for (int step_index = 0; step_index < game.steps.length; step_index++) {
        enclosing_holes.get(player_index-1).add(new ArrayList<ArrayList<int[]>>());
      } 
    }
    
  }
  
  int count_aligned_pieces(int[] position, int pos_index, int step_index, int player_index, int jumps, int positions_explored) {
   
    /**
     * Counts the number of aligned pieces of the specified player in the given direction (step), starting from the indicated position
     * Also updates the enclosing holes around these pieces (which are 0, 1 or 2 positions)
     * @position: current position of the board being explored
     * @pos_index: index of the first position explored (the piece from which the method was called) in the player's recorded positions
     * @step_index: index of the direction, given by its position in {{0, 1}, {1, 0}, {1, 1}, {1, -1}} (as defined above)
     * @player_index: index of the player (1 or 2) whose pieces are being counted
     * @jumps: initially 1, turns into 0 when one blank space is skipped (which is allowed, to count positions like x.xx as connect3s)
     * @positions_explored: initially 4, decrements with every call of the method
     */
    
    // don't explore the same pieces again
    for (int[] pos_visited : positions_visited.get(step_index)) {
      if (pos_visited[0] == position[0] && pos_visited[1] == position[1]) {
        return 0;
      }
    }
    
    // stop exploring if we get out of the board or reach an enemy piece
    if (position[0] < 0 || position[0] >= game.cols ||
        position[1] < 0 || position[1] >= game.rows ||
        game.board[position[0]][position[1]] == 3 - player_index)  // 3 - player_index gives us the opponent's index
    { 
      return 0;
    }
    
    // new positions to explore (in the direction of the step, and in the opposite one too)
    int[] new_position1 = new int[2];
    int[] new_position2 = new int[2];
    
    int[] direction = game.steps[step_index];
    
    new_position1[0] = position[0] + direction[0];
    new_position1[1] = position[1] + direction[1];
    
    new_position2[0] = position[0] - direction[0];
    new_position2[1] = position[1] - direction[1];
    
    // if we reach an empty space, add it to the enclosing holes ArrayList,
    // and only continue exploring if method hasn't used its jump yet
    if (game.board[position[0]][position[1]] == 0)
    {
      if (jumps > 0 && positions_explored > 0)
      {
        enclosing_holes.get(player_index-1).get(step_index).get(pos_index).add(position);
        return count_aligned_pieces(new_position1, pos_index, step_index, player_index, jumps - 1, positions_explored - 1) +
               count_aligned_pieces(new_position2, pos_index, step_index, player_index, jumps - 1, positions_explored - 1);
      }
      return 0;
    }
    
    // if we have gone this far, then we know this position is a current player's piece position,
    // and we can safely add it to the visited positions
    positions_visited.get(step_index).add(position);
    
    return count_aligned_pieces(new_position1, pos_index, step_index, player_index, jumps, positions_explored - 1) +
           count_aligned_pieces(new_position2, pos_index, step_index, player_index, jumps, positions_explored - 1) + 1;
    
  }
  
  float evaluate_player(int player_index) {
    
    /**
     * Evaluates the given player's position in the board (heuristic method)
     * The method goes through all connect2s and connect3s, enclosed by at least one hole, that the player has
     *
     * The function is given by:
     * eval = sum(connectN){ prod(hole){4 ^ (N - height required to fill the hole)} }
     * 
     * MAJOR DRAWBACKS:
     * 1) It ignores configurations like .x.x, and gives little value to others like x.xx (it would work fine with ..xx and .xxx)
     *    ^ Fixed by letting count_aligned_pieces jump one blank space
     * 2) It doesn't take into account which player has the turn. Consider this position:
     *     .....
     *     ....x
     *     ....x
     *     ooo.x
     *    In this case, the method would give an equal evaluation to both players, even if x has the turn and will, therefore, win
     * 3) There is value given to positions like .xxo, even though they are actually useless
     */
    
    int num_pieces_aligned;
    ArrayList<int[]> enclosing_holes_here;
    int evaluation = 0;
    
    ArrayList<int[]> player_positions;
    int[] position;
    
    int height_required;
    float evaluation_for_alignment;
    
    // if player has won, change their evaluation to a very high number
    if (game.player_won == player_index) return 1000;
    
    // get all aligned pieces, iterating over all directions and starting positions for the given player
    for (int step_index = 0; step_index < game.steps.length; step_index++) {  // Java has 'size()' for ArrayList, and 'length' for array
      player_positions = game.players_positions.get(player_index-1);
      
      for (int pos_index = 0; pos_index < player_positions.size(); pos_index++) {
        position = player_positions.get(pos_index);
        
        // add empty array to enclosing holes to avoid a NullPointerException
        enclosing_holes.get(player_index-1).get(step_index).add(new ArrayList<int[]>());
        
        // calculate the number of aligned pieces and retrieve the updated enclosing holes (which will no longer be empty)
        num_pieces_aligned = count_aligned_pieces(position, pos_index, step_index, player_index, 1, 4);
        enclosing_holes_here = enclosing_holes.get(player_index-1).get(step_index).get(pos_index);
        
        if (num_pieces_aligned > 1 && enclosing_holes_here.size() > 0) {
          /* print("player", player_index, "'s pieces aligned",
                "in direction [", game.steps[step_index][0], ", ", game.steps[step_index][1], "]",
                "counting from [", position[0], ", ", position[1], "]: ",
                num_pieces_aligned, " , with these", enclosing_holes_here.size(), "holes on either side: "); */
          evaluation_for_alignment = 1;
          for (int[] enclosing_hole : enclosing_holes_here) {
            /* print("[", enclosing_hole[0], ", ", enclosing_hole[1], "]",
                  "(height required:", (game.rows - enclosing_hole[1]) - game.col_height[enclosing_hole[0]],") "); */
            height_required = (game.rows - enclosing_hole[1]) - game.col_height[enclosing_hole[0]];
            // ^ number of pieces that need to be added to fill the whole
            evaluation_for_alignment *= pow(4, num_pieces_aligned - height_required);
          }
          evaluation += evaluation_for_alignment;
          // println();
        } 
      }
    }
    
    return evaluation;
    
  }
  
  float evaluate() {
    
    /**
     * Gives a full evaluation of the current player (their evaluation minus their opponent's evaluation)
     */
    
    float evaluation = evaluate_player(1) - evaluate_player(2);
    if (game.player_index_turn == 2) evaluation = -evaluation;
    
    return evaluation;
    
  }
  
}
