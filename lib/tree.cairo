%lang starknet

from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.alloc import alloc

from lib.constants import ns_opcodes, ns_node

struct Node {
    value: felt,
    left: felt,
    right: felt,
}

struct MemoryAccess {
    mem_len: felt,
    mem: felt*,
}

struct TreeDataSystem {
    memory: MemoryAccess,
    utility_functions_dict: DictAccess*,
    constants_dict: DictAccess*,
}

namespace BinaryOperatorTree {
    // @param trees_offset The offset of each tree in the array
    // @param trees The binary operator trees to chain
    // @param mem The chain memory used to retain tree outputs
    // @param utility_functions_dict The dictionary used to access additional trees stored by key
    // @param constants_dict The dictionary used to access additional constants stored by key
    // @return The final evaluation of the binary tree operator chain
    func execute_tree_chain{range_check_ptr}(
        trees_offset_len: felt,
        trees_offset: felt*,
        trees: Node*,
        mem_len: felt,
        mem: felt*,
        utility_functions_dict: DictAccess*,
        constants_dict: DictAccess*,
    ) -> (output: felt, utility_functions_dict_new: DictAccess*, constants_dict_new: DictAccess*) {
        if (trees_offset_len == 0) {
            return (
                output=[mem + mem_len - 1],
                utility_functions_dict_new=utility_functions_dict,
                constant_dict_new=constants_dict,
            );
        }

        let tree_data_system = TreeDataSystem(
            memory=MemoryAccess(mem_len=mem_len, mem=mem),
            utility_functions_dict=utility_functions_dict,
            constant_dict=constants_dict,
        );

        let (output, tree_data_system_new) = iterate_tree(trees, tree_data_system);

        assert [mem + tree_data_system_new.mem_len] = output;
        tempvar offset = [trees_offset];
        return execute_tree_chain(
            trees_offset_len=trees_offset_len - 1,
            trees_offset=trees_offset + 1,
            trees=trees + ns_node.NODE_SIZE * offset,
            mem_len=tree_data_system_new.memory.mem_len + 1,
            mem=tree_data_system_new.memory.mem,
            utility_functions_dict=tree_data_system_new.utility_functions_dict_new,
            constants_dict=tree_data_system_new.constants_dict,
        );
    }

    // @param tree The binary operator tree to iterate
    // @param tree_data_system The data system used to retain/access data used by the tree
    // @return output The final evaluation of the binary tree operator
    // @return tree_data_system_new The updated data system
    func iterate_tree{range_check_ptr}(tree: Node*, tree_data_system: TreeDataSystem) -> (
        output: felt, tree_data_system_new: TreeDataSystem
    ) {
        alloc_locals;

        tempvar branch = tree[0];
        local value = branch.value;

        tempvar left = branch.left;
        tempvar right = branch.right;

        if (left == -1 and right == -1) {
            return (output=value, tree_data_system_new=tree_data_system);
        }

        if (value == ns_opcodes.ADD) {
            return execute_add(tree, tree_data_system);
        }

        with_attr error_message("unknown opcode {value}") {
            assert 0 = 1;
        }

        return (output=0, tree_data_system_new=tree_data_system);
        // if (value == ns_opcodes.SUB) {
        //     let (value_left, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + left * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len_new, mem, functions_new, dict_new
        //     );
        //     return (
        //         output=value_left - value_right,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new,
        //     );
        // }
        // if (value == ns_opcodes.MUL) {
        //     let (value_left, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + left * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len_new, mem, functions_new, dict_new
        //     );
        //     return (
        //         output=value_left * value_right,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new,
        //     );
        // }
        // if (value == ns_opcodes.DIV) {
        //     let (value_left, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + left * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len_new, mem, functions_new, dict_new
        //     );
        //     let (q, _) = unsigned_div_rem(value_left, value_right);
        //     return (
        //         output=q, functions_new=functions_new, dict_new=dict_new, mem_len_new=mem_len_new
        //     );
        // }
        // if (value == ns_opcodes.MOD) {
        //     let (value_left, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + left * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len_new, mem, functions_new, dict_new
        //     );
        //     let (_, r) = unsigned_div_rem(value_left, value_right);
        //     return (
        //         output=r, functions_new=functions_new, dict_new=dict_new, mem_len_new=mem_len_new
        //     );
        // }
        // if (value == ns_opcodes.ABS and left == -1) {
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let value = abs_value(value_right);
        //     return (
        //         output=value,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new,
        //     );
        // }
        // if (value == ns_opcodes.SQRT and left == -1) {
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let value = sqrt(value_right);
        //     return (
        //         output=value,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new,
        //     );
        // }
        // if (value == ns_opcodes.POW) {
        //     let (value_left, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + left * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len_new, mem, functions_new, dict_new
        //     );
        //     let (p) = pow(value_left, value_right);
        //     return (
        //         output=p, functions_new=functions_new, dict_new=dict_new, mem_len_new=mem_len_new
        //     );
        // }
        // if (value == ns_opcodes.IS_NN and left == -1) {
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let value = is_nn(value_right);
        //     return (
        //         output=value,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new,
        //     );
        // }
        // if (value == ns_opcodes.IS_LE) {
        //     let (value_left, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + left * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len_new, mem, functions_new, dict_new
        //     );
        //     let value = is_le(value_left, value_right);
        //     return (
        //         output=value,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new,
        //     );
        // }
        // if (value == ns_opcodes.NOT and left == -1) {
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     if (value_right == 0) {
        //         return (
        //             output=1,
        //             functions_new=functions_new,
        //             dict_new=dict_new,
        //             mem_len_new=mem_len_new,
        //         );
        //     }
        //     return (
        //         output=0, functions_new=functions_new, dict_new=dict_new, mem_len_new=mem_len_new
        //     );
        // }
        // if (value == ns_opcodes.EQ) {
        //     let (value_left, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + left * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len_new, mem, functions_new, dict_new
        //     );
        //     if (value_right == value_left) {
        //         return (
        //             output=1,
        //             functions_new=functions_new,
        //             dict_new=dict_new,
        //             mem_len_new=mem_len_new,
        //         );
        //     }
        //     return (
        //         output=0, functions_new=functions_new, dict_new=dict_new, mem_len_new=mem_len_new
        //     );
        // }
        // if (value == ns_opcodes.MEM and left == -1) {
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     with_attr error_message("incorrect input value to mem {value_right}") {
        //         return (
        //             output=[mem + value_right],
        //             functions_new=functions_new,
        //             dict_new=dict_new,
        //             mem_len_new=mem_len_new,
        //         );
        //     }
        // }
        // if (value == ns_opcodes.DICT and left == -1) {
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (value) = dict_read{dict_ptr=dict_new}(key=value_right);
        //     return (
        //         output=value,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new,
        //     );
        // }
        // if (value == ns_opcodes.FUNC and left == -1) {
        //     let (value_right, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         tree + right * ns_node.NODE_SIZE, mem_len, mem, functions, dict
        //     );
        //     let (ptr) = dict_read{dict_ptr=functions_new}(key=value_right);
        //     tempvar f = cast(ptr, Node*);
        //     let (output, functions_new, dict_new, mem_len_new) = iterate_tree(
        //         f, mem_len_new, mem, functions_new, dict_new
        //     );
        //     assert [mem + mem_len_new] = output;
        //     return (
        //         output=output,
        //         functions_new=functions_new,
        //         dict_new=dict_new,
        //         mem_len_new=mem_len_new + 1,
        //     );
        // }
    }

    func execute_add{range_check_ptr}(tree: Node*, tree_data_system: TreeDataSystem) -> (
        output: felt, tree_data_system_new: TreeDataSystem
    ) {
        alloc_locals;

        tempvar left_node_offset = [tree].left;
        let (value_left, tree_data_system_new) = iterate_tree(
            tree + left_node_offset * ns_node.NODE_SIZE, tree_data_system
        );

        tempvar right_node_offset = [tree].right;
        let (value_right, tree_data_system_new) = iterate_tree(
            tree + right_node_offset * ns_node.NODE_SIZE, tree_data_system_new
        );

        return (output=value_left + value_right, tree_data_system_new=tree_data_system_new);
    }
}
