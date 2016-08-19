# tc17
**A customizable 2048**

## Backround info
This is an implementation of 2048 that uses `desc`, my own creation. It's a terse mini language that compiles to ruby. It is used for safe eval and compact storage of functions.

## Running the program

    ruby 2048.rb

You can use `wasd` to move up, left, down, and right, respectively. (This will be customizable soon.)

Currently, here are the customizable options:

* `objective`: this is the tile that triggers the game-end victory state. Default: `2048`.
* `initial`: this is what tile is first on the board. Default: `"empty"`.
* `insert`: this is a `desc` rule that details which cell is inserted after each term; it receives no input and is to output one numeric value. Default: `24a,rl#;`
* `insert rule`: this is a `desc` rule that takes the `grid` as input and outputs a coordinate pair `[x, y]` stating where to place the number given by `insert`.
* `cell width`: this is the visual width of the cell. Increase if you wish to have larger tiles fit more comfortably on your screen. Default: `6`.
* `start amount`: the amount of starting tiles on the screen. (spawns at least 1 tile) Default: `2`.
* `field`:
  * `width`: number of cells in a row. Default: `4`.
  * `height`: number of cells in a column. Default: `4`.

## Planned

* `deterministic` mode. Tiles always spawn in the top left corner, or closest tile after that (starting with (0, 0) then (1, 0), etc.).
* More choices for `cell width`, including `adjust` (starts at 6, and all cell width's increase to make room for larger tiles) and `dynamic` (each cell's width is equal to that of the longest number's length in that column).

## FAQ

**Q:** What does tc17 mean?

**A:** 2048 in base **t**hirteen is "c17". Also, github repos can't start with numbers.