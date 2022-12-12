import * as fs from 'fs';
import { StateMachine, Branch, Node } from './types';

export function readJson(path: string) {
    return JSON.parse(fs.readFileSync(path, 'utf-8'));
}

export default function parse(state: StateMachine) {
    let output = [];
    state.state_function.stages.forEach((s) => {
        output.push([s[0], 1, branchSize(s[2])]);
    });
}

export function parseStages(stages: Branch) {
    let output: any[] = [];
    let offsets: number[] = [];
    stages.forEach((stage) => {
        offsets.push(branchSize(stage));
        output = output.concat(...parseBranch(stage));
    });
    offsets.push(0);
    return [output, offsets];
}

function parseBranch(branch: Branch) {
    let output: any[] = [];
    const size = branchSize(branch[1]);
    const rightSize = isSingleBranch(branch[0]) ? size : size + 1;
    const leftSize = isSingleBranch(branch[0]) ? -1 : 1;
    output.push({ value: branch[0], left: leftSize, right: rightSize });
    if (typeof branch[1] === 'string' && branch[1] !== '') {
        output.push({ value: branch[1], left: -1, right: -1 });
    }
    if (typeof branch[1] === 'object') {
        output = output.concat(...parseBranch(branch[1]));
    }
    if (typeof branch[2] === 'string' && branch[2] !== '') {
        output.push({ value: branch[2], left: -1, right: -1 });
    }
    if (typeof branch[2] === 'object') {
        output = output.concat(...parseBranch(branch[2]));
    }
    return output;
}

export function branchSize(branch: Branch) {
    let count = 0;
    if (typeof branch === 'string') {
        return 1;
    }
    branch.forEach((b) => {
        if (typeof b === 'string') {
            b !== '' ? count++ : false;
        } else {
            count += branchSize(b);
        }
    });
    return count;
}

function isSingleBranch(branch: string) {
    if (
        branch == 'ABS' ||
        branch == 'MEM' ||
        branch == 'SQRT' ||
        branch == 'NOT' ||
        branch == 'IS_NN'
    ) {
        return true;
    }
    return false;
}
