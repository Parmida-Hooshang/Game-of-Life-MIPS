#########################################################
# 		  The Game of Life			#
# 	   Parmida Hooshang - Sina Liaghat		#
#########################################################

.data
origin: 		.space	32
presence: 		.space	32
in_between:		.space 	32
corpse: 		.space 	32
everlasting:	.space 	1
days:			.space	1

.text
.globl Genesis

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


#########################################################
# Name: Crystal_ball					#
# Functionality: Unveils the destined conclusion  	#
# Results: Number of days, position of corpses     	#
# Uses: Tomorrow                           		#
#########################################################
Crystal_ball:


#########################################################
# Name: Resurrection					#
# Functionality: Swaps two GSAs 	        	#
# Result: Today is yesterday's tomorrow			#
# Uses: -					        #
#########################################################
Resurrection:


#########################################################
# Name: Genesis					        #
# Functionality: Runs the game			        #
# Result: Flow of life			        	#
# Uses: Crystal_ball, Tomorrow, Resurrection            #
#########################################################
Genesis: 
	# this is how you can work with the arrays
	la 		$t0, current
	addi	$t1, $zero, 25
	sw 		$t1, 0($t0) 
	
	jr 		$ra
