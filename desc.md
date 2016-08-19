# A guide to desc

desc operators on a stack, but in the end compiles to a ruby lambda.

## Commands
Being compiled to ruby, there are some analogies to ruby and similar languages:

 * `w` is a `while` loop, using the top of the stack as a condition.
 * `u` is the same as `w`, but is `until` instead of `while`.
 * `@` is a do..while loop.
 * `?` is an if statement.

 * `.` is like `end`.

Since `.` is end, `w` followed by some stuff then `.` is a while loop.

Other than that, there are stack manipulation commands:

 * `,` - pops `A` and pushes `1 / A` (regular division, not ruby division).
 * `#` - pops `V` and, if V != 0, drops the top of the stack.
 * `$` - drops the top of the stack.
 * `:` - duplicates the top of the stack.
 * `;` - returns the top of the stack.
 * (more tba)

## Some examples

The simplest example from the config is the content of the cell insertion rule, `insert`:

    24a,rl#;

Diagrammed, this looks like:

    24a,rl#;                                            stack
    2         push 2                                    [2]
     4        push 4                                    [2, 4]
      a       push                                      [2, 4, 10]
       ,      push reciprᴏcal                           [2, 4, 1 / 10]
        r     push a random float in [0, 1)             [2, 4, 1 / 10, rand]
         l    is 1 / 10 <= rand?                        [2, 4, 1 / 10 <= rand]
          #   if so, pop the top value off the stack
           ;  return the top of the stack

When `rand >= 1/10`, we pop the top value of the stack, `4`, and return `2`. Otherwise, we return `4`. That is, there is a 90% chance that we return `2`, and a 10% chance that we return `4`.

#### Note! This is outdated

Here is a more complex example from the `insert rule` in the config:

    @C3R3RD0iggE.$s

Now, let's diagram this:

    @C3R3RD0iggE.$s                                                  stack
    @           .    this is a do..while loop over what's inside     []
     C               clears the stack                                []
      3R             push a random number in 0..3 (call it r_x)      [r_x]
        3R           (do it again; call it r_y)                      [r_x, r_y]
          D          duplicate the stack                             [r_x, r_y, r_x, r_y]
           0i        get the zeroeth input item (the grid)           [r_x, r_y, r_x, r_y, grid]
             g       pushes grid[r_y]                                [r_x, r_y, r_x, grid[r_y]]
              g      the same, with r_x                              [r_x, r_y, grid[r_y][r_x]]
               E     value representign the emptiness of the cell    [r_x, r_y, cell_is_empty]
                 $   drop the condition                              [r_x, r_y]
                  s  return the stack

In words, this find the first random non empty cell and returns its location.