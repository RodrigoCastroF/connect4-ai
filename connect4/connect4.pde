Game game;
MiniMax minimax;

void setup() {
  
  size(700, 600);
  game = new Game();
  minimax = new MiniMax(game);
  
}

void draw() {
  
  game.show();
  
}

void mousePressed() {
  
  if (mouseButton == RIGHT) {  // undo button
    
    // game should go back twice to undo both the human (player 1) and AI (player 2)'s moves
    // but, if the human has won (so the AI didn't make any move), the game should only go back once
    if (game.player_won != 1) game.go_back();
    game.go_back();
    
    /* print("player1: "); for (int[] position : game.player1_positions) {
      print("[", position[0], ", ", position[1], "] ");
    } println();
    print("player2: "); for (int[] position : game.player2_positions) {
      print("[", position[0], ", ", position[1], "] ");
    } println(); println(); */
    
    return;
  }
  
  // player 1 (human)'s turn
  game.add_piece(floor(float(mouseX)/width*game.cols));
  /* print("player1: "); for (int[] position : game.player1_positions) {
    print("[", position[0], ", ", position[1], "] ");
  } println(); */
  
  // player 2 (AI)'s turn
  game.add_piece(minimax.choose_column());
  /* print("player2: "); for (int[] position : game.player2_positions) {
    print("[", position[0], ", ", position[1], "] ");
  } println(); println(); */
  
}
