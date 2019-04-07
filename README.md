# SudokuGame
Java/Processing implementation of a Sudoku client

![Image of Application](https://i.imgur.com/tUWzQhe.png)

Loads three currently known file types to me;

## Single Line Problems
These problems come in a single line, currently I have only seen one with 0's for empty's but plan to update to include '.' for empty
```
029650178705180600100900500257800309600219005900007046573400021800020453010395000
```

## 9x9 problems
These problems display the puzzle in a 9x9 layout such examples can be seen [on this Sudoku research page](http://lipas.uwasa.fi/~timan/sudoku/) from the University of Vaasa

## Custom Save Files - .psud (From this application)
These files are in the form of a single line problem, however contain extra data, the file is three lines long, the first line contains the current state of the problem. The second line contains saved note information. The third contains which tiles are "Locked" in the game.

The following is an example.
```
105627084876493215400518006600350800310876052058042003200060000060080020500234000
[1,0,0,0,0,0,0,0,0].[0,0,1,0,0,0,0,0,1].[0,0,0,0,1,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,1,0,0,0,0,0,1].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[1,0,0,0,0,0,0,0,1].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[1,0,0,0,0,0,0,0,1].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,1,0].[1,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,1,1,0,0,0,0].[0,0,0,1,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[1,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,1,1,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,1,0].[1,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0].[0,0,0,0,0,0,0,0,0]
000101001010010010100010001100010100110000011001010001100010000010010000100101000
```

# To-Do
- [x] Load Button (Instead of quitting to restart)
- [ ] Condition checking
- [ ] Completion notification

# Controls
:one: - :nine: are used to enter values into tiles

Directional Keys allow for moving tiles, Mouse can also be used instead (can ignore input when mouse is moving while clicking).

Apostrophe (') changes the mode in and out of note-taking mode which will be indicated by a red background and text at the top of the UI.


Backspace and Delete will remove the guessed value.

To remove a note just use the number again while in note mode.

Notes will not be removed when entering a value. Deleting the value will re-display the notes.
