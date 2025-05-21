class Interpreter {
    constructor() {
        this.registers = {
            zero: 0, at: 0, v0: 0, v1: 0, a0: 0, a1: 0, a2: 0, a3: 0,
            t0: 0, t1: 0, t2: 0, t3: 0, t4: 0, t5: 0, t6: 0, t7: 0,
            s0: 0, s1: 0, s2: 0, s3: 0, s4: 0, s5: 0, s6: 0, s7: 0,
            t8: 0, t9: 0, k0: 0, k1: 0, gp: 0, sp: 0, fp: 0, ra: 0
        };
        this.labels = {};
        this.data_labels = {}
        this.memory = new Array(1024).fill(0);
        this.code = [];
        this.pc = 0;
        this.memory_pointer = 0;
    }

    declare(data) {
        const parts = data.split(/[\s]+/);
        const name = parts[0].slice(0,-1);
        const type = parts[1];
        const values = parts[2];
        this.data_labels[name] = this.memory_pointer;
        if (type == ".space"){
            this.memory_pointer += parseInt(values);
        }
        else if (values.includes(':')){
            const tmp = values.split(':');
            const value = parseInt(tmp[0]);
            const cnt = parseInt(tmp[1]);
            for (let i = 0; i < cnt; i++) {
                this.memory[this.memory_pointer] = value;
                this.memory_pointer += 1;
            }
        }
        else {
            for (let value of values.split(',')) {
                this.memory[this.memory_pointer] = parseInt(value);
                this.memory_pointer += 1;
            }
        }
        
    }

    first_pass() {
        this.pc = 0;
        for (let line of this.code) {
            if (line.includes(':')) {
                // it's a label
                this.labels[line.trim().slice(0,-1)] = this.pc + 1;
            }
            this.pc += 1;
        }
        this.pc = 0;
    }

    execute(instruction) {
        instruction = instruction.trim();
        // addi
        if (instruction.startsWith('addi')) {
            const parts = instruction.split(/[\s,]+/);
            const rt = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const imm = parseInt(parts[3]);
            this.registers[rt] = this.registers[rs] + imm;
        }

        // la
        else if(instruction.startsWith('la')) {
            const parts = instruction.split(/[\s,]+/);
            const dest = parts[1].substring(1);
            const label = parts[2];
            this.registers[dest] = this.labels[label];
        }

        // Add other instructions...
    }
}

// Usage:
const mips = new Interpreter();
mips.execute('addi $t0, $zero, 5');
console.log(mips.registers.t0);

// There shouldn't be any whitespace between values. Not supported yet
mips.declare('origin: 		.word	1,2,3,4,5,6,7,8');
mips.declare('presence: 		.space	3');
mips.declare('corpse: 		.word 	-1:2');

let piece_of_code = 
`Genesis: 
	la		$a1, presence
	la		$a0, in_between`;

mips.code = piece_of_code.split('\n');
mips.first_pass(piece_of_code);

mips.execute('  la  $a1, Genesis');
console.log(mips.registers.a1);