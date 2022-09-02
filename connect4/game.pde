class Game {
  
  int cols = 7;  // "final" is the "const" of Java for primitives; see https://www.javamex.com/java_equivalents/const_java.shtml
  int rows = 6;
  
  // representation of each game state
  // matrix with 0 when there is no piece, 1 when there is a piece of the 1st player, and 2 when there is a piece of the 2nd
  int board[][] = new int[cols][rows];
  
  // number of positions occupied in each column
  int col_height[] = new int[cols];  // source: https://stackoverflow.com/questions/2154251/any-shortcut-to-initialize-all-array-elements-to-zero
  
  // which player has the next move
  boolean player1 = true;
  
  // diameter of circles and margin between them
  float diameter = width/10;
  float margin = width/cols - diameter;
  
  void add_piece(int col) {
    
    // put piece on board
    if (player1) {
      board[col][rows - col_height[col] - 1] = 1;
    } else {
      board[col][rows - col_height[col] - 1] = 2;
    }
    
    // update the number of holes filled
    col_height[col]++;
    
    // change turn
    player1 = !player1;
    
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
        
        // show shadows if mouse is hovering over column
        if (floor(float(mouseX)/width*cols) == col && rows - row > col_height[col]) {
          if (player1) {
            fill(247, 191, 187);  // lighter red
          } else {
            fill(255, 247, 175);  // lighter yellow
          }
        }
        
        ellipse(width*col/cols + diameter/2 + margin/2, height*row/rows + diameter/2 + margin/2, diameter, diameter);
        
      }
    }
    
  }
  
}
