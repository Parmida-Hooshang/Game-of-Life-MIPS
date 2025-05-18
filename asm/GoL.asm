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
# Results: Next state GSA and the Everlasting flag	#
# Uses: Fate					        # 
#########################################################
Tomorrow:


#########################################################
# Name: Crystal_ball					#
# Functionality: Unveils the destined conclusion  	#
# Results: Number of iterations, Position of walls     	#
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
# Name: main					        #
# Functionality: Runs the game			        #
# Result: Flow of life			        	#
# Uses: Crystal_ball, Tomorrow, Resurrection            #
#########################################################
main: 
	
	jr $ra
