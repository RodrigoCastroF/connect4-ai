# Connect 4 Limited Depth MiniMax AI

Play against an AI of Connect 4 in Processing.

The AI uses the MiniMax algorithm (NegaMax variant) but,
as a difference with most other implementations,
it doesn't need to reach the end of the game in order to evaluate a move.
This is done using an evaluation function
that counts the pieces aligned (and their surrounding holes)
by each player for a particular board position.
More details bellow.

Even with a depth of 0 (the AI looks only at the current possible moves),
it is able to beat players that aren't paying enough attention to the board.
And with a depth of 4 (the AI looks 4 moves ahead),
I haven't been able to beat it.
Of course, it is still possible to beat it; a MiniMax implementation
with indefinite depth is able to do so.

## Evaluation function

After much experimentation, I concluded that
the best heuristic to evaluate a board position
for a particular player is this function:

$$ e = \sum_{a_{N}}   \prod_{h} { 4^{N - n} } $$

Where $a_{N}$ refers to every alignment of $N$ pieces (2 or 3) in the board,
and $h$ is each of the holes enclosing this alignment, if any.
Each hole can be at one end of the alignment or in the middle.
Finally, $n$ is the number of pieces that should be added to the board
in order to fill the corresponding hole.

That is, if `x` represents the pieces of the player we are evaluating,
`o` the opponent player's pieces,
and `.` the holes of the board:
- `oxxx.` will be counted as
an alignment with $N=3$ pieces and 1 hole of height $n=1$.
- `o.xx.o` will be counted as
an alignment with $N=2$ pieces and 2 holes of height $n=1$.
- `ox.x.o` will also be counted as
an alignment with $N=2$ pieces and 2 holes of height $n=1$.

Of course, being Connect 4 a zero-sum game,
the full evaluation of a player's position in the board
should be given by:

$$ E_{\mbox{player}} = e_{\mbox{player}} - e_{\mbox{opponent}} $$

For greater details, read the comments found in the
`GameEvaluation` class of `game.pde`.
