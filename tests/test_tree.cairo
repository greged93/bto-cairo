%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_write

from lib.tree import BinaryOperatorTree, Node, TreeDataSystem, MemoryAccess
from lib.constants import ns_opcodes, ns_node

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
    let (local tree: Node*) = alloc();
    let (local mem: felt*) = alloc();
    assert tree[0] = Node(ns_opcodes.ADD, 1, 6);
    assert tree[1] = Node(ns_opcodes.ADD, 1, 4);
    assert tree[2] = Node(ns_opcodes.ADD, 1, 2);
    assert tree[3] = Node(1, -1, -1);
    assert tree[4] = Node(2, -1, -1);
    assert tree[5] = Node(6, -1, -1);
    assert tree[6] = Node(8, -1, -1);

    let (dict) = default_dict_new(default_value=0);
    let (functions) = default_dict_new(default_value=0);
    let tree_data_system = TreeDataSystem(
        memory=MemoryAccess(0, mem), utility_functions_dict=functions, constants_dict=dict
    );

    let (result, tree_data_system_new) = BinaryOperatorTree.iterate_tree(tree, tree_data_system);
    assert result = 17;

    default_dict_finalize(
        dict_accesses_start=tree_data_system_new.utility_functions_dict,
        dict_accesses_end=tree_data_system_new.utility_functions_dict,
        default_value=0,
    );
    default_dict_finalize(
        dict_accesses_start=tree_data_system_new.constants_dict,
        dict_accesses_end=tree_data_system_new.constants_dict,
        default_value=0,
    );
    return ();
}

// @external
// func test_iterate_tree_sub{range_check_ptr}() {
//     // test case:
//     // Node
//     //            sub(0)
//     //          /       \
//     //         sub(1)   245(6)
//     //       /      \
//     //     sub(2)   9(5)
//     //    /   \
//     // 1000(3) 15(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.SUB, 1, 6);
//     assert tree[1] = Node(ns_opcodes.SUB, 1, 4);
//     assert tree[2] = Node(ns_opcodes.SUB, 1, 2);
//     assert tree[3] = Node(1000, -1, -1);
//     assert tree[4] = Node(15, -1, -1);
//     assert tree[5] = Node(9, -1, -1);
//     assert tree[6] = Node(245, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 731;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_mul{range_check_ptr}() {
//     // test case:
//     // Tree
//     //            mul(0)
//     //          /       \
//     //         mul(1)   2(6)
//     //       /      \
//     //     mul(2)   9(5)
//     //    /   \
//     // 13(3) 15(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.MUL, 1, 6);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 4);
//     assert tree[2] = Node(ns_opcodes.MUL, 1, 2);
//     assert tree[3] = Node(13, -1, -1);
//     assert tree[4] = Node(15, -1, -1);
//     assert tree[5] = Node(9, -1, -1);
//     assert tree[6] = Node(2, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 3510;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_div{range_check_ptr}() {
//     // test case:
//     // Tree
//     //            div(0)
//     //          /       \
//     //         div(1)   6(6)
//     //       /      \
//     //     div(2)   2(5)
//     //    /   \
//     // 512(3) 4(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.DIV, 1, 6);
//     assert tree[1] = Node(ns_opcodes.DIV, 1, 4);
//     assert tree[2] = Node(ns_opcodes.DIV, 1, 2);
//     assert tree[3] = Node(512, -1, -1);
//     assert tree[4] = Node(4, -1, -1);
//     assert tree[5] = Node(2, -1, -1);
//     assert tree[6] = Node(6, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 10;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_mod{range_check_ptr}() {
//     // test case:
//     // Tree
//     //            mod(0)
//     //          /       \
//     //         mod(1)   7(6)
//     //       /      \
//     //     mod(2)   63(5)
//     //    /   \
//     // 512(3) 104(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.MOD, 1, 6);
//     assert tree[1] = Node(ns_opcodes.MOD, 1, 4);
//     assert tree[2] = Node(ns_opcodes.MOD, 1, 2);
//     assert tree[3] = Node(512, -1, -1);
//     assert tree[4] = Node(104, -1, -1);
//     assert tree[5] = Node(63, -1, -1);
//     assert tree[6] = Node(7, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 5;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_abs{range_check_ptr}() {
//     // test case:
//     // Tree
//     //           abs(0)
//     //            |
//     //         mult(1)
//     //       /      \
//     //     abs(2)   -2(4)
//     //       |
//     //      -100(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.ABS, -1, 1);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 3);
//     assert tree[2] = Node(ns_opcodes.ABS, -1, 1);
//     assert tree[3] = Node(-100, -1, -1);
//     assert tree[4] = Node(-2, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 200;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_sqrt{range_check_ptr}() {
//     // test case:
//     // Tree
//     //           sqrt(0)
//     //            |
//     //         mul(1)
//     //       /      \
//     //     sqrt(2)   5(4)
//     //       |
//     //      400(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.SQRT, -1, 1);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 3);
//     assert tree[2] = Node(ns_opcodes.SQRT, -1, 1);
//     assert tree[3] = Node(400, -1, -1);
//     assert tree[4] = Node(5, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 10;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_pow{range_check_ptr}() {
//     // test case:
//     // Tree
//     //            pow(0)
//     //          /       \
//     //         pow(1)   2(6)
//     //       /      \
//     //     pow(2)   2(5)
//     //    /   \
//     // 2(3) 6(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.POW, 1, 6);
//     assert tree[1] = Node(ns_opcodes.POW, 1, 4);
//     assert tree[2] = Node(ns_opcodes.POW, 1, 2);
//     assert tree[3] = Node(2, -1, -1);
//     assert tree[4] = Node(6, -1, -1);
//     assert tree[5] = Node(2, -1, -1);
//     assert tree[6] = Node(2, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 16777216;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_is_nn{range_check_ptr}() {
//     // test case:
//     // Tree
//     //           is_nn(0)
//     //            |
//     //         mul(1)
//     //       /      \
//     //     is_nn(2)   -1(4)
//     //       |
//     //      10(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.IS_NN, -1, 1);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 3);
//     assert tree[2] = Node(ns_opcodes.IS_NN, -1, 1);
//     assert tree[3] = Node(10, -1, -1);
//     assert tree[4] = Node(-1, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 0;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_is_le{range_check_ptr}() {
//     // test case:
//     // Tree
//     //            is_le(0)
//     //          /       \
//     //         is_le(1)   0(6)
//     //       /      \
//     //     is_le(2)   2(5)
//     //    /   \
//     // 2(3) 6(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.IS_LE, 1, 6);
//     assert tree[1] = Node(ns_opcodes.IS_LE, 1, 4);
//     assert tree[2] = Node(ns_opcodes.IS_LE, 1, 2);
//     assert tree[3] = Node(2, -1, -1);
//     assert tree[4] = Node(6, -1, -1);
//     assert tree[5] = Node(2, -1, -1);
//     assert tree[6] = Node(0, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 0;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_not{range_check_ptr}() {
//     // test case:
//     // Tree
//     //           not(0)
//     //            |
//     //         mul(1)
//     //       /      \
//     //     not(2)   -1(4)
//     //       |
//     //      1(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.NOT, -1, 1);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 3);
//     assert tree[2] = Node(ns_opcodes.NOT, -1, 1);
//     assert tree[3] = Node(1, -1, -1);
//     assert tree[4] = Node(-1, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 1;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_eq{range_check_ptr}() {
//     // test case:
//     // Tree
//     //            eq(0)
//     //          /       \
//     //        mul(1)   0(6)
//     //       /      \
//     //     eq(2)   5(5)
//     //    /   \
//     // 2(3) 3(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.EQ, 1, 6);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 4);
//     assert tree[2] = Node(ns_opcodes.EQ, 1, 2);
//     assert tree[3] = Node(2, -1, -1);
//     assert tree[4] = Node(3, -1, -1);
//     assert tree[5] = Node(5, -1, -1);
//     assert tree[6] = Node(0, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 1;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_mem{range_check_ptr}() {
//     // test case:
//     // Tree
//     //           mem(0)
//     //            |
//     //         mul(1)
//     //       /      \
//     //     mem(2)   2(4)
//     //       |
//     //      1(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert mem[0] = 1;
//     assert mem[1] = 2;
//     assert mem[2] = 3;
//     assert mem[3] = 4;
//     assert mem[4] = 5;
//     assert mem[5] = 6;
//     assert tree[0] = Node(ns_opcodes.MEM, -1, 1);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 3);
//     assert tree[2] = Node(ns_opcodes.MEM, -1, 1);
//     assert tree[3] = Node(1, -1, -1);
//     assert tree[4] = Node(2, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 5;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_dict{range_check_ptr}() {
//     // test case:
//     // Tree
//     //           dict(0)
//     //            |
//     //         mul(1)
//     //       /      \
//     //     dict(2)   2(4)
//     //       |
//     //      100(3)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.DICT, -1, 1);
//     assert tree[1] = Node(ns_opcodes.MUL, 1, 3);
//     assert tree[2] = Node(ns_opcodes.DICT, -1, 1);
//     assert tree[3] = Node(100, -1, -1);
//     assert tree[4] = Node(2, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     dict_write{dict_ptr=dict}(key=100, new_value=22);
//     dict_write{dict_ptr=dict}(key=44, new_value=17);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 17;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree_func{range_check_ptr}() {
//     // test case:
//     // Tree 1:
//     //                  mul(0)
//     //                 /      \
//     //                /       sub(16)
//     //               /        /  \
//     //            add(1)   20(17) abs(18)
//     //           /     \             \
//     //       is_le(2)  div(10)        sub(19)
//     //      /  \         /  \           /     \
//     // pow(3) 128(9) 27(11) mod(12) is_nn(20) sqrt(26)
//     //   / \                 /   \       |          |
//     // 2(4) add(5)      func(13)  12(15)  mul(21)    150(27)
//     //      /  \          |              /  \
//     //   not(6) 5(8)    0(14)      eq(22) 33(25)
//     //    |                          /  \
//     //   0(7)                    10(23) 10(24)
//     //
//     // Tree 2 (output = 99):
//     //                  mul(0)
//     //               /          \
//     //            mul(1)       abs(12)
//     //           /     \             \
//     //       is_le(2)  sub(7)        sub(13)
//     //      /  \         /  \           /   \
//     // pow(3) 65(6) 30(8) mod(9)    not(14) sqrt(16)
//     //   / \                 /   \      |       |
//     // 2(4) 6(5)      350(10) 47(11)   0(15)  150(17)
//     //
//     alloc_locals;
//     let (local state_tree: Node*) = alloc();
//     let (local general_tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     // Node 1
//     assert state_tree[0] = Node(ns_opcodes.MUL, 1, 16);
//     assert state_tree[1] = Node(ns_opcodes.ADD, 1, 9);
//     assert state_tree[2] = Node(ns_opcodes.IS_LE, 1, 7);
//     assert state_tree[3] = Node(ns_opcodes.POW, 1, 2);
//     assert state_tree[4] = Node(2, -1, -1);
//     assert state_tree[5] = Node(ns_opcodes.ADD, 1, 3);
//     assert state_tree[6] = Node(ns_opcodes.NOT, -1, 1);
//     assert state_tree[7] = Node(0, -1, -1);
//     assert state_tree[8] = Node(5, -1, -1);
//     assert state_tree[9] = Node(128, -1, -1);
//     assert state_tree[10] = Node(ns_opcodes.DIV, 1, 2);
//     assert state_tree[11] = Node(27, -1, -1);
//     assert state_tree[12] = Node(ns_opcodes.MOD, 1, 3);
//     assert state_tree[13] = Node(ns_opcodes.FUNC, -1, 1);
//     assert state_tree[14] = Node(0, -1, -1);
//     assert state_tree[15] = Node(12, -1, -1);
//     assert state_tree[16] = Node(ns_opcodes.SUB, 1, 2);
//     assert state_tree[17] = Node(20, -1, -1);
//     assert state_tree[18] = Node(ns_opcodes.ABS, -1, 1);
//     assert state_tree[19] = Node(ns_opcodes.SUB, 1, 7);
//     assert state_tree[20] = Node(ns_opcodes.IS_NN, -1, 1);
//     assert state_tree[21] = Node(ns_opcodes.MUL, 1, 4);
//     assert state_tree[22] = Node(ns_opcodes.EQ, 1, 2);
//     assert state_tree[23] = Node(10, -1, -1);
//     assert state_tree[24] = Node(10, -1, -1);
//     assert state_tree[25] = Node(33, -1, -1);
//     assert state_tree[26] = Node(ns_opcodes.SQRT, -1, 1);
//     assert state_tree[27] = Node(150, -1, -1);
//     // Node 2
//     assert general_tree[0] = Node(ns_opcodes.MUL, 1, 12);
//     assert general_tree[1] = Node(ns_opcodes.MUL, 1, 6);
//     assert general_tree[2] = Node(ns_opcodes.IS_LE, 1, 4);
//     assert general_tree[3] = Node(ns_opcodes.POW, 1, 2);
//     assert general_tree[4] = Node(2, -1, -1);
//     assert general_tree[5] = Node(6, -1, -1);
//     assert general_tree[6] = Node(65, -1, -1);
//     assert general_tree[7] = Node(ns_opcodes.SUB, 1, 2);
//     assert general_tree[8] = Node(30, -1, -1);
//     assert general_tree[9] = Node(ns_opcodes.MOD, 1, 2);
//     assert general_tree[10] = Node(350, -1, -1);
//     assert general_tree[11] = Node(47, -1, -1);
//     assert general_tree[12] = Node(ns_opcodes.ABS, -1, 1);
//     assert general_tree[13] = Node(ns_opcodes.SUB, 1, 3);
//     assert general_tree[14] = Node(ns_opcodes.NOT, -1, 1);
//     assert general_tree[15] = Node(0, -1, -1);
//     assert general_tree[16] = Node(ns_opcodes.SQRT, -1, 1);
//     assert general_tree[17] = Node(150, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     let (functions) = default_dict_new(default_value=0);
//     dict_write{dict_ptr=functions}(key=0, new_value=cast(general_tree, felt));

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         state_tree, 0, mem, functions, dict
//     );
//     assert result = 90;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_iterate_tree{range_check_ptr}() {
//     // test case:
//     // Tree
//     //                  mul(0)
//     //               /          \
//     //            add(1)       abs(15)
//     //           /     \             \
//     //       is_le(2)  div(10)        sub(16)
//     //      /  \         /  \           /     \
//     // pow(3) 128(9) 260(11) mod(12) is_nn(17) sqrt(23)
//     //   / \                 /   \       |          |
//     // 2(4) add(5)      350(13) 48(14)  mul(18)    dict(24)
//     //      /  \                        /  \         |
//     //   not(6) 5(8)                 eq(19) 33(22)  10(15)
//     //    |                          /  \
//     //   0(7)                    10(20) 10(21)
//     alloc_locals;
//     let (local tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     assert tree[0] = Node(ns_opcodes.MUL, 1, 15);
//     assert tree[1] = Node(ns_opcodes.ADD, 1, 9);
//     assert tree[2] = Node(ns_opcodes.IS_LE, 1, 7);
//     assert tree[3] = Node(ns_opcodes.POW, 1, 2);
//     assert tree[4] = Node(2, -1, -1);
//     assert tree[5] = Node(ns_opcodes.ADD, 1, 3);
//     assert tree[6] = Node(ns_opcodes.NOT, -1, 1);
//     assert tree[7] = Node(0, -1, -1);
//     assert tree[8] = Node(5, -1, -1);
//     assert tree[9] = Node(128, -1, -1);
//     assert tree[10] = Node(ns_opcodes.DIV, 1, 2);
//     assert tree[11] = Node(260, -1, -1);
//     assert tree[12] = Node(ns_opcodes.MOD, 1, 2);
//     assert tree[13] = Node(350, -1, -1);
//     assert tree[14] = Node(48, -1, -1);
//     assert tree[15] = Node(ns_opcodes.ABS, -1, 1);
//     assert tree[16] = Node(ns_opcodes.SUB, 1, 7);
//     assert tree[17] = Node(ns_opcodes.IS_NN, -1, 1);
//     assert tree[18] = Node(ns_opcodes.MUL, 1, 4);
//     assert tree[19] = Node(ns_opcodes.EQ, 1, 2);
//     assert tree[20] = Node(10, -1, -1);
//     assert tree[21] = Node(10, -1, -1);
//     assert tree[22] = Node(33, -1, -1);
//     assert tree[23] = Node(ns_opcodes.SQRT, -1, 1);
//     assert tree[24] = Node(ns_opcodes.DICT, -1, 1);
//     assert tree[25] = Node(10, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     dict_write{dict_ptr=dict}(key=10, new_value=400);
//     let (functions) = default_dict_new(default_value=0);

// let (result, functions_new, dict_new, _) = BinaryOperatorTree.iterate_tree(
//         tree, 0, mem, functions, dict
//     );
//     assert result = 361;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }

// @external
// func test_execute_tree_chain{range_check_ptr}() {
//     // test case:
//     // Tree 1:
//     //                  mul(0)
//     //                 /      \
//     //                /       sub(16)
//     //               /        /  \
//     //            add(1)   20(17) abs(18)
//     //           /     \             \
//     //       is_le(2)  div(10)        sub(19)
//     //      /  \         /  \           /     \
//     // pow(3) 128(9) 150(11) mod(12) is_nn(20) sqrt(26)
//     //   / \                 /   \       |          |
//     // 2(4) add(5)      func(13) 48(15)  mul(21)    dict(27)
//     //      /  \          |              /  \         |
//     //   not(6) 5(8)     0(14)      eq(22) 33(25)  10(28)
//     //    |                          /  \
//     //   0(7)                    10(23) 10(24)
//     //
//     // Tree 2:
//     //                  mul(0)
//     //               /          \
//     //            mul(1)       abs(14)
//     //           /     \             \
//     //       is_le(2)  sub(8)        sub(15)
//     //      /  \         /  \           /   \
//     // pow(3) 2050(7) 30(9) mod(10) not(16) sqrt(21)
//     //   / \                 /   \      |       |
//     // 2(4) mem(5)      mem(11) 47(13) mul(17)  150(22)
//     //       |           |              /    \
//     //      1(6)        0(12)     mem(18)  3(20)
//     //                              |
//     //                             1(19)
//     //
//     // Tree 3 (output = 350):
//     //                  mul(0)
//     //                 /     \
//     //             add(1)     sqrt(6)
//     //              /   \        |
//     //        pow(2)    6(5)   25(7)
//     //        /   \
//     //     2(3)   6(4)

// alloc_locals;
//     let (local state_tree: Node*) = alloc();
//     let (local general_tree: Node*) = alloc();
//     let (local mem: felt*) = alloc();
//     let (local offset: felt*) = alloc();
//     // offset
//     assert offset[0] = 29;
//     assert offset[1] = 0;
//     // Node 1
//     assert state_tree[0] = Node(ns_opcodes.MUL, 1, 16);
//     assert state_tree[1] = Node(ns_opcodes.ADD, 1, 9);
//     assert state_tree[2] = Node(ns_opcodes.IS_LE, 1, 7);
//     assert state_tree[3] = Node(ns_opcodes.POW, 1, 2);
//     assert state_tree[4] = Node(2, -1, -1);
//     assert state_tree[5] = Node(ns_opcodes.ADD, 1, 3);
//     assert state_tree[6] = Node(ns_opcodes.NOT, -1, 1);
//     assert state_tree[7] = Node(0, -1, -1);
//     assert state_tree[8] = Node(5, -1, -1);
//     assert state_tree[9] = Node(128, -1, -1);
//     assert state_tree[10] = Node(ns_opcodes.DIV, 1, 2);
//     assert state_tree[11] = Node(150, -1, -1);
//     assert state_tree[12] = Node(ns_opcodes.MOD, 1, 3);
//     assert state_tree[13] = Node(ns_opcodes.FUNC, -1, 1);
//     assert state_tree[14] = Node(0, -1, -1);
//     assert state_tree[15] = Node(48, -1, -1);
//     assert state_tree[16] = Node(ns_opcodes.SUB, 1, 2);
//     assert state_tree[17] = Node(20, -1, -1);
//     assert state_tree[18] = Node(ns_opcodes.ABS, -1, 1);
//     assert state_tree[19] = Node(ns_opcodes.SUB, 1, 7);
//     assert state_tree[20] = Node(ns_opcodes.IS_NN, -1, 1);
//     assert state_tree[21] = Node(ns_opcodes.MUL, 1, 4);
//     assert state_tree[22] = Node(ns_opcodes.EQ, 1, 2);
//     assert state_tree[23] = Node(10, -1, -1);
//     assert state_tree[24] = Node(10, -1, -1);
//     assert state_tree[25] = Node(33, -1, -1);
//     assert state_tree[26] = Node(ns_opcodes.SQRT, -1, 1);
//     assert state_tree[27] = Node(ns_opcodes.DICT, -1, 1);
//     assert state_tree[28] = Node(10, -1, -1);
//     // Node 2
//     assert state_tree[29] = Node(ns_opcodes.MUL, 1, 14);
//     assert state_tree[30] = Node(ns_opcodes.MUL, 1, 7);
//     assert state_tree[31] = Node(ns_opcodes.IS_LE, 1, 5);
//     assert state_tree[32] = Node(ns_opcodes.POW, 1, 2);
//     assert state_tree[33] = Node(2, -1, -1);
//     assert state_tree[34] = Node(ns_opcodes.MEM, -1, 1);
//     assert state_tree[35] = Node(1, -1, -1);
//     assert state_tree[36] = Node(2050, -1, -1);
//     assert state_tree[37] = Node(ns_opcodes.SUB, 1, 2);
//     assert state_tree[38] = Node(30, -1, -1);
//     assert state_tree[39] = Node(ns_opcodes.MOD, 1, 3);
//     assert state_tree[40] = Node(ns_opcodes.MEM, -1, 1);
//     assert state_tree[41] = Node(0, -1, -1);
//     assert state_tree[42] = Node(47, -1, -1);
//     assert state_tree[43] = Node(ns_opcodes.ABS, -1, 1);
//     assert state_tree[44] = Node(ns_opcodes.SUB, 1, 6);
//     assert state_tree[45] = Node(ns_opcodes.NOT, -1, 1);
//     assert state_tree[46] = Node(ns_opcodes.MUL, 1, 3);
//     assert state_tree[47] = Node(ns_opcodes.MEM, -1, 1);
//     assert state_tree[48] = Node(1, -1, -1);
//     assert state_tree[49] = Node(3, -1, -1);
//     assert state_tree[50] = Node(ns_opcodes.SQRT, -1, 1);
//     assert state_tree[51] = Node(150, -1, -1);
//     // Node 3
//     assert general_tree[0] = Node(ns_opcodes.MUL, 1, 6);
//     assert general_tree[1] = Node(ns_opcodes.ADD, 1, 4);
//     assert general_tree[2] = Node(ns_opcodes.POW, 1, 2);
//     assert general_tree[3] = Node(2, -1, -1);
//     assert general_tree[4] = Node(6, -1, -1);
//     assert general_tree[5] = Node(6, -1, -1);
//     assert general_tree[6] = Node(ns_opcodes.SQRT, -1, 1);
//     assert general_tree[7] = Node(25, -1, -1);

// let (dict) = default_dict_new(default_value=0);
//     dict_write{dict_ptr=dict}(key=10, new_value=400);
//     let (functions) = default_dict_new(default_value=0);
//     dict_write{dict_ptr=functions}(key=0, new_value=cast(general_tree, felt));

// let (result, functions_new, dict_new) = BinaryOperatorTree.execute_tree_chain(
//         2, offset, state_tree, 0, mem, functions, dict
//     );
//     assert result = 108;

// default_dict_finalize(
//         dict_accesses_start=dict_new, dict_accesses_end=dict_new, default_value=0
//     );
//     default_dict_finalize(
//         dict_accesses_start=functions_new, dict_accesses_end=functions_new, default_value=0
//     );
//     return ();
// }
