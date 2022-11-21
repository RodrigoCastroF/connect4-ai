# Connect 4 Limited Depth MiniMax AI

Play against an AI of Connect 4 in Processing.

The AI uses the **MiniMax algorithm (NegaMax variant)** but,
as a difference with most other implementations,
it does not need to reach all possible terminating game states
in order to evaluate a move.
Instead, the AI looks only a limited number of moves ahead
(four moves).

This is achieved using an evaluation function
that counts the pieces aligned (and their surrounding holes)
by each player for a particular board position.
Using this function, it is possible to evaluate a non-terminating game state.
More details below.

As the AI does not look arbitrarily far into future game states,
a human or computer program that thinks farther ahead is able to defeat it.
However, I found that, even with a depth of just four moves,
beating this AI is challenging for a human.

## Evaluation function

After much experimentation, I came to the conclusion that
the following function is the best heuristic to
assess a board position for a certain player:

$$ e = \sum_{a_{N}}   \prod_{h_{n}} { 4^{N - n} } $$

Where $a_{N}$ refers to every alignment of $N$ pieces (2 or 3)
of the player in the board,
and $h_{n}$ is each of the holes enclosing this alignment, if any.
Each hole can be at one end of the alignment or in the middle.
Finally, $n$ is the number of pieces that must be added to the board
in order to fill the hole $h_{n}$.

That is, if `x` represents the pieces of the player we are evaluating,
`o` the opponent player's pieces,
and `.` the holes of the board:
- `.xxx.` will be counted as
an alignment with $N=3$ pieces and 2 holes of height $n=1$,
so it will add $4^{3 - 1} \cdot 4^{3 - 1} = 256$ to the evaluation
of the player's position.
- `oxxx.` will be counted as
an alignment with $N=3$ pieces and only 1 hole of height $n=1$,
so it will add $4^{3 - 1} = 16$ to the evaluation.
- `oxx.x.` will also be counted as
an alignment with $N=3$ pieces and 1 hole of height $n=1$,
adding $4^{3 - 1} = 16$ to the evaluation.
- `oxx.` will be counted as
an alignment with $N=2$ pieces and 1 hole of height $n=1$,
so it will add $4^{2 - 1} = 4$ to the evaluation.

Of course, being Connect 4 a zero-sum game,
the full evaluation of a player's position in the board
should be given by:

$$ E_{\mbox{player}} = e_{\mbox{player}} - e_{\mbox{opponent}} $$

For greater details, read the comments found in the
`GameEvaluation` class of `game.pde`.
