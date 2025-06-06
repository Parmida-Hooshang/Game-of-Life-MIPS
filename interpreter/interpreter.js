export class Interpreter {
    constructor() {
        this.registers = {
            zero: 0, at: 0, v0: 0, v1: 0, a0: 0, a1: 0, a2: 0, a3: 0,
            t0: 0, t1: 0, t2: 0, t3: 0, t4: 0, t5: 0, t6: 0, t7: 0,
            s0: 0, s1: 0, s2: 0, s3: 0, s4: 0, s5: 0, s6: 0, s7: 0,
            t8: 0, t9: 0, k0: 0, k1: 0, gp: 0, sp: 0, fp: 0, ra: 0
        };
        this.labels = {};
        this.data_labels = {}
        this.memory = new Array(1024 * 4).fill(0);
        this.code = [];
        this.pc = 0;
        this.memory_pointer = 0;
    }

    declare(data) {
        data = data.trim();
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
            let step = 1;
            if (type === ".word") {
                step *= 4;
            }
            for (let i = 0; i < cnt; i++) {
                this.memory[this.memory_pointer] = value;
                this.memory_pointer += step;
            }
        }
        else {
            let step = 1;
            if (type === ".word") {
                step *= 4;
            }
            for (let value of values.split(',')) {
                this.memory[this.memory_pointer] = parseInt(value);
                this.memory_pointer += step;
            }
        }
        
    }

    first_pass() {
        this.pc = 0;
        for (let line of this.code) {
            if (line.includes(':')) {
                // it's a label
                this.labels[line.trim().slice(0,-1)] = this.pc + 1;
                // lebels hold the address (index) of their NEXT instruction
            }
            this.pc += 1;
        }
        this.pc = 0;
    }

    execute(instruction) {
        instruction = instruction.trim();
        const parts = instruction.split(/[\s,]+/);

        // -------------------- Labels -------------------- //

        // skip labels and empty lines
        if (instruction.includes(':') || instruction === "") {
            ;
        }

        // la
        else if(instruction.startsWith('la')) {
            const dest = parts[1].substring(1);
            const label = parts[2];
            this.registers[dest] = this.data_labels[label];
        }

        // ------------------ Arithmetic ------------------ //

        // addi
        else if (instruction.startsWith('addi')) {
            const rt = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const imm = parseInt(parts[3]);
            this.registers[rt] = this.registers[rs] + imm;
        }

        // add
        else if (instruction.startsWith('add')) {
            const rd = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const rt = parts[3].substring(1);
            this.registers[rd] = this.registers[rs] + this.registers[rt];
        }

        // -------------------- Logical -------------------- //

        // sllv
        else if (instruction.startsWith('sllv')) {
            const rd = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const rt = parts[3].substring(1);
            this.registers[rd] = this.registers[rs] << this.registers[rt];
        }

        // sll
        else if (instruction.startsWith('sll')) {
            const rt = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const imm = parseInt(parts[3]);
            this.registers[rt] = this.registers[rs] << imm;
        }

        // xor
        else if (instruction.startsWith('xor')) {
            const rd = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const rt = parts[3].substring(1);
            this.registers[rd] = this.registers[rs] ^ this.registers[rt];
        }

        // and
        else if (instruction.startsWith('and')) {
            const rd = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const rt = parts[3].substring(1);
            this.registers[rd] = this.registers[rs] & this.registers[rt];
        }

        // or
        else if (instruction.startsWith('or')) {
            const rd = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const rt = parts[3].substring(1);
            this.registers[rd] = this.registers[rs] | this.registers[rt];
        }

        // nor
        else if (instruction.startsWith('nor')) {
            const rd = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const rt = parts[3].substring(1);
            this.registers[rd] = ~(this.registers[rs] | this.registers[rt]);
        }

        // -------------------- Memory -------------------- //

        // load
        else if (instruction.startsWith('lw') || instruction.startsWith('lb')) {
            const rt = parts[1].substring(1);
            const offset = parseInt(parts[2].split(/[\(\)]+/)[0])/4;
            // loading bytes from non-word-aligned addresses is not supported yet.
            const rs = parts[2].split(/[\(\)]+/)[1].substring(1);

            this.registers[rt] = this.memory[this.registers[rs] + offset];
        }

        // store
        else if (instruction.startsWith('sw') || instruction.startsWith('sb')) {
            const rt = parts[1].substring(1);
            const offset = parseInt(parts[2].split(/[\(\)]+/)[0])/4;
            // storing bytes in non-word-aligned addresses is not supported yet.
            const rs = parts[2].split(/[\(\)]+/)[1].substring(1);

            this.memory[this.registers[rs] + offset] = this.registers[rt];
        }

        // ----------------- Control Path ----------------- //

        // beq
        else if(instruction.startsWith('beq')) {
            const rt = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const target = parts[3];
            if (this.registers[rs] === this.registers[rt]) {
                this.pc = this.labels[target];
            }
        }

        // bne
        else if(instruction.startsWith('bne')) {
            const rt = parts[1].substring(1);
            const rs = parts[2].substring(1);
            const target = parts[3];
            if (this.registers[rs] !== this.registers[rt]) {
                this.pc = this.labels[target];
            }
        }

        // bgez
        else if(instruction.startsWith('bgez')) {
            const reg = parts[1].substring(1);
            const target = parts[2];
            if (this.registers[reg] >= 0) {
                this.pc = this.labels[target];
            }
        }

        // jal
        else if(instruction.startsWith('jal')) {
            const target = parts[1];
            this.registers.ra = this.pc;
            this.pc = this.labels[target];
        }

        // jr
        else if(instruction.startsWith('jr')) {
            const target = parts[1].substring(1);
            this.pc = this.registers[target];
        }

        // j
        else if(instruction.startsWith('j')) {
            const target = parts[1];
            this.pc = this.labels[target];
        }

        // exit using syscall
        else if(instruction.startsWith('syscall')) {
            return false;
        }

        else{
            console.log(instruction)
        }

        return true;
    }

    control() {
        this.pc = 0;
        // Set the stack pointer to the end of memory
        // We assume that the stack is placed at the end of the memory array
        this.registers.sp = 1023 * 4;
        let status = true;
        while (status) {
            this.pc += 1;
            status = this.execute(this.code[this.pc - 1]);
        }
    }
}
