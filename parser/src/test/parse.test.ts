import { expect } from 'chai';
import { branchSize, readJson, parseBranch } from '../parse';
import { Branch, Node } from '../types';

let input = [
    'ADD',
    ['MUL', ['ADD', ['EQ', 'state', 'idle'], ['EQ', 'state', 'ib1']], 'ib1'],
    ['MUL', 'idle', ['EQ', 'state', 'block']],
];

describe('Read JSON', () => {
    it('should read the file to the expected output', () => {
        let expected = {
            states: ['idle', 'ib1', 'block'],
            combos: [['focus', 'focus', 'focus', 'focus', 'release', 'idle']],
            perceptables: ['opponent_object_state'],
            state_machine: [
                {
                    inputs: ['opponent_object_state'],
                    state_function: {
                        stages: [
                            [
                                'ADD',
                                ['EQ', 'opponent_object_state', 'SLASH_STA0'],
                                [
                                    'ADD',
                                    [
                                        'EQ',
                                        'opponent_object_state',
                                        'SLASH_STA1',
                                    ],
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
                                ['MUL', ['SUB', 's0', '1'], 's1'],
                                ['MUL', 'block', 's0'],
                            ],
                        ],
                    },
                },
            ],
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
        expect(parseBranch(input)).deep.equal(expected);
    });
});
