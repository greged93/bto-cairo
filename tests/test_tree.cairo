%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_write

from lib.tree import BinaryOperatorTree, Tree
from lib.constants import ns_opcodes, ns_tree

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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 17;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 731;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 3510;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 10;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 5;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 200;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 10;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 16777216;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 0;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 0;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 1;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 1;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 5;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
    return ();
}

@external
func test_iterate_tree_dict{range_check_ptr}() {
    // test case:
    // Tree
    //           dict(0)
    //            |
    //         mul(1)
    //       /      \
    //     dict(2)   2(4)
    //       |
    //      100(3)
    alloc_locals;
    let (local tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Tree(ns_opcodes.DICT, -1, 1);
    assert tree[1] = Tree(ns_opcodes.MUL, 1, 3);
    assert tree[2] = Tree(ns_opcodes.DICT, -1, 1);
    assert tree[3] = Tree(100, -1, -1);
    assert tree[4] = Tree(2, -1, -1);

    let (dict) = default_dict_new(default_value=0);
    dict_write{dict_ptr=dict}(key=100, new_value=22);
    dict_write{dict_ptr=dict}(key=44, new_value=17);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 17;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
    return ();
}

@external
func test_iterate_tree_func{range_check_ptr}() {
    // test case:
    // Tree 1:
    //                  mul(0)
    //                 /      \
    //                /       sub(16)
    //               /        /  \
    //            add(1)   20(17) abs(18)
    //           /     \             \
    //       is_le(2)  div(10)        sub(19)
    //      /  \         /  \           /     \
    // pow(3) 128(9) 27(11) mod(12) is_nn(20) sqrt(26)
    //   / \                 /   \       |          |
    // 2(4) add(5)      func(13)  12(15)  mul(21)    150(27)
    //      /  \          |              /  \
    //   not(6) 5(8)    0(14)      eq(22) 33(25)
    //    |                          /  \
    //   0(7)                    10(23) 10(24)
    //
    // Tree 2 (output = 99):
    //                  mul(0)
    //               /          \
    //            mul(1)       abs(12)
    //           /     \             \
    //       is_le(2)  sub(7)        sub(13)
    //      /  \         /  \           /   \
    // pow(3) 65(6) 30(8) mod(9)    not(14) sqrt(16)
    //   / \                 /   \      |       |
    // 2(4) 6(5)      350(10) 47(11)   0(15)  150(17)
    //
    alloc_locals;
    let (local state_tree: Tree*) = alloc();
    let (local general_tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    // Tree 1
    assert state_tree[0] = Tree(ns_opcodes.MUL, 1, 16);
    assert state_tree[1] = Tree(ns_opcodes.ADD, 1, 9);
    assert state_tree[2] = Tree(ns_opcodes.IS_LE, 1, 7);
    assert state_tree[3] = Tree(ns_opcodes.POW, 1, 2);
    assert state_tree[4] = Tree(2, -1, -1);
    assert state_tree[5] = Tree(ns_opcodes.ADD, 1, 3);
    assert state_tree[6] = Tree(ns_opcodes.NOT, -1, 1);
    assert state_tree[7] = Tree(0, -1, -1);
    assert state_tree[8] = Tree(5, -1, -1);
    assert state_tree[9] = Tree(128, -1, -1);
    assert state_tree[10] = Tree(ns_opcodes.DIV, 1, 2);
    assert state_tree[11] = Tree(27, -1, -1);
    assert state_tree[12] = Tree(ns_opcodes.MOD, 1, 3);
    assert state_tree[13] = Tree(ns_opcodes.FUNC, -1, 1);
    assert state_tree[14] = Tree(0, -1, -1);
    assert state_tree[15] = Tree(12, -1, -1);
    assert state_tree[16] = Tree(ns_opcodes.SUB, 1, 2);
    assert state_tree[17] = Tree(20, -1, -1);
    assert state_tree[18] = Tree(ns_opcodes.ABS, -1, 1);
    assert state_tree[19] = Tree(ns_opcodes.SUB, 1, 7);
    assert state_tree[20] = Tree(ns_opcodes.IS_NN, -1, 1);
    assert state_tree[21] = Tree(ns_opcodes.MUL, 1, 4);
    assert state_tree[22] = Tree(ns_opcodes.EQ, 1, 2);
    assert state_tree[23] = Tree(10, -1, -1);
    assert state_tree[24] = Tree(10, -1, -1);
    assert state_tree[25] = Tree(33, -1, -1);
    assert state_tree[26] = Tree(ns_opcodes.SQRT, -1, 1);
    assert state_tree[27] = Tree(150, -1, -1);
    // Tree 2
    assert general_tree[0] = Tree(ns_opcodes.MUL, 1, 12);
    assert general_tree[1] = Tree(ns_opcodes.MUL, 1, 6);
    assert general_tree[2] = Tree(ns_opcodes.IS_LE, 1, 4);
    assert general_tree[3] = Tree(ns_opcodes.POW, 1, 2);
    assert general_tree[4] = Tree(2, -1, -1);
    assert general_tree[5] = Tree(6, -1, -1);
    assert general_tree[6] = Tree(65, -1, -1);
    assert general_tree[7] = Tree(ns_opcodes.SUB, 1, 2);
    assert general_tree[8] = Tree(30, -1, -1);
    assert general_tree[9] = Tree(ns_opcodes.MOD, 1, 2);
    assert general_tree[10] = Tree(350, -1, -1);
    assert general_tree[11] = Tree(47, -1, -1);
    assert general_tree[12] = Tree(ns_opcodes.ABS, -1, 1);
    assert general_tree[13] = Tree(ns_opcodes.SUB, 1, 3);
    assert general_tree[14] = Tree(ns_opcodes.NOT, -1, 1);
    assert general_tree[15] = Tree(0, -1, -1);
    assert general_tree[16] = Tree(ns_opcodes.SQRT, -1, 1);
    assert general_tree[17] = Tree(150, -1, -1);

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);
    dict_write{dict_ptr=functions}(key=0, new_value=cast(general_tree, felt));

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        state_tree, 0, mem, functions, dict
    );
    assert result = 90;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
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
    // 2(4) add(5)      350(13) 48(14)  mul(18)    dict(24)
    //      /  \                        /  \         |
    //   not(6) 5(8)                 eq(19) 33(22)  10(15)
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
    assert tree[24] = Tree(ns_opcodes.DICT, -1, 1);
    assert tree[25] = Tree(10, -1, -1);

    let (dict) = default_dict_new(default_value=0);
    dict_write{dict_ptr=dict}(key=10, new_value=400);
    let (functions) = default_dict_new(default_value=0);

    let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
        tree, 0, mem, functions, dict
    );
    assert result = 361;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
    return ();
}

@external
func test_execute_tree_chain{range_check_ptr}() {
    // test case:
    // Tree 1:
    //                  mul(0)
    //                 /      \
    //                /       sub(16)
    //               /        /  \
    //            add(1)   20(17) abs(18)
    //           /     \             \
    //       is_le(2)  div(10)        sub(19)
    //      /  \         /  \           /     \
    // pow(3) 128(9) 150(11) mod(12) is_nn(20) sqrt(26)
    //   / \                 /   \       |          |
    // 2(4) add(5)      func(13) 48(15)  mul(21)    dict(27)
    //      /  \          |              /  \         |
    //   not(6) 5(8)     0(14)      eq(22) 33(25)  10(28)
    //    |                          /  \
    //   0(7)                    10(23) 10(24)
    //
    // Tree 2:
    //                  mul(0)
    //               /          \
    //            mul(1)       abs(14)
    //           /     \             \
    //       is_le(2)  sub(8)        sub(15)
    //      /  \         /  \           /   \
    // pow(3) 2050(7) 30(9) mod(10) not(16) sqrt(21)
    //   / \                 /   \      |       |
    // 2(4) mem(5)      mem(11) 47(13) mul(17)  150(22)
    //       |           |              /    \
    //      1(6)        0(12)     mem(18)  3(20)
    //                              |
    //                             1(19)
    //
    // Tree 3 (output = 350):
    //                  mul(0)
    //                 /     \
    //             add(1)     sqrt(6)
    //              /   \        |
    //        pow(2)    6(5)   25(7)
    //        /   \
    //     2(3)   6(4)

    alloc_locals;
    let (local state_tree: Tree*) = alloc();
    let (local general_tree: Tree*) = alloc();
    let (local mem: felt*) = alloc();
    let (local offset: felt*) = alloc();
    // offset
    assert offset[0] = 29;
    assert offset[1] = 0;
    // Tree 1
    assert state_tree[0] = Tree(ns_opcodes.MUL, 1, 16);
    assert state_tree[1] = Tree(ns_opcodes.ADD, 1, 9);
    assert state_tree[2] = Tree(ns_opcodes.IS_LE, 1, 7);
    assert state_tree[3] = Tree(ns_opcodes.POW, 1, 2);
    assert state_tree[4] = Tree(2, -1, -1);
    assert state_tree[5] = Tree(ns_opcodes.ADD, 1, 3);
    assert state_tree[6] = Tree(ns_opcodes.NOT, -1, 1);
    assert state_tree[7] = Tree(0, -1, -1);
    assert state_tree[8] = Tree(5, -1, -1);
    assert state_tree[9] = Tree(128, -1, -1);
    assert state_tree[10] = Tree(ns_opcodes.DIV, 1, 2);
    assert state_tree[11] = Tree(150, -1, -1);
    assert state_tree[12] = Tree(ns_opcodes.MOD, 1, 3);
    assert state_tree[13] = Tree(ns_opcodes.FUNC, -1, 1);
    assert state_tree[14] = Tree(0, -1, -1);
    assert state_tree[15] = Tree(48, -1, -1);
    assert state_tree[16] = Tree(ns_opcodes.SUB, 1, 2);
    assert state_tree[17] = Tree(20, -1, -1);
    assert state_tree[18] = Tree(ns_opcodes.ABS, -1, 1);
    assert state_tree[19] = Tree(ns_opcodes.SUB, 1, 7);
    assert state_tree[20] = Tree(ns_opcodes.IS_NN, -1, 1);
    assert state_tree[21] = Tree(ns_opcodes.MUL, 1, 4);
    assert state_tree[22] = Tree(ns_opcodes.EQ, 1, 2);
    assert state_tree[23] = Tree(10, -1, -1);
    assert state_tree[24] = Tree(10, -1, -1);
    assert state_tree[25] = Tree(33, -1, -1);
    assert state_tree[26] = Tree(ns_opcodes.SQRT, -1, 1);
    assert state_tree[27] = Tree(ns_opcodes.DICT, -1, 1);
    assert state_tree[28] = Tree(10, -1, -1);
    // Tree 2
    assert state_tree[29] = Tree(ns_opcodes.MUL, 1, 14);
    assert state_tree[30] = Tree(ns_opcodes.MUL, 1, 7);
    assert state_tree[31] = Tree(ns_opcodes.IS_LE, 1, 5);
    assert state_tree[32] = Tree(ns_opcodes.POW, 1, 2);
    assert state_tree[33] = Tree(2, -1, -1);
    assert state_tree[34] = Tree(ns_opcodes.MEM, -1, 1);
    assert state_tree[35] = Tree(1, -1, -1);
    assert state_tree[36] = Tree(2050, -1, -1);
    assert state_tree[37] = Tree(ns_opcodes.SUB, 1, 2);
    assert state_tree[38] = Tree(30, -1, -1);
    assert state_tree[39] = Tree(ns_opcodes.MOD, 1, 3);
    assert state_tree[40] = Tree(ns_opcodes.MEM, -1, 1);
    assert state_tree[41] = Tree(0, -1, -1);
    assert state_tree[42] = Tree(47, -1, -1);
    assert state_tree[43] = Tree(ns_opcodes.ABS, -1, 1);
    assert state_tree[44] = Tree(ns_opcodes.SUB, 1, 6);
    assert state_tree[45] = Tree(ns_opcodes.NOT, -1, 1);
    assert state_tree[46] = Tree(ns_opcodes.MUL, 1, 3);
    assert state_tree[47] = Tree(ns_opcodes.MEM, -1, 1);
    assert state_tree[48] = Tree(1, -1, -1);
    assert state_tree[49] = Tree(3, -1, -1);
    assert state_tree[50] = Tree(ns_opcodes.SQRT, -1, 1);
    assert state_tree[51] = Tree(150, -1, -1);
    // Tree 3
    assert general_tree[0] = Tree(ns_opcodes.MUL, 1, 6);
    assert general_tree[1] = Tree(ns_opcodes.ADD, 1, 4);
    assert general_tree[2] = Tree(ns_opcodes.POW, 1, 2);
    assert general_tree[3] = Tree(2, -1, -1);
    assert general_tree[4] = Tree(6, -1, -1);
    assert general_tree[5] = Tree(6, -1, -1);
    assert general_tree[6] = Tree(ns_opcodes.SQRT, -1, 1);
    assert general_tree[7] = Tree(25, -1, -1);

    let (dict) = default_dict_new(default_value=0);
    dict_write{dict_ptr=dict}(key=10, new_value=400);
    let (functions) = default_dict_new(default_value=0);
    dict_write{dict_ptr=functions}(key=0, new_value=cast(general_tree, felt));

    let (result, functions_new, dict_new) = BinaryOperatorTree.execute_tree_chain(
        2, offset, state_tree, 0, mem, functions, dict
    );
    assert result = 108;

    default_dict_finalize(
        dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
    );
    default_dict_finalize(
        dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
    );
    return ();
}
