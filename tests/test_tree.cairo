%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

from contracts.tree import BinaryOperatorTree, Tree
from contracts.constants import ns_opcodes, ns_tree

@external
func __setup__{range_check_ptr}() {
    return ();
}

@external
func test_iterate_tree_add{range_check_ptr}() {
    // test case:
    // Tree
    //            add(0)
    //          /       \
    //         add(1)   8(6)
    //       /      \
    //     add(2)   6(5)
    //    /   \
    // 1(3) 2(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.ADD, 1, 6);
    assert tree[1] = Tree(ns_opcodes.ADD, 1, 4);
    assert tree[2] = Tree(ns_opcodes.ADD, 1, 2);
    assert tree[3] = Tree(1, -1, -1);
    assert tree[4] = Tree(2, -1, -1);
    assert tree[5] = Tree(6, -1, -1);
    assert tree[6] = Tree(8, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 17;
    return ();
}

@external
func test_iterate_tree_sub{range_check_ptr}() {
    // test case:
    // Tree
    //            sub(0)
    //          /       \
    //         sub(1)   245(6)
    //       /      \
    //     sub(2)   9(5)
    //    /   \
    // 1000(3) 15(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.SUB, 1, 6);
    assert tree[1] = Tree(ns_opcodes.SUB, 1, 4);
    assert tree[2] = Tree(ns_opcodes.SUB, 1, 2);
    assert tree[3] = Tree(1000, -1, -1);
    assert tree[4] = Tree(15, -1, -1);
    assert tree[5] = Tree(9, -1, -1);
    assert tree[6] = Tree(245, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 731;
    return ();
}

@external
func test_iterate_tree_mul{range_check_ptr}() {
    // test case:
    // Tree
    //            mul(0)
    //          /       \
    //         mul(1)   2(6)
    //       /      \
    //     mul(2)   9(5)
    //    /   \
    // 13(3) 15(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.MUL, 1, 6);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 4);
    assert tree[2] = Tree(ns_opcodes.MUL, 1, 2);
    assert tree[3] = Tree(13, -1, -1);
    assert tree[4] = Tree(15, -1, -1);
    assert tree[5] = Tree(9, -1, -1);
    assert tree[6] = Tree(2, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 3510;
    return ();
}

@external
func test_iterate_tree_div{range_check_ptr}() {
    // test case:
    // Tree
    //            div(0)
    //          /       \
    //         div(1)   6(6)
    //       /      \
    //     div(2)   2(5)
    //    /   \
    // 512(3) 4(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.DIV, 1, 6);
    assert tree[1] = Tree(ns_opcodes.DIV, 1, 4);
    assert tree[2] = Tree(ns_opcodes.DIV, 1, 2);
    assert tree[3] = Tree(512, -1, -1);
    assert tree[4] = Tree(4, -1, -1);
    assert tree[5] = Tree(2, -1, -1);
    assert tree[6] = Tree(6, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 10;
    return ();
}

@external
func test_iterate_tree_mod{range_check_ptr}() {
    // test case:
    // Tree
    //            mod(0)
    //          /       \
    //         mod(1)   7(6)
    //       /      \
    //     mod(2)   63(5)
    //    /   \
    // 512(3) 104(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.MOD, 1, 6);
    assert tree[1] = Tree(ns_opcodes.MOD, 1, 4);
    assert tree[2] = Tree(ns_opcodes.MOD, 1, 2);
    assert tree[3] = Tree(512, -1, -1);
    assert tree[4] = Tree(104, -1, -1);
    assert tree[5] = Tree(63, -1, -1);
    assert tree[6] = Tree(7, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 5;
    return ();
}

@external
func test_iterate_tree_abs{range_check_ptr}() {
    // test case:
    // Tree
    //           abs(0)
    //            |
    //         mult(1)
    //       /      \
    //     abs(2)   -2(4)
    //       |
    //      -100(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.ABS, -1, 1);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 3);
    assert tree[2] = Tree(ns_opcodes.ABS, -1, 1);
    assert tree[3] = Tree(-100, -1, -1);
    assert tree[4] = Tree(-2, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 200;
    return ();
}

@external
func test_iterate_tree_sqrt{range_check_ptr}() {
    // test case:
    // Tree
    //           sqrt(0)
    //            |
    //         mul(1)
    //       /      \
    //     sqrt(2)   5(4)
    //       |
    //      400(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.SQRT, -1, 1);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 3);
    assert tree[2] = Tree(ns_opcodes.SQRT, -1, 1);
    assert tree[3] = Tree(400, -1, -1);
    assert tree[4] = Tree(5, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 10;
    return ();
}

@external
func test_iterate_tree_pow{range_check_ptr}() {
    // test case:
    // Tree
    //            pow(0)
    //          /       \
    //         pow(1)   2(6)
    //       /      \
    //     pow(2)   2(5)
    //    /   \
    // 2(3) 6(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.POW, 1, 6);
    assert tree[1] = Tree(ns_opcodes.POW, 1, 4);
    assert tree[2] = Tree(ns_opcodes.POW, 1, 2);
    assert tree[3] = Tree(2, -1, -1);
    assert tree[4] = Tree(6, -1, -1);
    assert tree[5] = Tree(2, -1, -1);
    assert tree[6] = Tree(2, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 16777216;
    return ();
}

@external
func test_iterate_tree_is_nn{range_check_ptr}() {
    // test case:
    // Tree
    //           is_nn(0)
    //            |
    //         mul(1)
    //       /      \
    //     is_nn(2)   -1(4)
    //       |
    //      10(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.IS_NN, -1, 1);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 3);
    assert tree[2] = Tree(ns_opcodes.IS_NN, -1, 1);
    assert tree[3] = Tree(10, -1, -1);
    assert tree[4] = Tree(-1, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 0;
    return ();
}

@external
func test_iterate_tree_is_le{range_check_ptr}() {
    // test case:
    // Tree
    //            is_le(0)
    //          /       \
    //         is_le(1)   0(6)
    //       /      \
    //     is_le(2)   2(5)
    //    /   \
    // 2(3) 6(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.IS_LE, 1, 6);
    assert tree[1] = Tree(ns_opcodes.IS_LE, 1, 4);
    assert tree[2] = Tree(ns_opcodes.IS_LE, 1, 2);
    assert tree[3] = Tree(2, -1, -1);
    assert tree[4] = Tree(6, -1, -1);
    assert tree[5] = Tree(2, -1, -1);
    assert tree[6] = Tree(0, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 0;
    return ();
}

@external
func test_iterate_tree_not{range_check_ptr}() {
    // test case:
    // Tree
    //           not(0)
    //            |
    //         mul(1)
    //       /      \
    //     not(2)   -1(4)
    //       |
    //      1(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.NOT, -1, 1);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 3);
    assert tree[2] = Tree(ns_opcodes.NOT, -1, 1);
    assert tree[3] = Tree(1, -1, -1);
    assert tree[4] = Tree(-1, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 1;
    return ();
}

@external
func test_iterate_tree_eq{range_check_ptr}() {
    // test case:
    // Tree
    //            eq(0)
    //          /       \
    //        mul(1)   0(6)
    //       /      \
    //     eq(2)   5(5)
    //    /   \
    // 2(3) 3(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.EQ, 1, 6);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 4);
    assert tree[2] = Tree(ns_opcodes.EQ, 1, 2);
    assert tree[3] = Tree(2, -1, -1);
    assert tree[4] = Tree(3, -1, -1);
    assert tree[5] = Tree(5, -1, -1);
    assert tree[6] = Tree(0, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 1;
    return ();
}

@external
func test_iterate_tree_mem{range_check_ptr}() {
    // test case:
    // Tree
    //           mem(0)
    //            |
    //         mul(1)
    //       /      \
    //     mem(2)   2(4)
    //       |
    //      1(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert mem[0] = 1;
    assert mem[1] = 2;
    assert mem[2] = 3;
    assert mem[3] = 4;
    assert mem[4] = 5;
    assert mem[5] = 6;
    assert tree[0] = Tree(ns_opcodes.MEM, -1, 1);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 3);
    assert tree[2] = Tree(ns_opcodes.MEM, -1, 1);
    assert tree[3] = Tree(1, -1, -1);
    assert tree[4] = Tree(2, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 5;
    return ();
}

@external
func test_iterate_tree{range_check_ptr}() {
    // test case:
    // Tree
    //                  mul(0)
    //               /          \
    //            add(1)       abs(15)
    //           /     \             \
    //       is_le(2)  div(10)        sub(16)
    //      /  \         /  \           /     \
    // pow(3) 128(9) 260(11) mod(12) is_nn(17) sqrt(23)
    //   / \                 /   \       |          |
    // 2(4) add(5)      350(13) 48(14)  mul(18)    400(24)
    //      /  \                        /  \
    //   not(6) 5(8)                 eq(19) 33(22)
    //    |                          /  \
    //   0(7)                    10(20) 10(21)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.MUL, 1, 15);
    assert tree[1] = Tree(ns_opcodes.ADD, 1, 9);
    assert tree[2] = Tree(ns_opcodes.IS_LE, 1, 7);
    assert tree[3] = Tree(ns_opcodes.POW, 1, 2);
    assert tree[4] = Tree(2, -1, -1);
    assert tree[5] = Tree(ns_opcodes.ADD, 1, 3);
    assert tree[6] = Tree(ns_opcodes.NOT, -1, 1);
    assert tree[7] = Tree(0, -1, -1);
    assert tree[8] = Tree(5, -1, -1);
    assert tree[9] = Tree(128, -1, -1);
    assert tree[10] = Tree(ns_opcodes.DIV, 1, 2);
    assert tree[11] = Tree(260, -1, -1);
    assert tree[12] = Tree(ns_opcodes.MOD, 1, 2);
    assert tree[13] = Tree(350, -1, -1);
    assert tree[14] = Tree(48, -1, -1);
    assert tree[15] = Tree(ns_opcodes.ABS, -1, 1);
    assert tree[16] = Tree(ns_opcodes.SUB, 1, 7);
    assert tree[17] = Tree(ns_opcodes.IS_NN, -1, 1);
    assert tree[18] = Tree(ns_opcodes.MUL, 1, 4);
    assert tree[19] = Tree(ns_opcodes.EQ, 1, 2);
    assert tree[20] = Tree(10, -1, -1);
    assert tree[21] = Tree(10, -1, -1);
    assert tree[22] = Tree(33, -1, -1);
    assert tree[23] = Tree(ns_opcodes.SQRT, -1, 1);
    assert tree[24] = Tree(400, -1, -1);
    let result = BinaryOperatorTree.iterate_tree(tree, mem);
    assert result = 361;
    return ();
}

@external
func test_execute_tree_chain{range_check_ptr}() {
    // test case:
    // Tree 1:
    //                  mul(0)
    //                 /      \
    //                /       sub(15)
    //               /        /  \
    //            add(1)   20(16) abs(17)
    //           /     \             \
    //       is_le(2)  div(10)        sub(18)
    //      /  \         /  \           /     \
    // pow(3) 128(9) 150(11) mod(12) is_nn(19) sqrt(25)
    //   / \                 /   \       |          |
    // 2(4) add(5)      350(13) 48(14)  mul(20)    400(26)
    //      /  \                        /  \
    //   not(6) 5(8)                 eq(21) 33(24)
    //    |                          /  \
    //   0(7)                    10(22) 10(23)
    // Tree 2:
    //                  mul(0)
    //               /          \
    //            mul(1)       abs(13)
    //           /     \             \
    //       is_le(2)  sub(8)        sub(14)
    //      /  \         /  \           /   \
    // pow(3) 2050(7) 30(9) mod(10) not(15) sqrt(20)
    //   / \                 /   \      |       |
    // 2(4) mem(5)      350(11) 47(12) mul(16)  150(21)
    //       |                          /    \
    //      0(6)                     mem(17)  3(19)
    //                                  |
    //                                 0(18)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    let (local offset: felt*) = alloc();
    // offset
    assert offset[0] = 27;
    assert offset[1] = 0;
    // Tree 1
    assert tree[0] = Tree(ns_opcodes.MUL, 1, 15);
    assert tree[1] = Tree(ns_opcodes.ADD, 1, 9);
    assert tree[2] = Tree(ns_opcodes.IS_LE, 1, 7);
    assert tree[3] = Tree(ns_opcodes.POW, 1, 2);
    assert tree[4] = Tree(2, -1, -1);
    assert tree[5] = Tree(ns_opcodes.ADD, 1, 3);
    assert tree[6] = Tree(ns_opcodes.NOT, -1, 1);
    assert tree[7] = Tree(0, -1, -1);
    assert tree[8] = Tree(5, -1, -1);
    assert tree[9] = Tree(128, -1, -1);
    assert tree[10] = Tree(ns_opcodes.DIV, 1, 2);
    assert tree[11] = Tree(150, -1, -1);
    assert tree[12] = Tree(ns_opcodes.MOD, 1, 2);
    assert tree[13] = Tree(350, -1, -1);
    assert tree[14] = Tree(48, -1, -1);
    assert tree[15] = Tree(ns_opcodes.SUB, 1, 2);
    assert tree[16] = Tree(20, -1, -1);
    assert tree[17] = Tree(ns_opcodes.ABS, -1, 1);
    assert tree[18] = Tree(ns_opcodes.SUB, 1, 7);
    assert tree[19] = Tree(ns_opcodes.IS_NN, -1, 1);
    assert tree[20] = Tree(ns_opcodes.MUL, 1, 4);
    assert tree[21] = Tree(ns_opcodes.EQ, 1, 2);
    assert tree[22] = Tree(10, -1, -1);
    assert tree[23] = Tree(10, -1, -1);
    assert tree[24] = Tree(33, -1, -1);
    assert tree[25] = Tree(ns_opcodes.SQRT, -1, 1);
    assert tree[26] = Tree(400, -1, -1);
    // Tree 2
    assert tree[27] = Tree(ns_opcodes.MUL, 1, 13);
    assert tree[28] = Tree(ns_opcodes.MUL, 1, 7);
    assert tree[29] = Tree(ns_opcodes.IS_LE, 1, 5);
    assert tree[30] = Tree(ns_opcodes.POW, 1, 2);
    assert tree[31] = Tree(2, -1, -1);
    assert tree[32] = Tree(ns_opcodes.MEM, -1, 1);
    assert tree[33] = Tree(0, -1, -1);
    assert tree[34] = Tree(2050, -1, -1);
    assert tree[35] = Tree(ns_opcodes.SUB, 1, 2);
    assert tree[36] = Tree(30, -1, -1);
    assert tree[37] = Tree(ns_opcodes.MOD, 1, 2);
    assert tree[38] = Tree(350, -1, -1);
    assert tree[39] = Tree(47, -1, -1);
    assert tree[40] = Tree(ns_opcodes.ABS, -1, 1);
    assert tree[41] = Tree(ns_opcodes.SUB, 1, 6);
    assert tree[42] = Tree(ns_opcodes.NOT, -1, 1);
    assert tree[43] = Tree(ns_opcodes.MUL, 1, 3);
    assert tree[44] = Tree(ns_opcodes.MEM, -1, 1);
    assert tree[45] = Tree(0, -1, -1);
    assert tree[46] = Tree(3, -1, -1);
    assert tree[47] = Tree(ns_opcodes.SQRT, -1, 1);
    assert tree[48] = Tree(150, -1, -1);
    let result = BinaryOperatorTree.execute_tree_chain(2, offset, tree, 0, mem);
    assert result = 108;
    return ();
}
