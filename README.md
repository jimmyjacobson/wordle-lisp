Thoughts on solving World programatically.

1. Given the current state of the game, generate a regex that can be run against /usr/share/dict/web2 to return possible solutions

2. AI Wordle, given a randomly selected word, and a random starting word, use the algorithm in 1 to generate guesses to solve the Wordle.  This sounds like fun.  Can I use pplot or something to show the world board?

3. Bonus, can we make something shareable like the addictive emoji output? 🟩🟨⬜️

input: a five letter word

game state:
- turn tracker
- data structure of guesses
- data structure of response prompts
  - valid character, valid position
  - valid character, invalid position
  - invalid character, position data does not apply
- data structure for generating regex
  - 26 integer array with values for valid/valid, valid/invalid, invalid/invalid
  
Multiple Games (Player)
- Games Played
- Games Won
- Current Streak
- Guess Distribution
- Max Streak

Represent response as a cons list?
'(1.1) (0.0) (1.0) (0.0)

output: game state, halt

Player 
