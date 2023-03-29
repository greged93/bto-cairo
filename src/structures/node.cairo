use option::OptionTrait;
use box::BoxTrait;

#[derive(Drop, Copy)]
struct Node {
    value: felt252,
    left: Option::<Box::<Node>>,
    right: Option::<Box::<Node>>,
}

trait NodeTrait {
    fn new(value: felt252) -> Node;
    fn insert(ref self: Node, value: felt252, to_left: bool);
}

impl NodeImpl of NodeTrait {
    fn new(value: felt252) -> Node {
        Node { value: value, left: Option::None(()), right: Option::None(()),  }
    }

    fn insert(ref self: Node, value: felt252, to_left: bool) {
        match to_left {
            bool::False(()) => {
                self.right = Option::Some(BoxTrait::new(NodeTrait::new(value)));
            },
            bool::True(()) => {
                self.left = Option::Some(BoxTrait::new(NodeTrait::new(value)));
            },
        }
    }
}

