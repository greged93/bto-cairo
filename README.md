# Introduction

The goal of the library is to allow user to input a binary tree representation of a function which is then executed through
iterating the tree. A valid tree would look like:

```
            is_le
          /       \
        add       abs
       /   \        \
     mul   div       g
    / \    / \
  pow  c  d  mod
  / \        / \
 a   b      e   f
```

A node is represented by the following structure, where left and right hold the relative offset in the array to their children node or -1 if the node doesn't have a valid branch in that direction:

```
    struct Tree {
    value: felt,
    left: felt,
    right: felt,
}
```

The following is the array representation of the previous tree:

```
[{is_le, 1, 12}, {add, 1, 6}, {mul, 1, 4}, {pow, 1, 2}, {a, -1, -1}, {b, -1, -1}, {c, -1, -1}, {div, 1, 2}, {d, -1, -1}, {mod, 1, 2}, {e, -1, -1}, {f, -1, -1}, {abs, -1, 1}, {g, -1, -1}]
```

# Tree Chaining

Tree chaining is made possible thanks to the use of a memory array. Output of each tree is stored in the array and can be accessed using the MEM opcode. The offset value for each tree needs to be provided to the `execute_tree_chain` function, along with an empty memory array.
An example of the use of the chaining of trees can be found in `tests/test_tree.cairo::test_execute_tree_chain`.

# Available Opcodes

| Opcode | Description                                                                                                                                                                             | Tested |
| ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| ADD    | Addition of left and right values                                                                                                                                                       | ✅     |
| SUB    | Substraction of left and right values                                                                                                                                                   | ✅     |
| MUL    | Multiplication of left and right values                                                                                                                                                 | ✅     |
| DIV    | Division of left and right values                                                                                                                                                       | ✅     |
| MOD    | Modulus of left and right values                                                                                                                                                        | ✅     |
| ABS    | Absolute of right value                                                                                                                                                                 | ✅     |
| SQRT   | Square root of right value                                                                                                                                                              | ✅     |
| POW    | Left value to the power of right value                                                                                                                                                  | ✅     |
| IS_NN  | 1 if right value >= 0, else 0                                                                                                                                                           | ✅     |
| IS_LE  | 1 if left value <= right value, else 0                                                                                                                                                  | ✅     |
| NOT    | 1 if right value is 0, else 0                                                                                                                                                           | ✅     |
| EQ     | 1 if left value == right value, else 0                                                                                                                                                  | ✅     |
| MEM    | Access the indexed values of previous trees output                                                                                                                                      | ✅     |
| DICT   | Access values stored in the passed dictionary                                                                                                                                           | ✅     |
| JMP    | Jump to a location in the tree array, allowing to <br /> evaluate a sub tree. The output of the subtree evaluation <br /> is saved in the memory array, accessable with the MEM opcode. | ✅     |
