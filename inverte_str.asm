	.data
	.align 0
str: 	.asciz "thais laura"
orig: 	.asciz "A palavra original era: "
invt: 	.asciz "A palavra invertida ficou: "
newline: .asciz "\n"
	.align 2
ptr: 	.word

	.text
	.align 2
	.global main
main:
	# Definições
	# s0 - endereço da string str
	# t0 - leitura dos caracteres
	# t1 - contador dos caracteres
	# s1 - endereço do ponteiro ptr
	# s2 - endereço apontado pelo ponteiro ptr
	
	# Encontrar o tamanho da string
	la s0, str		# s0 = &str
	lb t0, 0(s0)		# t0 = str[0]
	addi t1, zero, 1	# t1 = i = 1 = qtd_caracteres
	
qtd_caracteres:
	beq t0, zero, sai_loop	# if(str[i] == 0) --> condição de parada
	addi s0, s0, 1		# s0 = &str + 1
	lb t0, 0(s0) 		# t0 = str[i]
	addi t1, t1, 1		# i++
	j qtd_caracteres
	
sai_loop:
	
	
	# Alocação de memória para o ponteiro com t1 caracteres
	addi a7, zero, 9	# Serviço 9
	add a0, zero, t1	# a0 = t1 = qtd_caracteres --> espaço a ser alocado
	ecall
	
	la s1, ptr		# Endereço do ponteiro
	sw a0, 0(s1)		# Insere o endereço para o qual o ponteiro aponta
	
	# Inverter
	# s0 - endereço da string str
	# s2 - endereço da string str_invertida
	# t0 - leitura dos caracteres
	# t1 - quantidade de caracteres
	# t2 - cursor da string str
	# t3 - cursor da string str_invt
	
	la s0, str		# s0 = &str
	add a1, zero, s0	# auxiliar para o endereço
	lw s2, 0(s1)		# s2 = &str_invertida
	add a2, zero, s1
	addi t2, t1, -2		# i = qtd_caracteres - 2 (por começar em 0 e por não copiar o \0)
	addi t3, zero, 0	# j = 0
inversao:
	blt t2, zero, fim
	
	add a1, s0, t2
	lb t0, 0(a1)
	add a2, s2, t3
	sb t0, 0(a2)
	
	addi t2, t2, -1		# Decrementa o i
	addi t3, t3, 1		# Incrementa o j
	j inversao
	
fim:
	add a2, s2, t3
	sb zero, 0(a2)		# Inserir \0 no final

	
	# Imprimir a string original
	addi a7, zero, 4     # Serviço 4 - Print string
	la a0, orig          # Endereço da string "A palavra original era: "
	ecall

	la a0, str
	addi a7, zero, 4     # Serviço 4 - Print string
	ecall
	
	# Imprimir uma nova linha
	addi a7, zero, 4      # Serviço 4 - Imprimir string
	la a0, newline        # Carregar o endereço da string "\n" em a0
	ecall

	# Imprimir a string invertida
	addi a7, zero, 4     # Serviço 4 - Print string
	la a0, invt          # Endereço da string "A palavra invertida ficou: "
	ecall

	add a0, zero, s2
	addi a7, zero, 4     # Serviço 4 - Print string
	ecall

	# Finalizar o programa
	li a7, 10            # Serviço 10 - Encerrar programa
	ecall
	
	
