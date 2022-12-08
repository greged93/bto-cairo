%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem, abs_value, sqrt
from starkware.cairo.common.math_cmp import is_nn, is_le
from starkware.cairo.common.pow import pow

from contracts.constants import ns_opcodes, ns_tree

struct Tree {
    value: felt,
    left: felt,
    right: felt,
}

namespace BinaryOperatorTree {
    // @param tree The binary operator tree to iterate
    // @return The final evaluation of the binary tree operator
    func iterate_tree{range_check_ptr}(tree: Tree*) -> felt {
        alloc_locals;
        tempvar branch = tree[0];
        local value = branch.value;
        tempvar left = branch.left;
        tempvar right = branch.right;
        if (left == -1 and right == -1) {
            return value;
        }
        if (value == ns_opcodes.ADD) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            return value_left + value_right;
        }
        if (value == ns_opcodes.SUB) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            return value_left - value_right;
        }
        if (value == ns_opcodes.MUL) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            return value_left * value_right;
        }
        if (value == ns_opcodes.DIV) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            let (q, _) = unsigned_div_rem(value_left, value_right);
            return q;
        }
        if (value == ns_opcodes.MOD) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            let (_, r) = unsigned_div_rem(value_left, value_right);
            return r;
        }
        if (value == ns_opcodes.ABS and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            return abs_value(value_right);
        }
        if (value == ns_opcodes.SQRT and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            return sqrt(value_right);
        }
        if (value == ns_opcodes.POW) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            let (p) = pow(value_left, value_right);
            return p;
        }
        if (value == ns_opcodes.IS_NN and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            return is_nn(value_right);
        }
        if (value == ns_opcodes.IS_LE) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE);
            return is_le(value_left, value_right);
        }
        with_attr error_message("unknown opcode {value}") {
            assert 0 = 1;
        }
        return 0;
    }
}
