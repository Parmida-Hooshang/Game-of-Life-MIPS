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
	lb		$s5, 0($s5)			# s5 = days
	addi	$s0, $zero, 0		# s0 = day counter
	
_flow:
	beq		$s0, $s5, _eternity	# if gone through all days
	
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
# Name: Pulse						#
# Functionality: Determines the current state of a cell	#
# Result: Returns 0 (dead) or 1 (alive)			#
# Uses: -						#
#########################################################
Pulse:
	# Load the ith element in the current GSA (presence)
	la	$t3, presence
	add	$t4, $zero, $a0
	sll	$t4, $t4, 2
	add	$t3, $t3, $t4
	lw	$t4, 0($t3)
	
	# Create a bitmask for the jth column
	addi	$t5, $zero, 1
	sllv	$t5, $t5, $a1
	
	# Test the bit
	xor	$v0, $v0, $v0
	and	$t4, $t4, $t5
	bne	$t4, $t5, _no_pulse
	addi	$v0, $zero, 1

	# Return the result
_no_pulse:
	jr	$ra	


#########################################################
# Name: Bound                                           #
# Functionality: Wraps (i,j) to valid GSA coordinates   #
# Input: $a0 = i (row), $a1 = j (col)                   #
# Output: -				                #
# Uses: -                                               #
#########################################################
Bound:
	bgez	$a0, _skip_fix_1
	addi	$a0, 7

_skip_fix_1:
	bgez	$a1, _skip_fix_2
	addi	$a1, 11

_skip_fix_2:
	bne	$a0, $a2, _skip_fix_3
	addi	$a0, $zero, 0

_skip_fix_3:
	bne	$a1, $a3, _skip_fix_4
	addi	$a1, $zero, 0

_skip_fix_4:
	jr	$ra


#########################################################
# Name: Fate						#
# Functionality: Determines the future of a cell	#
# Result: The cell's state of life in the next GSA	#
# Uses: Pulse, Bound				        # 
#########################################################
Fate:
	addi 	$sp, $sp, -4	# Allocate stack space
 	sw 	$ra, 0($sp) 	# Save return address

	xor	$t0, $t0, $t0
	add	$t1, $zero, $a0
	add	$t2, $zero, $a1
	addi	$a2, $zero, 8
	addi	$a3, $zero, 12

	# -1 0
	addi	$a0, $a0, -1
	jal	Bound
	jal	Pulse
	add	$t0, $t0, $v0
	add	$a0, $zero, $t1
	add	$a1, $zero, $t2

	# 0 -1
	addi	$a1, $a1, 1
	jal	Bound
	jal	Pulse
	add	$t0, $t0, $v0
	add	$a0, $zero, $t1
	add	$a1, $zero, $t2

	# +1 0
	addi	$a0, $a0, 1
	jal	Bound
	jal	Pulse
	add	$t0, $t0, $v0
	add	$a0, $zero, $t1
	add	$a1, $zero, $t2

	# 0 +1
	addi	$a1, $a1, 1
	jal	Bound
	jal	Pulse
	add	$t0, $t0, $v0
	add	$a0, $zero, $t1
	add	$a1, $zero, $t2

	# -1 -1
	addi	$a0, $a0, -1
	addi	$a1, $a1, -1
	jal	Bound
	jal	Pulse
	add	$t0, $t0, $v0
	add	$a0, $zero, $t1
	add	$a1, $zero, $t2

	# -1 +1
	addi	$a0, $a0, -1
	addi	$a1, $a1, 1
	jal	Bound
	jal	Pulse
	add	$t0, $t0, $v0
	add	$a0, $zero, $t1
	add	$a1, $zero, $t2

	# +1 -1
	addi	$a0, $a0, 1
	addi	$a1, $a1, -1
	jal	Bound
	jal	Pulse
	add	$t0, $t0, $v0
	add	$a0, $zero, $t1
	add	$a1, $zero, $t2

	# +1 +1
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

	bne	$t0, $zero, _skip_case_0_1
	bne	$t0, $t1, _skip_case_0_1
	addi	$v0, $zero, 0
	j	_return_fate
_skip_case_0_1:
	
	bne	$t0, $t2, _skip_case_2
	j	_return_fate
_skip_case_2:

	bne	$t0, $t3, _skip_case_3
	xor	$v0, $v0, $t1
	j	_return_fate
_skip_case_3:

	addi	$v0, $zero, 0

_return_fate:
	lw 	$ra, 0($sp) 
 	addi 	$sp, $sp, 4 
	jr	$ra		


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

	addi	$sp, $sp, -24
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
	sw	$t5, 20($sp)

	add	$a0, $zero, $t0		# Pass row index to Fate
	add	$a1, $zero, $t1		# Pass col index to Fate
	jal	Fate			# Call Fate

	lw	$t5, 20($sp)
	lw	$t4, 16($sp)
	lw	$t3, 12($sp)
	lw	$t2, 8($sp)
	lw	$t1, 4($sp)
	lw	$t0, 0($sp)
	addi	$sp, $sp, 24

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
# Name: Physician					#
# Functionality: Inspects corpses coming to life  	#
# Result: Updated corpse array based on presence     	#
# Uses: Pulse                         #
#########################################################
Physician:
	addi	$t2, $zero, 0	# t2 = x counter
	addi	$t3, $zero, 0	# t3 = y counter
	addi	$t4, $zero, 8	# t4 = x limit
	addi	$t5, $zero, 12	# t5 = y limit

_check1:
	beq		$t2, $t4, _endcheck1	# x is out of range
	
_check2:
	beq 	$t3, $t5, _endcheck2	# y is out of range

	# call pulse and see if it's alive	
	addi	$a0, $t2, 0
	addi	$a1, $t3, 0
	jal 	Pulse

	beq		$v0, $zero, _skipcb		# if it's dead

	addi 	$t7, $zero, 1
	sllv 	$t7, $t7, $t2
	nor 	$t7, $t7, $zero			# 11..101..11
	la		$t8, presence
	sll		$t9, $t2, 4				# which word * 4
	add	$t8, $t8, $t9			# t8 = address of the word
	lw		$t8, 0($t8)
	and 	$t8, $t8, $t7
	la		$t7, presence
	add	$t7, $t7, $t9
	sw		$t8, 0($t7)				# update the word

_skipcb:
	addi 	$t3, $t3, 1
	j 		_check2

_endcheck2:

	addi 	$t2, $t2, 1
	j		_check1
	
_endcheck1:
	jr $ra


#########################################################
# Name: Crystal_ball					#
# Functionality: Unveils the destined conclusion  	#
# Results: Number of days, position of corpses     	#
# Uses: Tomorrow, Physician                         #
#########################################################
Crystal_ball:
	# unset corpses based on the original array
	jal 	Physician

	la 		$t0, iterations		
	lb 		$t0, 0($t0)			# t0 = max iterations
	addi 	$t1, $zero, 0		# t1 = iteration counter

_loopcb:
	beq 	$t1, $t0, _endcb

	addi 	$sp, $sp, -12
	sw 		$t0, 0($sp)
	sw 		$t1, 4($sp)
	sw 		$ra, 8($sp)

	jal 	Tomorrow

	lw 		$ra, 8($sp)
	lw 		$t1, 4($sp)
	lw 		$t0, 0($sp)
	addi 	$sp, $sp, 12
	
	la		$a1, presence
	la		$a0, in_between
	jal 	Resurrection		# presence = origin

	# unset corpses based on the obtained array
	jal 	Physician

	la 		$t2, everlasting
	lb 		$t2, 0($t2)
	addi 	$t3, $zero, 1

	addi 	$t1, $t1, 1
	bne 	$t2, $t3, _loopcb	# if we have changes, continue the loop

_endcb:
	la 		$t0, days
	sb 		$t1, 0($t0)

	jr 		$ra

#########################################################
# Name: Resurrection					#
# Functionality: Moves GSA in $a1 to the GSA in $a0 	#
# Result: Today is yesterday's tomorrow			#
# Uses: -					        #
#########################################################
Resurrection:
	addi	$t0, $zero, 0
	addi	$t1, $zero, 8

_move_element:
	beq	$t0, $t1, _end_resurrection
	lw	$t2, 0($a1)
	sw	$t2, 0($a0)
	addi	$a0, $a0, 4
	addi	$a1, $a1, 4
	addi	$t0, $t0, 1
	j	_move_element

_end_resurrection:
	jr 	$ra


