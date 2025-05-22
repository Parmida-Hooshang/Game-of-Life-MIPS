import { Interpreter } from "./interpreter.js";

export const interpreter = {
    mips: new Interpreter()
};

export const data_segment =
    `origin: 		.space	32
    presence: 		.space	32
    in_between:		.space 	32
    corpse: 		.word 	-1:8
    everlasting:	.space 	1
    days:			.space	1
    iterations:		.space	1`;

const mips_code = 
    `Pulse:
        la	$t3, presence
        add	$t4, $zero, $a0
        sll	$t4, $t4, 2
        add	$t3, $t3, $t4
        lw	$t4, 0($t3)
        
        addi	$t5, $zero, 1
        sllv	$t5, $t5, $a1
        
        xor	$v0, $v0, $v0
        and	$t4, $t4, $t5
        bne	$t4, $t5, _no_pulse
        addi	$v0, $zero, 1

    _no_pulse:
        jr	$ra	

    Bound:
        bgez	$a0, _skip_fix_1
        addi	$a0, $zero, 7

    _skip_fix_1:
        bgez	$a1, _skip_fix_2
        addi	$a1, $zero, 11

    _skip_fix_2:
        bne	$a0, $a2, _skip_fix_3
        addi	$a0, $zero, 0

    _skip_fix_3:
        bne	$a1, $a3, _skip_fix_4
        addi	$a1, $zero, 0

    _skip_fix_4:
        jr	$ra

    Fate:
        addi 	$sp, $sp, -4
        sw 	$ra, 0($sp) 	

        xor	$t0, $t0, $t0
        add	$t1, $zero, $a0
        add	$t2, $zero, $a1
        addi	$a2, $zero, 8
        addi	$a3, $zero, 12

        addi	$a0, $a0, -1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        addi	$a1, $a1, -1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        addi	$a0, $a0, 1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        addi	$a1, $a1, 1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        addi	$a0, $a0, -1
        addi	$a1, $a1, -1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        addi	$a0, $a0, -1
        addi	$a1, $a1, 1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        addi	$a0, $a0, 1
        addi	$a1, $a1, -1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        addi	$a0, $a0, 1
        addi	$a1, $a1, 1
        jal	Bound
        jal	Pulse
        add	$t0, $t0, $v0
        add	$a0, $zero, $t1
        add	$a1, $zero, $t2

        jal	Pulse

        addi	$t1, $zero, 1
        addi	$t2, $zero, 2
        addi	$t3, $zero, 3

        bne	$t0, $zero, _skip_case_0
        addi	$v0, $zero, 0
        j	_return_fate
    _skip_case_0:

        bne	$t0, $t1, _skip_case_1
        addi	$v0, $zero, 0
        j	_return_fate
    _skip_case_1:
        
        bne	$t0, $t2, _skip_case_2
        j	_return_fate
    _skip_case_2:

        bne	$t0, $t3, _skip_case_3
        addi	$v0, $zero, 1
        j	_return_fate
    _skip_case_3:

        addi	$v0, $zero, 0

    _return_fate:
        lw 	$ra, 0($sp) 
        addi 	$sp, $sp, 4 
        jr	$ra		

    Tomorrow:
        addi 	$sp, $sp, -4	
        sw 	$ra, 0($sp) 	

        la	$t0, everlasting	
        addi	$t1, $zero, 1	
        sb	$t1, 0($t0)		

        xor	$t0, $t0, $t0	
        xor	$t1, $t1, $t1	
        addi	$t2, $zero, 8 	
        addi	$t3, $zero, 12	
        addi	$t4, $zero, 1	
        la	$t5, presence	
        la	$t6, in_between	
        xor	$t7, $t7, $t7	
        xor	$t8, $t8, $t8	
        addi	$t9, $zero, -1	

    _proc_row:
        beq	$t0, $t2, _end_proc_row	
        xor	$t1, $t1, $t1		
        addi	$t4, $zero, 1	
        lw	$t7, 0($t5)		
        lw	$t8, 0($t6)		

    _proc_col:
        beq	$t1, $t3, _end_proc_col

        addi	$sp, $sp, -24
        sw	$t0, 0($sp)
        sw	$t1, 4($sp)
        sw	$t2, 8($sp)
        sw	$t3, 12($sp)
        sw	$t4, 16($sp)
        sw	$t5, 20($sp)

        add	$a0, $zero, $t0		
        add	$a1, $zero, $t1		
        jal	Fate			

        lw	$t5, 20($sp)
        lw	$t4, 16($sp)
        lw	$t3, 12($sp)
        lw	$t2, 8($sp)
        lw	$t1, 4($sp)
        lw	$t0, 0($sp)
        addi	$sp, $sp, 24

        beq	$v0, $zero, _kill_cell	

        or	$t8, $t8, $t4		
        j	_spare_cell		

    _kill_cell:
        addi	$t9, $zero, -1		
        xor	$t9, $t9, $t4		
        and	$t8, $t8, $t9		

    _spare_cell:
        sll	$t4, $t4, 1		
        addi	$t1, $t1, 1		
        j	_proc_col		

    _end_proc_col:
        bne	$t7, $t8, _evolving
        j	_not_evolving		

    _evolving:
        la	$t1, everlasting	
        sb	$zero, 0($t1)		

    _not_evolving:
        sw	$t8, 0($t6)		
        addi	$t0, $t0, 1		
        addi	$t5, $t5, 4
        addi	$t6, $t6, 4		
        j	_proc_row		

    _end_proc_row:
        lw 	$ra, 0($sp) 		
        addi 	$sp, $sp, 4 	
        jr	$ra		

    Physician:
        addi	$t2, $zero, 0	
        addi	$t4, $zero, 8	
        addi	$t5, $zero, 12	

    _check1:
        beq		$t2, $t4, _endcheck1	
        
        addi	$t3, $zero, 0	
    _check2:
        beq 	$t3, $t5, _endcheck2	

        addi	$a0, $t2, 0
        addi	$a1, $t3, 0
        
        addi	$sp, $sp, -20
        sw		$ra, 0($sp)
        sw		$t2, 4($sp)
        sw		$t3, 8($sp)
        sw		$t4, 12($sp)
        sw		$t5, 16($sp)

        jal 	Pulse

        lw		$ra, 0($sp)
        lw		$t2, 4($sp)
        lw		$t3, 8($sp)
        lw		$t4, 12($sp)
        lw		$t5, 16($sp)
        addi	$sp, $sp, 20

        beq		$v0, $zero, _skipcb		
        addi 	$t7, $zero, 1
        sllv 	$t7, $t7, $t3
        nor 	$t7, $t7, $zero			
        la		$t8, corpse
        sll		$t9, $t2, 2				
        add		$t8, $t8, $t9			
        lw		$t8, 0($t8)
        and 	$t8, $t8, $t7
        la		$t7, corpse
        add		$t7, $t7, $t9
        sw		$t8, 0($t7)			

    _skipcb:
        addi 	$t3, $t3, 1
        j 		_check2

    _endcheck2:

        addi 	$t2, $t2, 1
        j		_check1
        
    _endcheck1:
        jr 		$ra

    Crystal_ball:
        addi	$sp, $sp, -4
        sw		$ra, 0($sp)
        jal 	Physician
        lw		$ra, 0($sp)
        addi	$sp, $sp, 4

        la 		$t0, iterations		
        lb 		$t0, 0($t0)			
        addi 	$t1, $zero, 0		
    _loopcb:
        beq 	$t1, $t0, _endcb

        addi 	$sp, $sp, -12
        sw 		$t0, 0($sp)
        sw 		$t1, 4($sp)
        sw 		$ra, 8($sp)

        jal 	Tomorrow
        
        la		$a1, presence
        la		$a0, in_between
        jal 	Resurrection		
        addi	$sp, $sp, -4
        sw		$ra, 0($sp)
        jal 	Physician
        lw		$ra, 0($sp)
        addi	$sp, $sp, 4

        la 		$t2, everlasting
        lb 		$t2, 0($t2)
        addi 	$t3, $zero, 1

        lw 		$ra, 8($sp)
        lw 		$t1, 4($sp)
        lw 		$t0, 0($sp)
        addi 	$sp, $sp, 12

        addi 	$t1, $t1, 1
        bne 	$t2, $t3, _loopcb	

        addi	$t1, $t1, -1		

    _endcb:
        la 		$t0, days			
        sb 		$t1, 0($t0)
        jr 		$ra

    Resurrection:
        addi	$t0, $zero, 0
        addi	$t1, $zero, 8

    _move_element:
        beq	$t0, $t1, _end_resurrection
        lw	$t2, 0($a0)
        sw	$t2, 0($a1)
        addi	$a1, $a1, 4
        addi	$a0, $a0, 4
        addi	$t0, $t0, 1
        j	_move_element

    _end_resurrection:
        jr 	$ra`;

export const load_code =
    `la		$a1, presence
	la		$a0, origin
	jal 	Resurrection		
	
	jal 	Crystal_ball

	la		$a1, presence
	la		$a0, origin
	jal 	Resurrection
    syscall
    ` + mips_code;

export const next_code =
    `jal 	Tomorrow
    syscall
    ` + mips_code;