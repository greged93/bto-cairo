import { expect } from 'chai';
import { branchSize, readJson, parseStages } from '../parse';
import { Branch, Node } from '../types';

let input = [
    [
        'ADD',
        [
            'MUL',
            [
                'ADD',
                ['EQ', ['DICT', '', '9'], '0'],
                ['EQ', ['DICT', '', '9'], '10'],
            ],
            '10',
        ],
        ['MUL', '0', ['EQ', ['DICT', '', '9'], '3']],
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
                            ['EQ', ['DICT', '', '18'], '12'],
                            [
                                'ADD',
                                ['EQ', ['DICT', '', '18'], '26'],
                                [
                                    'ADD',
                                    ['EQ', ['DICT', '', '18'], '27'],
                                    [
                                        'ADD',
                                        ['EQ', ['DICT', '', '18'], '28'],
                                        [
                                            'ADD',
                                            ['EQ', ['DICT', '', '18'], '29'],
                                            [
                                                'ADD',
                                                [
                                                    'EQ',
                                                    ['DICT', '', '18'],
                                                    '30',
                                                ],
                                                [
                                                    'ADD',
                                                    [
                                                        'EQ',
                                                        ['DICT', '', '18'],
                                                        '31',
                                                    ],
                                                    [
                                                        'ADD',
                                                        [
                                                            'EQ',
                                                            ['DICT', '', '18'],
                                                            '68',
                                                        ],
                                                        [
                                                            'EQ',
                                                            ['DICT', '', '18'],
                                                            '73',
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
                                    ['EQ', ['DICT', '', '9'], '0'],
                                    ['EQ', ['DICT', '', '9'], '10'],
                                ],
                                '10',
                            ],
                            ['MUL', '0', ['EQ', ['DICT', '', '9'], '3']],
                        ],
                        [
                            'ADD',
                            [
                                'MUL',
                                ['SUB', ['MEM', '', '0'], '1'],
                                ['MEM', '', '1'],
                            ],
                            ['MUL', '3', ['MEM', '', '0']],
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
        let expected = 18;
        expect(branchSize(input)).to.equal(expected);
    });

    it('should return the expected parsed branch', () => {
        let expected: Node[] = [
            { value: 1, left: 1, right: 12 },
            { value: 3, left: 1, right: 10 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 9, left: -1, right: -1 },
            { value: 0, left: -1, right: -1 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 9, left: -1, right: -1 },
            { value: 10, left: -1, right: -1 },
            { value: 10, left: -1, right: -1 },
            { value: 3, left: 1, right: 2 },
            { value: 0, left: -1, right: -1 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 9, left: -1, right: -1 },
            { value: 3, left: -1, right: -1 },
        ];
        let [output, _] = parseStages(input);
        expect(output).deep.equal(expected);
    });

    it('should return the expected chained trees with correct offset', () => {
        let expected: Node[] = [
            // first tree
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 12, left: -1, right: -1 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 26, left: -1, right: -1 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 27, left: -1, right: -1 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 28, left: -1, right: -1 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 29, left: -1, right: -1 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 30, left: -1, right: -1 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 31, left: -1, right: -1 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 68, left: -1, right: -1 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 18, left: -1, right: -1 },
            { value: 73, left: -1, right: -1 },
            // second tree
            { value: 1, left: 1, right: 12 },
            { value: 3, left: 1, right: 10 },
            { value: 1, left: 1, right: 5 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 9, left: -1, right: -1 },
            { value: 0, left: -1, right: -1 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 9, left: -1, right: -1 },
            { value: 10, left: -1, right: -1 },
            { value: 10, left: -1, right: -1 },
            { value: 3, left: 1, right: 2 },
            { value: 0, left: -1, right: -1 },
            { value: 12, left: 1, right: 3 },
            { value: 14, left: -1, right: 1 },
            { value: 9, left: -1, right: -1 },
            { value: 3, left: -1, right: -1 },
            // third tree
            { value: 1, left: 1, right: 8 },
            { value: 3, left: 1, right: 5 },
            { value: 2, left: 1, right: 3 },
            { value: 13, left: -1, right: 1 },
            { value: 0, left: -1, right: -1 },
            { value: 1, left: -1, right: -1 },
            { value: 13, left: -1, right: 1 },
            { value: 1, left: -1, right: -1 },
            { value: 3, left: 1, right: 2 },
            { value: 3, left: -1, right: -1 },
            { value: 13, left: -1, right: 1 },
            { value: 0, left: -1, right: -1 },
        ];
        let json_input: Branch = readJson('./src/test/input_test.json')
            .state_machine.state_function.stages;
        let [output, offsets] = parseStages(json_input);
        expect(output).deep.equal(expected);
        expect(offsets).deep.equal([44, 18, 12, 0]);
    });
});
