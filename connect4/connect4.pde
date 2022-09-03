

Game game;

void setup() {
  
  size(700, 600);
  game = new Game();
  
}

void draw() {
  
  game.show();
  
}

void mousePressed() {
  
  game.add_piece(floor(float(mouseX)/width*game.cols));
  
  // System.out.println(java.util.Arrays.deepToString(game.winning_positions).replace("], ", "]\n"));
  // println();
  
  game.check_win();
  
}
