import { data_segment, load_code, next_code, interpreter } from "./asmcode.js";
import { Interpreter } from "./interpreter.js";

export function load(GSA, steps) {
    interpreter.mips = new Interpreter();

    for(let line of data_segment.split('\n')) {
        interpreter.mips.declare(line);
    }

    interpreter.mips.memory[interpreter.mips.data_labels["iterations"]] = steps;
    for (let i = 0; i < 8; i++) {
        interpreter.mips.memory[interpreter.mips.data_labels["origin"] + i * 4] = GSA[i];
    }

    interpreter.mips.code = load_code.split('\n');
    interpreter.mips.first_pass(load_code);

    interpreter.mips.control(); // run Crystall-ball
    
    let days = interpreter.mips.memory[interpreter.mips.data_labels["days"]];
    let corpse = [];
    for (let i = 0; i < 8; i++) {
        corpse[i] = interpreter.mips.memory[interpreter.mips.data_labels["corpse"] + i * 4];
    }

    return {
        corpse: corpse,
        days: days
    };
}

export function tomorrow(GSA) {

    for (let i = 0; i < 8; i++) {
        interpreter.mips.memory[interpreter.mips.data_labels["presence"] + i * 4] = GSA[i];
    }

    interpreter.mips.code = next_code.split('\n');
    interpreter.mips.first_pass(next_code);

    interpreter.mips.control(); // run Tomorrow

    let next = [];
    for (let i = 0; i < 8; i++) {
        next[i] = interpreter.mips.memory[interpreter.mips.data_labels["in_between"] + i * 4];
    }

    return next;
}

//const arr = [7,6,0,0,0,0,0,0];
//let result = load(arr, 8);
//console.log(result.corpse);
//console.log(result.days);

//result = tomorrow(arr);
//console.log(result);