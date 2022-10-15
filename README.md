# hangman
 
This is a ruby version of the popular game hangman. It is available live on Replit.

## How to play?

The computer draws a word from a list of the most frequently used words.

The length of the word is between 5 and 12 characters (ability to manipulate those values is a planned feature).

At the start of the game, the player knows only the lenght of the word. They must then try to guess individual letters
of the word. If the letter typed by the player appears in the word, all of its instances are revealed. If it does not
appear in the word, one guess is deducted from the number of available guesses.

The game ends when the word is guessed or the player runs out of guesses. The player may choose to play again or
exit the game.

## Saving and loading

When the program is launched, the player may choose to load a save game.

Saving the game is simple and may be performed by typing "save" instead of a guess.

Currently savefiles are not encrypted in any way and contain the full word, so opening them manually is not advised.

## Bugs

Any bugs should be reported using the issue functionality of GitHub.
