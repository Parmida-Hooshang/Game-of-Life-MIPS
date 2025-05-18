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


#########################################################
# Name: Tomorrow				 	#
# Functionality: Evaluates the next state 	        #
# Results: Next state GSA and the everlasting flag	#
# Uses: Fate					        # 
#########################################################
Tomorrow:
	jr 		$ra


#########################################################
# Name: Crystal_ball					#
# Functionality: Unveils the destined conclusion  	#
# Results: Number of days, position of corpses     	#
# Uses: Tomorrow                           		#
#########################################################
Crystal_ball:
	la 		$t0, days
	addi	$t1, $zero, 1
	sb		$t1, 0($t0)
	jr 		$ra

#########################################################
# Name: Resurrection					#
# Functionality: Swaps two GSAs 	        	#
# Result: Today is yesterday's tomorrow			#
# Uses: -					        #
#########################################################
Resurrection:
	jr 		$ra


