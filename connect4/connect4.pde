

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
  
  // System.out.println(java.util.Arrays.deepToString(game.positions[0]).replace("], ", "]\n"));
  // System.out.println(java.util.Arrays.deepToString(game.positions[1]).replace("], ", "]\n"));
  // println();
  // from https://stackoverflow.com/questions/19648240/the-best-way-to-print-a-java-2d-array
  
  game.check_win();
  
}
