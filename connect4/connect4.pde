Game game;
MiniMax minimax;

void setup() {
  
  size(700, 600);
  game = new Game();
  minimax = new MiniMax();
  // check_bad_ai_2();
  
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
    
    // put game back into an unfinished state
    game.player_won = 0;
    
    return;
  }
  
  // player 1 (human)'s turn
  int chosen_col = floor(float(mouseX)/width*game.cols);
  if (!(game.rows - game.col_height[chosen_col] > 0)) return;  // if human's move is not valid, don't do anything
  game.add_piece(chosen_col);
  
  // player 2 (AI)'s turn
  game.add_piece(minimax.choose_column(game));
  
}

void check_bad_ai_1() {
  
 // ---- this particular set of moves (among others) puts ai into losing position
  
  // i should try to change the heuristic to avoid this, or simply try with depth > 0
  
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

void check_bad_ai_2() {
  
 // ---- this particular set of moves (among others) puts ai into losing position
  
  // i should try to change the heuristic to avoid this, or simply try with depth > 0
  
  game.add_piece(2);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(3);
  game.add_piece(minimax.choose_column(game));
  
  game.add_piece(4);
  game.add_piece(minimax.choose_column(game));
  
  // ----
  
}
