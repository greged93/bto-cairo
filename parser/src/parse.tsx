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

export function parseBranch(branch: Branch) {
    let output: any[] = [];
    const leftBranchSize = branchSize(branch[1]) + 1;
    output.push({ value: branch[0], left: 1, right: leftBranchSize });
    if (typeof branch[1] === 'string') {
        output.push({ value: branch[1], left: -1, right: -1 });
    }
    if (typeof branch[1] === 'object') {
        output = output.concat(...parseBranch(branch[1]));
    }
    if (typeof branch[2] === 'string') {
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
            count++;
        } else {
            count += branchSize(b);
        }
    });
    return count;
}
