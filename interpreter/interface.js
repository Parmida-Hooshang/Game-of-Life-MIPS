import { data_segment, load_code } from "./asmcode.js";
import { Interpreter } from "./interpreter.js";

function load(GSA, steps) {
    const mips = new Interpreter();

    for(let line of data_segment.split('\n')) {
        mips.declare(line);
    }

    mips.memory[mips.data_labels["iterations"]] = steps;
    for (let i = 0; i < 8; i++) {
        mips.memory[mips.data_labels["origin"] + i * 4] = GSA[i];
    }

    mips.code = load_code.split('\n');
    mips.first_pass(load_code);

    mips.control(); // run crystall-ball
    
    let days = mips.memory[mips.data_labels["days"]];
    let corpse = [];
    for (let i = 0; i < 8; i++) {
        corpse[i] = mips.memory[mips.data_labels["corpse"] + i * 4];
    }

    return {
        corpse: corpse,
        days: days
    };
}

const arr = [7,6,0,0,0,0,0,0];
const result = load(arr, 8);
console.log(result.corpse);
console.log(result.days);