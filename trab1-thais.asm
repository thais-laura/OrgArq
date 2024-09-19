	.data
	.align 2
option: 	.word 0
head: 		.word 0
end:		.word -1
	.align 0
menu_string:	.asciz "\nEscolha:\n0. Pedra \n1. Papel \n2.Tesoura \n3. Sair\n"

choice0:	.asciz "- Pedra"
choice1:	.asciz "- Papel"
choice2:	.asciz "- Tesoura"

paper: 		.asciz "\nPapel ganhou da pedra!\n"
rock: 		.asciz "\nPedra ganhou da tesoura!\n"
scissors: 	.asciz "\nTesoura ganhou do papel!\n"

player: 	.asciz "O ganhador foi o jogador.\n"
pc: 		.asciz "O ganhador foi o computador.\n"
tie	: 	.asciz "Não houve ganhador\n"

	.text
	.globl main
main:
menu:
	la t0, option		# t0 = &option
	la t1, menu_string	# t1 = &menu_string
	li s3, 3		# s3 = 3 (end_menu condition)
	
	bge x0, s3, end_menu	# while(true) -> x0 will never be >= t3
	# Print menu
	li a7, 4		# a7 = 4 = PrintString number
	add a0, x0, t1		# a0 = &menu_string = print parameter
	ecall	
			
	# Read player's choice
	li a7, 5		# a7 = 5 = ReadInt number
	ecall			
	
	beq a0, s3, end_menu	# if ao == t3 (user entry equal to exit menu command)
	sw a0, 0(t0)		# option = a0 (storing user entry on option memory)

	# Pc's choice randomly chosen
	li a7, 42        	# random number
	addi a1, zero, 3        # superior limit = 3; options: 0, 1 and 2
	ecall  
	
	# a0 já tem a escolha do computador - parametro a1 para funcao insere_lista
	add a1, zero, a0
	jal insere_lista
	
	add a0, zero, a1
	# Use 'xor' to know who wins
	add t4, zero, a0	# t4 = pc's choice
	lw s1, 0(t0)		# s1 = player's option
	xor a1, s1, t4		# winner = xor(player's choice, pc's choice)
	
	# Print pc's choice
	addi a7, zero, 1    	# a7 = 1 = PrintInt number
	ecall 
	addi a7, zero, 11	# a7 = 11 = PrintCaracter number
	addi a0, zero, 10	# a0 = '\n'
	ecall
	
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

end_menu:
	# Imprime a lista aqui
	jal print_list
	li a7, 10		# a7 = 10 = exit number
	ecall			# exiting program
	
insere_lista:
	# Alocação de memória para o elemento
	addi a0, zero, 8 	# 4 bytes for address and 4 bytes for pc's choice
	addi a7, zero, 9
	ecall
	add s0, zero, a0
	sw a1, 0(a0)		# Insere o elemento no primeiro campo
	# Como a inserção sempre ocorre pelo final da lista, o indicador do fim da lista deve ser inserido no lugar do próximo endereço
	la t1, end		# t1 = &end
	lw s2, 0(t1)		# s2 = end
	sw s2, 4(a0)		# ptr = -1

	# Caso a lista não esteja vazia, é preciso percorê-la toda para inserir um novo elemento
    	la t2, head          	# t2 = &head
    	lw t3, 0(t2)         	# t3 = head
	
	add a0, zero, s0
    	beq t3, zero, add_first   	# Se head == 0, a lista está vazia, vai para add_first

find_last:			
	lw t4, 4(t3)		# Na primeira iteração, t3 é head. depois vai sendo atualizado para o próximo elemento
    	add a0, zero, s0	# parametro para funcao - s0 é o endereco alocado para o proximo elemento
    	beq t4, s2, add_last 	# Se próximo == end, significa que é o último nó
    	add t3, zero, t4	# Move para o próximo nó
    	j find_last
    	
# parâmetro: a0 é o endereço do novo elemento
add_last:			
	sw a0, 4(t3)		# Atualiza o ponteiro do último nó (indicado no segundo campo inteiro) para apontar para o novo nó
	jr ra 	
	
# parâmetro: a0 é o endereço do novo elemento	
add_first:
	la t2, head		# Só mexe com o endereço apontado pela head na primeira inserção
	sw a0, 0(t2)         	# Primeiro elemento: head aponta para o endereço do novo elemento
    	jr ra                	

# Function to print any string, knowing that a0 is the address of the string (parameter)	
imprime_str:
	# Save ra before calling the system call
	addi sp, sp, -4		# Decrement stack pointer
	sw ra, 0(sp)		# Save ra in the stack
	
	# Call system call to print string
	addi a7, zero, 4
	ecall
	
	# Restore ra after the system call
	lw ra, 0(sp)		# Load ra back from the stack
	addi sp, sp, 4		# Increment stack pointer
	jr ra			# Return from function


# Função para imprimir a lista
print_list:
	# Save ra before entering the loop
	addi sp, sp, -4		# Decrement stack pointer
	sw ra, 0(sp)		# Save ra in the stack
	
	la t2, head          	# t2 = &head
	lw t3, 0(t2)         	# t3 = head (primeiro elemento)
	
print_loop:
	beq t3, s2, end_print   # Se t3 == -1, fim da lista, sai do loop
	lw t0, 0(t3)         	# Carrega o valor do nó atual
	# Imprimir valor (chamada de sistema para imprimir inteiro)
	add a0, zero, t0	# Coloca o valor em a0 para impressão
	addi a7, zero, 1	# syscall print_int
	ecall
	jal pc_choice		# a0 é a escolha do pc
	
	# Ir para o próximo nó
	lw t3, 4(t3)         	# Carrega o ponteiro do próximo nó
	j print_loop         	# Volta para o loop
	
end_print:
	# Restore ra after finishing the loop
	lw ra, 0(sp)		# Load ra back from the stack
	addi sp, sp, 4		# Increment stack pointer
	jr ra			# Return from function


pc_choice:
	addi sp, sp, -4		# Save ra before calling a new function
	sw ra, 0(sp)
	
	addi t0, zero, 0
	beq a0, t0, pc_pedra
	addi t0, t0, 1
	beq a0, t0, pc_papel
	addi t0, t0, 1
	beq a0, t0, pc_tesoura
	
pc_pedra:
	la a0, choice0
	jal imprime_str
	j pc_choice_end
	
pc_papel:
	la a0, choice1
	jal imprime_str
	j pc_choice_end
	
pc_tesoura:
	la a0, choice2
	jal imprime_str

pc_choice_end:
	# Restore ra after the choice is printed
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra
