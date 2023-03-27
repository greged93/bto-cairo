# Introduction

The goal of the library is to allow user to input a binary tree representation of a function which is then executed through
iterating the tree. A valid tree would look like, where the visitation order is indicated in parenthesis for each node:

```
            is_le(1)
            /       \
         add(2)    abs(13)
        /      \         \
    mul(3)     div(8)    g(14)
    /    \      /   \
 pow(4)  c(7) d(9)  mod(10)
  /   \              /   \
a(5)  b(6)        e(11)  f(12)
```

A node is represented by the following structure, where left and right hold the relative offset in the array to their children node or -1 if the node doesn't have a valid branch in that direction:

```
struct Tree {
  value: felt,
  left: felt,
  right: felt,
}
```

The relative offset in the array to their children node can be better explained when viewing the below image. The number in the nodes describe the order in which the nodes are visited.
![order in which nodes are visited](https://github.com/greged93/bto-cairo/blob/master/imgs/375px-Depth-first-tree.svg.png)

The offset between two nodes is the difference in their visitation index. Taking for example node 2 and his two children nodes 3 and 6, the difference in their visitation index with node 2
are respectively 1 and 4. Node 2 would thus be represented as

```
{
  value: OP_CODE_2,
  left:  1,
  right: 4,
}
```

Applying the above, we can obtain the following array as the representation of the first tree:

```
[{is_le, 1, 12}, {add, 1, 6}, {mul, 1, 4}, {pow, 1, 2}, {a, -1, -1}, {b, -1, -1}, {c, -1, -1}, {div, 1, 2}, {d, -1, -1}, {mod, 1, 2}, {e, -1, -1}, {f, -1, -1}, {abs, -1, 1}, {g, -1, -1}]
```

# Tree Chaining

Tree chaining is made possible thanks to the use of a memory array. Output of each tree is stored in the array and can be accessed using the MEM opcode. The offset value for each tree needs to be provided to the `execute_tree_chain` function, along with an empty memory array.
An example of the use of the chaining of trees can be found in `tests/test_tree.cairo::test_execute_tree_chain`.

# Available Opcodes

| Opcode | Description                                                                                                                                                                                                                          | Tested |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ |
| ADD    | Addition of left and right values                                                                                                                                                                                                    | ✅     |
| SUB    | Substraction of left and right values                                                                                                                                                                                                | ✅     |
| MUL    | Multiplication of left and right values                                                                                                                                                                                              | ✅     |
| DIV    | Division of left and right values                                                                                                                                                                                                    | ✅     |
| MOD    | Modulus of left and right values                                                                                                                                                                                                     | ✅     |
| ABS    | Absolute of right value                                                                                                                                                                                                              | ✅     |
| SQRT   | Square root of right value                                                                                                                                                                                                           | ✅     |
| POW    | Left value to the power of right value                                                                                                                                                                                               | ✅     |
| IS_NN  | 1 if right value >= 0, else 0                                                                                                                                                                                                        | ✅     |
| IS_LE  | 1 if left value <= right value, else 0                                                                                                                                                                                               | ✅     |
| NOT    | 1 if right value is 0, else 0                                                                                                                                                                                                        | ✅     |
| EQ     | 1 if left value == right value, else 0                                                                                                                                                                                               | ✅     |
| MEM    | Access the indexed values of previous trees output                                                                                                                                                                                   | ✅     |
| DICT   | Access values stored in the passed dictionary                                                                                                                                                                                        | ✅     |
| FUNC   | Access to the general purpose functions stored in <br /> the functions dictionary, allowing to evaluate a sub tree. <br /> The output of the subtree evaluation is saved in <br /> the memory array, accessable with the MEM opcode. | ✅     |
