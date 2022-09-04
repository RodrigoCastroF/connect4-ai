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
  
  if (mouseButton == RIGHT) {  // undo button
    
    // game should go back twice to undo both the human (player 1) and AI (player 2)'s moves
    // but, if the human has won (so the AI didn't make any move), the game should only go back once
    if (game.player_won != 1) game.go_back();
    game.go_back();
    
    return;
  }
  
  /*  // println();
  // println("NEW BOARD----");
  
  // player 1 (human)'s turn
  game.add_piece(floor(float(mouseX)/width*game.cols));
  
  // println();
  // println("NEW BOARD----");
  
  // player 2 (AI)'s turn
  game.add_piece(minimax.choose_column(game));  */
  
  // ---- this particular set of moves (among others) puts ai into losing position
  
  // i should try to change the heuristic to avoid this, or simply try with depth > 0
  // also, when doing these moves by hand (instead of using this), sth weird happens when human wins (and this really should be fixed)
  
  game.add_piece(1);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(3);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(0);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(4);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(6);
  game.add_piece(minimax.choose_column(game));
  
  // ----
  
}
