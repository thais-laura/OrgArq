		.data
option: 	.word 0
		.align 0
menu_string:	.asciz "\nEscolha:\n0. Pedra \n1. Papel \n2.Tesoura \n3. Sair\n"

resultado_xor: 	.asciz "\nO resultado do xor foi "
pc_choice:	.asciz "\nO computador escolheu "

paper: 		.asciz "\nPapel ganhou da pedra!\n"
rock: 		.asciz "\nPedra ganhou da tesoura!\n"
scissors: 	.asciz "\nTesoura ganhou do papel!\n"

player: 	.asciz "O ganhador foi o jogador.\n"
pc: 		.asciz "O ganhador foi o computador.\n"
tie	: 	.asciz "Não houve ganhador\n"

head: 		.word 0
last: 		.word 0

border_l: 	.asciz "		    ||  "
border_m: 	.asciz "  ||  "
border_r: 	.asciz "  ||   \n"
top: 		.asciz "		    ---|RESULTS|---\n		    --|PC|---|PL|--\n"
bottom: 	.asciz "		    ----------------\n"	

	.text
	.globl main
main:
	la t0, option		# t0 = &option
	la t1, menu_string	# t1 = &menu_string
	li t3, 3		# t3 = 3 (end_menu condition)
	li s4, 0 		# s4 = 0 (counter)
menu:	
	# Print menu
	li a7, 4		# a7 = 4 = PrintString number
	add a0, zero, t1		# a0 = &menu_string = print parameter
	ecall	
			
	# Read player's choice
	li a7, 5		# a7 = 5 = ReadInt number
	ecall			
	
	bge a0, t3, end_menu	# if a0  >= t3 (user entry equal to exit menu command)
	bltz a0, end_menu	# if a0 < 0 (works as a do-while, but only stores "option" if -1 < ao < 3)
	addi s4, s4, 1
	sw a0, 0(t0)		# option = a0 (storing user entry on option memory)
	
	# Pc's choice randomly chose
	li a7, 42        	# random number
	addi a1, zero, 3        # superior limit = 3; options: 0, 1 and 2
	ecall  
	
	# Use 'xor' to know who wins
	add t4, zero, a0	# t4 = pc's choice
	lw s1, 0(t0)		# s1 = player's option
	xor a1, s1, t4		# winner = xor(player's choice, pc's choice)
	
	# Using Linked List to store the results
	add s2, zero,t4		# s2 = pc's choice
	
	jal New_Node            # Create a node and store s1 and s2
	
	
	# Print winner
	addi t6, zero, 0		# t6 = 0
	beq a1, t6, win_tie		# if a1 == 0, it's a tie
	
	addi t6, t6, 1			# t6 = 1
	beq a1, t6, win_paper		# if a1 == 1, paper wins
	
	addi t6, t6, 1			# t6 = 2
	beq a1, t6, win_rock		# if a1 == 2, rock wins
	
	addi t6, t6, 1			# t6 = 3
	beq a1, t6, win_scissors	# if a1 == 3, scissors wins

# Tie or winner's choice:
win_tie:
	la a0, tie		# Parameter of imprime_str: a0 = &tie	
	jal imprime_str		# Call function imprime_str
	j menu
	
win_rock:
	la a0, rock		# Parameter of imprime_str: a0 = &rock
	jal imprime_str		# Call function imprime_str
	
	beq s1, zero, win_player	# See who chose rock (0)
	j win_pc
	
win_paper:
	la a0, paper		# Parameter of imprime_str: a0 = &paper
	jal imprime_str		# Call function imprime_str
	
	addi t6, zero, 1	# See who chose paper (1)
	beq s1, t6, win_player
	j win_pc

win_scissors:
	la a0, scissors		# Parameter of imprime_str: a0 = &scissors
	jal imprime_str		# Call function imprime_str
	
	addi t6, zero, 2
	beq s1, t6, win_player	# See who chose scissors (2)
	j win_pc
	
# Print that the winner is the player
win_player:			
	la a0, player		# Parameter of imprime_str: a0 = &player
	jal imprime_str		# Call function imprime_str
	j menu			
	
# Print that the winner is the pc
win_pc: 	
	la a0, pc		# Parameter of imprime_str: a0 = &pc
	jal imprime_str		# Call function imprime_str
	j menu

# Function to print any string, knowing that a0 is the adress of the string (parameter)	
imprime_str:
	addi a7, zero, 4
	ecall
	jr ra
   
end_menu:
	beqz s4, exit		# if(s4 == 0) skip to exit (list has not been created yet)
	jal Print_List		# Printa a lista
	
exit:	li a7, 10		# a7 = 10 = exit number
	ecall			# exiting program


#--Linked List---------------
New_Node:
	# Use of the heap to keep content
	addi sp,sp,-16		# sp <- ra,a0,t1,t2
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	
	la t1, last             # Load the address of 'last' into t1
	lw t2, 0(t1)            # Load the value of 'last' into t2
	
	# Allocate 12 bytes of memory for the new node
	li a0, 12               # Set the number of bytes to allocate (12 bytes for the new node)
	addi a7, zero, 9          # Ecall for memory allocation (syscall 9)
	ecall
	
	# Store the address of the newly allocated memory in 'last'
	sw a0, 0(t1)            # Update 'last' to point to the newly allocated node
	
	# Check if the list is new
	beq t2, zero, new_list    # If 'last' was zero, the list is new (no nodes exist yet)
	
	# The list is not new, link the new node to the last node
	sw a0, 8(t2)            # The last node's "next" pointer points to the new node
	
new_list:
	# Store values in the new node
	sw s2, 0(a0)            # Store the first value (s2) in the first field of the node
	sw s1, 4(a0)            # Store the second value (s1) in the second field of the node
	
	# Check if this is the first node in the list (empty head)
	la t1, head             # Load the address of 'head' into t1
	lw t2, 0(t1)            # Load the value of 'head' (current head node address)
	
	bne t2, zero, not_new_list # If 'head' is not zero, it's not a new list (head already exists)
	# If it is a new list (head was zero), set head to point to the new node
	sw a0, 0(t1)            # Update 'head' to point to the new node
	
not_new_list:
	lw ra, 0(sp)		# sp -> ra,a0,t1,t2
	lw a0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	addi sp,sp, 16
	jr ra                   # Return from the function

# --Print-Linked-List----------------
Print_List:
	addi sp,sp,-12		#
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw t1, 8(sp)
	
	la t0, head             # Load the address of 'head' into t0
	lw t1, 0(t0)            # Load the first node of the list into t1
	
	# Print the top of the list graphic
	la a0, top              # Load the address of the top graphic
	addi a7, zero, 4          # Ecall for printing a string (syscall 4)
	ecall
	
loop_print:
	# Print the left border
	la a0, border_l         # Load the left border graphic
	addi a7, zero, 4          # Ecall for printing a string (syscall 4)
	ecall
	
	# Print the first value of the node
	lw a0, 0(t1)            # Load the first value of the node
	li a7, 1                # Ecall for printing a number (syscall 1)
	ecall
	
	# Print the middle border
	la a0, border_m         # Load the middle border graphic
	addi a7, zero, 4          # Ecall for printing a string (syscall 4)
	ecall
	
	# Print the second value of the node
	lw a0, 4(t1)            # Load the second value of the node
	li a7, 1                # Ecall for printing a number (syscall 1)
	ecall
	
	# Print the right border
	la a0, border_r         # Load the right border graphic
	addi a7, zero, 4          # Ecall for printing a string (syscall 4)
	ecall
	
	# Check if there is a next node
	lw t1, 8(t1)            # Load the address of the next node into t1
	bne t1, zero, loop_print  # If there is a next node, continue the loop
	
	# If there is no next node, print the bottom of the list graphic
	la a0, bottom           # Load the bottom graphic
	addi a7, zero, 4          # Ecall for printing a string (syscall 4)
	ecall
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw t1, 8(sp)
	addi sp,sp, 12
	
	jr ra                   # Return from the function
