# Algoritmo Bubble Sort
		.data
		.align 2
vetor:		.word 7, 5, 2, 1, 1, 3, 4
max: 		.word 7
		
		.text
		.align 2
		.global main
main:
		
		# s0: endereço do vetor
		# s1: endereço de max
		# s2: max-1
		# t1: contador i
		# t2: contador j
		# # t3 = indica a posicao j ou j-1 para o vetor
		# # t4 = endereço do vetor[j]
		# # t5 = vetor[j]
		# # t6 = endereço do vetor[j-1]
		# # t0 = vetor[j-1]
		
		la s0, vetor        # endereço do vetor: s0
		la s1, max          # endereco de max: s1
		lw s2, 0(s1)        # conteudo de max: s2
		addi s2, s2, -1     # agora, s2 = max -1 (vai ser mais útil)
		
		# Inicializar i
		addi t1, zero, 0    # i = 0
		
		
# Loop externo: for(i=0; i<= max-1, i++)
for_i: 		
		bgt t1, s2, fim_i 	# Se i > max-1, fim do loop externo
		addi t1, t1, 1		# Incrementa i para a próxima iteração
		add t2, zero, s2        # j = max - 1; sempre j vai ficar = max - 1 = s2 

# Loop interno: for(j= max-1; j>i; j--)		
for_j: 		
		
		blt t2, t1, for_i       # if( j< i+ i), volta para o loop externo 
					# Condição de para do for_j -- if( j >= i+1), continua no loop interno. 
		
		# Calcular os endereços de vetor[j] e vetor[j-1]
		slli t3, t2, 2          # t3 = j * 4 (4 bytes para um inteiro -- o terceiro elemento indica o expoente do 2 - um numero imediato
		add t4, s0, t3          # t4 = endereço de vetor[j]  -- lembrando que s0 sempre estará no início do vetor
		lw t5, 0(t4)            # t5 = vetor[j]
		
		addi t3, t3, -4         # t3 = (j-1) * 4 -- antes, t3 = 4*j; agora, t3 = t3 - 4 bytes
		add t6, s0, t3          # t6 = endereço de vetor[j-1]  -- lembrando que s0 sempre estará no início do vetor
		lw t0, 0(t6)            # t0 = vetor[j-1]
		
		addi t2, t2, -1         # Decrementa j para a próxima iteração já
		ble t0, t5, for_j       # Se vetor[j-1] (t0) for maior q vetor[j] (t5), troca. Se não (menor ou igual), volta para o for j
		
		# Antes, estava trocando os valores dos próprios registradores em vez de inserir na posição desejada
		# Para inserir no vetor mesmo, é preciso ter o endereço onde vc quer inserir
		# e usar o "sw" para colocar o elemento X dentro do endereço 0(Y)
		sw t5, 0(t6)            # vetor[j-1] = vetor[j] -- quero colocar o vetor[j] (t5) na posição j-1 do vetor (t6 é o endereço)
		sw t0, 0(t4)            # vetor[j] = vetor[j-1] -- a mesma coisa do que a parte de cima
		
		j for_j			# Fez a troca, vai para a próxima iteração do for_j
		
fim_i:
		# Escrita do vetor ordenado
		addi t1, zero, 0        # Contador i começa em 0
		la s0, vetor 		# Pega o endereço do vetor
		
escrita:
		slli t2, t1, 2          # t2 = i * 4 (endereçamento 32 bits)
		add t3, s0, t2          # t3 = endereço de vetor[i]
		lw t4, 0(t3)            # t4 = vetor[i]
		
		# Início da chamada ao sistema para escrever o elemento na tela
		addi a7, zero, 1	# Printar um inteiro --> 1
		add a0, zero, t4	# Passa o número t4 (vetor[i]) para o parâmetro a0 (padrão)
		ecall			# Finalização da chamada
		
		# Nova linha após impressão de cada elemento
		li a7, 11 		# Imprimiir um caractere --> 11
		li a0, 10               # Caracter 10 da tabela ascii --> \n
		ecall
		
		addi t1, t1, 1		# Adiciona 1 na variável i para a próxima iteração
		ble t1, s2, escrita     # Se i <= max-1, continua o for da escrita
					# Se não, passa para o próximo comando: fim do programa
		# Encerramento do programa
		addi a7, zero, 10
		ecall