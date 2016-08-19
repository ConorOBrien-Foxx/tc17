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

There are 16 number-related commands: `0` through `9` and `a` through `f`, which push to the stack `0` through `9` and `10` through `15`, respectively.

Other than that, there are stack manipulation commands:

 * `,` - pops `A` and pushes `1 / A` (regular division, not ruby division).
 * `#` - pops `V` and, if V != 0, drops the top of the stack.
 * `$` - drops the top of the stack.
 * `:` - duplicates the top of the stack.
 * `;` - returns the top of the stack.
 * `C` - clears the stack.
 * `D` - duplicates the entire stack.
 * `E` - pops `x` and pushes `x.empty?`.
 * `F` - converts the TOS to a float.
 * `I` - converts the TOS to an integer.
 * `L` - pushes the size of the stack.
 * `R` - pops `m`; pushes a random number in [0, m)
 * `S` - pops `x`; pushes `x.size`.
 * `_` - negates the top of the stack.
 * `g` - pops `a` then `i`; pushes `a[i]`.
 * `i` - pops `i` and pushes `input[i]`.
 * `l` - pops `x` then `y`; pushes `x >= y`.
 * `r` - pushes a random float in [0, 1).
 * `s` - returns the stack.
 * `~` - switches top two members of stack.

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

    @C0i:0~gSR~SRD0iggE.$s

It is left as an exercise to the reader to figure out how this works.