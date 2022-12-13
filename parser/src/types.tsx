export interface StateMachine {
    inputs: string[];
    state_function: StateFunction;
}

export interface StateFunction {
    stages: Branch;
}

export type Branch = any[];

export interface Node {
    value: number | string;
    left: number;
    right: number;
}
