import { expect } from 'chai';
import { branchSize, readJson, parseStages } from '../parse';
import { Branch, Node } from '../types';

let input = [
    [
        'ADD',
        [
            'MUL',
            ['ADD', ['EQ', 'state', 'idle'], ['EQ', 'state', 'ib1']],
            'ib1',
        ],
        ['MUL', 'idle', ['EQ', 'state', 'block']],
    ],
];

describe('Read JSON', () => {
    it('should read the file to the expected output', () => {
        let expected = {
            states: ['idle', 'ib1', 'block'],
            combos: [['focus', 'focus', 'focus', 'focus', 'release', 'idle']],
            perceptables: ['opponent_object_state'],
            state_machine: {
                inputs: ['opponent_object_state'],
                state_function: {
                    stages: [
                        [
                            'ADD',
                            ['EQ', 'opponent_object_state', 'SLASH_STA0'],
                            [
                                'ADD',
                                ['EQ', 'opponent_object_state', 'SLASH_STA1'],
                                [
                                    'ADD',
                                    [
                                        'EQ',
                                        'opponent_object_state',
                                        'SLASH_ATK0',
                                    ],
                                    [
                                        'ADD',
                                        [
                                            'EQ',
                                            'opponent_object_state',
                                            'SLASH_ATK1',
                                        ],
                                        [
                                            'ADD',
                                            [
                                                'EQ',
                                                'opponent_object_state',
                                                'SLASH_ATK2',
                                            ],
                                            [
                                                'ADD',
                                                [
                                                    'EQ',
                                                    'opponent_object_state',
                                                    'SLASH_ATK3',
                                                ],
                                                [
                                                    'ADD',
                                                    [
                                                        'EQ',
                                                        'opponent_object_state',
                                                        'SLASH_ATK4',
                                                    ],
                                                    [
                                                        'ADD',
                                                        [
                                                            'EQ',
                                                            'opponent_object_state',
                                                            'SLASH_ATK5',
                                                        ],
                                                        [
                                                            'ADD',
                                                            [
                                                                'EQ',
                                                                'opponent_object_state',
                                                                'UPSWING',
                                                            ],
                                                            [
                                                                'EQ',
                                                                'opponent_object_state',
                                                                'SIDECUT',
                                                            ],
                                                        ],
                                                    ],
                                                ],
                                            ],
                                        ],
                                    ],
                                ],
                            ],
                        ],
                        [
                            'ADD',
                            [
                                'MUL',
                                [
                                    'ADD',
                                    ['EQ', 'state', 'idle'],
                                    ['EQ', 'state', 'ib1'],
                                ],
                                'ib1',
                            ],
                            ['MUL', 'idle', ['EQ', 'state', 'block']],
                        ],
                        [
                            'ADD',
                            [
                                'MUL',
                                ['SUB', ['MEM', '', '0'], '1'],
                                ['MEM', '', '1'],
                            ],
                            ['MUL', 'block', ['MEM', '', '0']],
                        ],
                    ],
                },
            },
        };
        expect(readJson('./src/test/input_test.json')).deep.equal(expected);
    });
});

describe('Parse JSON', () => {
    it('should return the expected branch count', () => {
        let expected = 15;
        expect(branchSize(input)).to.equal(expected);
    });

    it('should return the expected parsed branch', () => {
        let expected: Node[] = [
            { value: 'ADD', left: 1, right: 10 },
            { value: 'MUL', left: 1, right: 8 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'state', left: -1, right: -1 },
            { value: 'idle', left: -1, right: -1 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'state', left: -1, right: -1 },
            { value: 'ib1', left: -1, right: -1 },
            { value: 'ib1', left: -1, right: -1 },
            { value: 'MUL', left: 1, right: 2 },
            { value: 'idle', left: -1, right: -1 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'state', left: -1, right: -1 },
            { value: 'block', left: -1, right: -1 },
        ];
        let [output, _] = parseStages(input);
        expect(output).deep.equal(expected);
    });

    it('should return the expected chained trees with correct offset', () => {
        let expected: Node[] = [
            // first tree
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_STA0', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_STA1', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_ATK0', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_ATK1', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_ATK2', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_ATK3', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_ATK4', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SLASH_ATK5', left: -1, right: -1 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'UPSWING', left: -1, right: -1 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'opponent_object_state', left: -1, right: -1 },
            { value: 'SIDECUT', left: -1, right: -1 },
            // second tree
            { value: 'ADD', left: 1, right: 10 },
            { value: 'MUL', left: 1, right: 8 },
            { value: 'ADD', left: 1, right: 4 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'state', left: -1, right: -1 },
            { value: 'idle', left: -1, right: -1 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'state', left: -1, right: -1 },
            { value: 'ib1', left: -1, right: -1 },
            { value: 'ib1', left: -1, right: -1 },
            { value: 'MUL', left: 1, right: 2 },
            { value: 'idle', left: -1, right: -1 },
            { value: 'EQ', left: 1, right: 2 },
            { value: 'state', left: -1, right: -1 },
            { value: 'block', left: -1, right: -1 },
            // third tree
            { value: 'ADD', left: 1, right: 8 },
            { value: 'MUL', left: 1, right: 5 },
            { value: 'SUB', left: 1, right: 3 },
            { value: 'MEM', left: -1, right: 1 },
            { value: '0', left: -1, right: -1 },
            { value: '1', left: -1, right: -1 },
            { value: 'MEM', left: -1, right: 1 },
            { value: '1', left: -1, right: -1 },
            { value: 'MUL', left: 1, right: 2 },
            { value: 'block', left: -1, right: -1 },
            { value: 'MEM', left: -1, right: 1 },
            { value: '0', left: -1, right: -1 },
        ];
        let json_input: Branch = readJson('./src/test/input_test.json')
            .state_machine.state_function.stages;
        let [output, offsets] = parseStages(json_input);
        expect(output).deep.equal(expected);
        expect(offsets).deep.equal([39, 15, 12, 0]);
    });
});
