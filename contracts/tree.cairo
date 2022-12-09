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
    // @param trees_offset The offset of each tree in the array
    // @param trees The binary operator trees to chain
    // @param mem The chain memory used to retain tree outputs
    // @return The final evaluation of the binary tree operator chain
    func execute_tree_chain{range_check_ptr}(
        trees_offset_len: felt, trees_offset: felt*, trees: Tree*, mem_len: felt, mem: felt*
    ) -> felt {
        if (trees_offset_len == 0) {
            return [mem + mem_len - 1];
        }
        let output = iterate_tree(trees, mem);
        assert [mem + mem_len] = output;
        tempvar offset = [trees_offset];
        return execute_tree_chain(
            trees_offset_len=trees_offset_len - 1,
            trees_offset=trees_offset + 1,
            trees=trees + ns_tree.TREE_SIZE * offset,
            mem_len=mem_len + 1,
            mem=mem,
        );
    }
    // @param tree The binary operator tree to iterate
    // @param mem The memory used to retain previous tree outputs
    // @return The final evaluation of the binary tree operator
    func iterate_tree{range_check_ptr}(tree: Tree*, mem: felt*) -> felt {
        alloc_locals;
        tempvar branch = tree[0];
        local value = branch.value;
        tempvar left = branch.left;
        tempvar right = branch.right;
        if (left == -1 and right == -1) {
            return value;
        }
        if (value == ns_opcodes.ADD) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            return value_left + value_right;
        }
        if (value == ns_opcodes.SUB) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            return value_left - value_right;
        }
        if (value == ns_opcodes.MUL) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            return value_left * value_right;
        }
        if (value == ns_opcodes.DIV) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            let (q, _) = unsigned_div_rem(value_left, value_right);
            return q;
        }
        if (value == ns_opcodes.MOD) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            let (_, r) = unsigned_div_rem(value_left, value_right);
            return r;
        }
        if (value == ns_opcodes.ABS and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            return abs_value(value_right);
        }
        if (value == ns_opcodes.SQRT and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            return sqrt(value_right);
        }
        if (value == ns_opcodes.POW) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            let (p) = pow(value_left, value_right);
            return p;
        }
        if (value == ns_opcodes.IS_NN and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            return is_nn(value_right);
        }
        if (value == ns_opcodes.IS_LE) {
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            return is_le(value_left, value_right);
        }
        if (value == ns_opcodes.NOT and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            if (value_right == 0) {
                return 1;
            }
            return 0;
        }
        if (value == ns_opcodes.EQ) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            let value_left = iterate_tree(tree + left * ns_tree.TREE_SIZE, mem);
            if (value_right == value_left) {
                return 1;
            }
            return 0;
        }
        if (value == ns_opcodes.MEM and left == -1) {
            let value_right = iterate_tree(tree + right * ns_tree.TREE_SIZE, mem);
            with_attr error_message("incorrect input value to mem {value_right}") {
                return [mem + value_right];
            }
        }
        with_attr error_message("unknown opcode {value}") {
            assert 0 = 1;
        }
        return 0;
    }
}
