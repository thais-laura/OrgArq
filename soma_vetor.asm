# Soma os valores de um vetor de inteiros de tamanho definido no próprio programa
	.data
	.align 2
tam:	.word 10
vetor: 	.word 2, 3, 4, 1, 9, 40, 2, 3, 0, -1
	
	.text
	.align 2
	.global main
main:
	# Definição dos registradores
	# s0: endereço do vetor
	# s1: endereço de tam
	# s2: valor de tam
	# s3: valor de soma
	# t0: contador i
	# t1: indicará 4 * i --> posição do elemento no vetor
	# t2: endereço do elemento 4*i do vetor
	# t3: valor do elemento na posicao 4*i do vetor
	
	la s0, vetor	# endereço do vetor
	la s1, tam	# endereço de tam
	lw s2, 0(s1)	# s2 = tam
	
	addi s3, zero, 0	# soma = 0; inicialização de soma
	addi t0, zero, 0	# i = 0; inicialização do contador
	
	# Loop para somar os elementos do vetor
loop:
	bge t0, s2, sai_loop  	# if(i<tam), realiza as ações do loop; se não, sai do loop
	# shift left logical --> t1 = t0 * (2)² 
	slli t1, t0, 2		# t1 = 4*i -- ajustar a posição do cursor do endereço
	add t2, s0, t1		# t2 indica o endereço do elemento na posicao 4*i
	lw t3, 0(t2)		# t3 = vetor[i]
	
	# Adicionar o elemento à soma:
	add s3, s3, t3
	addi t0, t0, 1		# i++; próxima iteração
	j loop
	
sai_loop:
	# Escrever a soma
	addi a7, zero, 1	# Serviço 1
	add a0, zero, s3	# a0 = soma
	ecall
	
	# Encerramento do programa
	li a7, 10
	ecall
	