#########################################################
# Name: Fate											#
# Functionality: Decides whether the cell is alive or	#
#		 dead in the next stage			#
# Results: Number of alive neighbors 		        #
# Uses: -					        # 
#########################################################
Fate:


#########################################################
# Name: Tomorrow				 	#
# Functionality: Evaluation of the next state 	        #
# Results: Next state GSA and the Everlasting flag	#
# Uses: Fate					        # 
#########################################################
Tomorrow:


#########################################################
# Name: Equilibrium				 	#
# Functionality: Comparing today and tomorrow 		#
# Results: Equality of two GSAs			        #
# Uses: -		                         	#
#########################################################
Equilibrium:


#########################################################
# Name: Today					        #
# Functionality: Resetting the current state 	        #
# Results: Swaps two GSAs			        #
# Uses: -					        #
#########################################################
Today:


#########################################################
# Name: Crystal_ball					#
# Functionality: Preprocessing 			        #
# Results: Number of iterations, Positions of walls     #
# Uses: Tomorrow, Equilibrium                           #
#########################################################
Crystal_ball:


#########################################################
# Name: main					        #
# Functionality: Body of the game		        #
# Results: Runs the game			        #
# Uses: Fate, Today, Tomorrow                           #
#########################################################
main: 
	
	jr $ra
