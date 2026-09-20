From main menu, select 'New Quick Game.'

Then enter 'T' as your game name.

In game, hold left control and press 'S' to save your game.

Then, after you close your game, you can use the 'Load Game' feature to load your game.

In the game, you can use the arrow keys to move your character around, and '<' and '>' to move or down stairs, respectively.

You can click on the character 'portraits' in the upper left row to change control of your current character.

The game itself is just a proof of concept of a save/load system using json strings in game maker studio 2. It supports a potentially huge number of 
dungeon floors, limited mostly by practicality, as levels are loaded into memory only when necessary, and exist as data in json strings until they are loaded.

The game also demonstrates a line of sight system using a basic Bressenhan's Line Equation algorithm. The brick walls block vision, while the green 'forest' 
tiles only allow vision 1 tile deep, making forests ideal for ambushes/hiding.
