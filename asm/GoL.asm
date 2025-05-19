#########################################################
# 		  The Game of Life			#
# 	   Parmida Hooshang - Sina Liaghat		#
#########################################################

.data
origin: 		.word	1, 2, 3, 4, 5, 6, 7, 8
presence: 		.space	32
in_between:		.space 	32
corpse: 		.word 	-1:8
everlasting:	.space 	1
days:			.space	1
iterations:		.byte	5:1

newline:		.asciiz	"\n"
msg1:			.asciiz	"GSA:\n"
msg2:			.asciiz	"Corpse Array:\n"

.text
.globl Genesis

#########################################################
# Name: Genesis					        #
# Functionality: Runs the game			        #
# Result: Flow of life			        	#
# Uses: Crystal_ball, Tomorrow, Resurrection            #
#########################################################
Genesis: 
	la		$a1, presence
	la		$a0, in_between
	jal 	Resurrection		# presence = origin
	
	jal 	Crystal_ball

	la		$a1, presence
	la		$a0, in_between
	jal 	Resurrection		# presence = origin

	# iterations -> days
	# walls -> corpse

	la		$s5, days
	lb		$s5, 0($s5)
	addi	$s0, $zero, 0
	
_flow:
	beq		$s0, $s5, _eternity
	
	jal 	Tomorrow

	la		$a1, presence
	la		$a0, in_between
	jal 	Resurrection		# presence = in_between

	# print presence
	addi 	$v0, $zero, 4
	la 		$a0, msg1
	syscall

	addi 	$t2, $zero, 0
	addi 	$t3, $zero, 7
	la 		$t4, presence

_print1:
	beq		$t2, $t3, _end1

	addi 	$v0, $zero, 1
	lw 		$a0, 0($t4)
	syscall

	addi 	$v0, $zero, 4
	la 		$a0, newline
	syscall

	addi 	$t2, $t2, 1
	addi 	$t4, $t4, 4
	j 		_print1

_end1:
	addi 	$v0, $zero, 4
	la 		$a0, newline
	syscall

	# print corpses
	addi 	$v0, $zero, 4
	la 		$a0, msg2
	syscall

	addi 	$t2, $zero, 0
	addi 	$t3, $zero, 7
	la 		$t4, corpse

_print2:
	beq		$t2, $t3, _end2

	addi 	$v0, $zero, 1
	lw 		$a0, 0($t4)
	syscall

	addi 	$v0, $zero, 4
	la 		$a0, newline
	syscall

	addi 	$t2, $t2, 1
	addi 	$t4, $t4, 4
	j 		_print2

_end2:
	addi 	$v0, $zero, 4
	la 		$a0, newline
	syscall

	addi 	$s0, $s0, 1
	j 		_flow

_eternity:	
	addi 	$v0, $zero, 10
	syscall


#########################################################
# Name: Fate						#
# Functionality: Determines the future of a cell	#
# Result: The cell's state of life 			#
# Uses: -					        # 
#########################################################
Fate:

	jr	$ra	# Return to caller

#########################################################
# Name: Tomorrow				 	#
# Functionality: Evaluates the next state 	        #
# Results: Next state GSA and the everlasting flag	#
# Uses: Fate					        # 
#########################################################
Tomorrow:
	addi 	$sp, $sp, -4	# Allocate stack space
 	sw 	$ra, 0($sp) 	# Save return address

	la	$t0, everlasting	# Load everlasting address
	addi	$t1, $zero, 1		# Set $t1 = 1
	sb	$t1, 0($t0)		# Initialize everlasting flag = 1

	xor	$t0, $t0, $t0	# Initialize row index = 0
	xor	$t1, $t1, $t1	# Initialize col index = 0 (later reused for everlasting flag) :)
	addi	$t2, $zero, 8 	# Max rows = 8
	addi	$t3, $zero, 12	# Max cols = 12
	addi	$t4, $zero, 1	# One-hot mask
	la	$t5, presence	# Current GSA (presence) address
	la	$t6, in_between	# Next GSA (in_between) address
	xor	$t7, $t7, $t7	# Current GSA word
	xor	$t8, $t8, $t8	# Next GSA word
	addi	$t9, $zero, -1	# One-hot complement mask

_proc_row:
	beq	$t0, $t2, _end_proc_row	# Exit if all rows processed
	xor	$t1, $t1, $t1		# Reset col index = 0
	addi	$t4, $zero, 1		# Reset one-hot mask
	lw	$t7, 0($t5)		# Load current GSA word
	lw	$t8, 0($t6)		# Load next GSA word

_proc_col:
	beq	$t1, $t3, _end_proc_col	# Exit if all cols processed
	add	$a0, $zero, $t0		# Pass row index to Fate
	add	$a1, $zero, $t1		# Pass col index to Fate
	jal	Fate			# Call Fate
	beq	$v0, $zero, _kill_cell	# Branch if cell dies

	or	$t8, $t8, $t4		# Set cell alive (OR with one-hot mask)
	j	_spare_cell		# Keep cell alive

_kill_cell:
	addi	$t9, $zero, -1		# Reset complement mask
	xor	$t9, $t9, $t4		# Invert one-hot mask
	and	$t8, $t8, $t9		# Clear cell

_spare_cell:
	sll	$t4, $t4, 1		# Shift one-hot mask left (for next cell)
	addi	$t1, $t1, 1		# Increment col index
	j	_proc_col		# Continue the loop

_end_proc_col:
	bne	$t7, $t8, _evolving	# If GSA changed, clear everlasting flag
	j	_not_evolving		# Else, keep the current everlasting flag

_evolving:
	la	$t1, everlasting	# Load everlasting address (reusing $t1) :)
	sb	$zero, 0($t1)		# clear everlasting flag 

_not_evolving:
	sw	$t8, 0($t6)		# Store next GSA word
	addi	$t0, $t0, 1		# Increment row index
	addi	$t5, $t5, 4		# Move to next GSA word
	addi	$t6, $t6, 4		# Move to next GSA word
	j	_proc_row		# Continue the loop

_end_proc_row:
 	lw 	$ra, 0($sp) 		# Restore return address
 	addi 	$sp, $sp, 4 		# Deallocate stack space
	jr	$ra			# Return to caller


#########################################################
# Name: Crystal_ball					#
# Functionality: Unveils the destined conclusion  	#
# Results: Number of days, position of corpses     	#
# Uses: Tomorrow                           		#
#########################################################
Crystal_ball:
	# got to utilize the stack...
	la 		$s0, iterations
	lb 		$s0, 0($s0)
	addi 	$s1, $zero, 0

_loopcb:
	beq 	$s1, $s0, _endcb

	addi 	$s2, $ra, 0
	jal 	Tomorrow
	addi 	$ra, $s2, 0
	
	la 		$s2, everlasting
	lb 		$s2, 0($s2)
	addi 	$s3, $zero, 1

	addi 	$s1, $s1, 1
	bne 	$s2, $s3, _loopcb

_endcb:
	la 		$t0, days
	sb 		$s1, 0($t0)

	jr 		$ra

#########################################################
# Name: Resurrection					#
# Functionality: Swaps two GSAs 	        	#
# Result: Today is yesterday's tomorrow			#
# Uses: -					        #
#########################################################
Resurrection:
	jr 		$ra


