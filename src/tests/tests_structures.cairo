// Local imports
use operator_tree::structures::node::NodeTrait;

// External imports
use option::OptionTrait;
use box::BoxTrait;

#[test]
#[available_gas(0x100000)]
fn node_insert_test() {
    // Given
    let mut node_root = NodeTrait::new(0);

    // When
    node_root.insert(1, bool::True(()));

    // Then
    assert(node_root.left.unwrap().unbox().value == 0, 'expected left node with 1');
}
