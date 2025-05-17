

#########################################################
# Name: Hope					        #
# Functionality: Counting the number of alive neighbors #
# Results: Number of alive neighbors 		        #
# Uses: -					        # 
#########################################################
Hope:


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
# Name: Tomorrow				        #
# Functionality: Evaluation of the next state 	        #
# Results: GSA of the next state		        #
# Uses: Hope					        # 
#########################################################
Tomorrow:


#########################################################
# Name: Fate					        #
# Functionality: Preprocessing 			        #
# Results: Number of iterations, Positions of walls     #
# Uses: Tomorrow, Equilibrium                           #
#########################################################
Fate:


#########################################################
# Name: main					        #
# Functionality: Body of the game		        #
# Results: Runs the game			        #
# Uses: Fate, Today, Tomorrow                           #
#########################################################
main: 
	
	jr $ra
