Game game;
MiniMax minimax;

void setup() {
  
  size(700, 600);
  game = new Game();
  minimax = new MiniMax();
  
}

void draw() {
  
  game.show();
  
}

void mousePressed() {
  
  // player 1 (human)'s turn
  game.add_piece(floor(float(mouseX)/width*game.cols));
  
  // player 2 (AI)'s turn
  game.add_piece(minimax.choose_column(game));
  
}
