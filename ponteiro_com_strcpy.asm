		.data
		.align 0
str_src: 	.asciz "Teste"
		.align 2			# O endereço de memória é um inteiro (align 2 e word)
ptr: 		.word                           # Ainda não alocado

		.text
		.align 2
		.globl main
main:
		# Vamos contar o número de caracteres que a string tem para a alocação
		# Sempre que formos percorrer uma string, temos que ter o endereço dela
		la s0, str_src                 # O registrador s0 armazena o endereço de memória
		lb t0, 0(s0)		       # O registrador t0 armazena o caracter 
		addi t1, zero, 1               # O registrador t1 vai ser o contador de caracteres -- pelo menos 1
qtd_caract:	                                                                                                                  
		beq t0, zero, sai_loop
		addi s0, s0, 1
		lb t0, 0(s0)
		addi t1, t1, 1
		j qtd_caract
		
		# Vamos alocar a memória de acordo com o número de caracteres
sai_loop:
		add a0, t0, zero       # Armazena a quantidade de bytes a serem alocados
		add a7, zero, 9        # Chamada ao sistema para alocação de memória (9)
		ecall
		# A seguir, pegamos o endereço do ponteiro para falar que é preciso alocar mais t1 bytes a partir da posição do endereço
		la s1, ptr
		sw a0, 0(s1)           # Pegamos o inteiro que está dentro de a0 e alocamos os bytes a partir do 0 em s1
		
		#
