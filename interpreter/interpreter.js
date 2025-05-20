class Interpreter {
    constructor() {
        this.registers = {
            zero: 0, at: 0, v0: 0, v1: 0, a0: 0, a1: 0, a2: 0, a3: 0,
            t0: 0, t1: 0, t2: 0, t3: 0, t4: 0, t5: 0, t6: 0, t7: 0,
            s0: 0, s1: 0, s2: 0, s3: 0, s4: 0, s5: 0, s6: 0, s7: 0,
            t8: 0, t9: 0, k0: 0, k1: 0, gp: 0, sp: 0, fp: 0, ra: 0
        };
        this.memory = new Array(1024).fill(0);
        this.pc = 0;
    }

    execute(instruction) {
        // addi
        if (instruction.startsWith('addi')) {
            const parts = instruction.split(/[\s,$]+/);
            const rt = parts[1];
            const rs = parts[2];
            const imm = parseInt(parts[3]);
            this.registers[rt] = this.registers[rs] + imm;
        }
        // Add other instructions...
    }
}

// Usage:
const mips = new Interpreter();
mips.execute('addi $t0, $zero, 5');
console.log(mips.registers.t0);