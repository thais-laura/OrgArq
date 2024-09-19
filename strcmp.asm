	.data
	.align 0
dif:	.asciz "As strings são diferentes"
ig:	.asciz "As strings são iguais"
buffer: .space 50
str2:	.asciz "thais laura anicio"
	
	.text
	.align 2
	.globl main
	# s0: endereço do buffer
	# s1: endereço da str2
	# s2: quantidade de caracteres do buffer
	# s3: quantidade de caracteres da str2
	# t0: caractere do buffer
	# t1: caractere da str2
	# t3: indica a posição no vetor de char
main:
	la a0, buffer		# a0 tem que ter o endereço do buffer de entrada
	addi a7, zero, 8
	addi a1, zero, 50
	ecall
	
	la s0, buffer         	# s0 = &buffer
	jal remove_enter
	
    	add a0, zero, s0	# a0 = &buffer
    	jal qtd_caracteres
    	add s2, zero, a1 	# s2 = qtd de caracteres do buffer
   
    	la s1, str2          	# s1 = &str2
    	add a0, zero, s1	# a0 = &str2
    	jal qtd_caracteres
    	add s3, zero, a1	# s3 = qtd de caracteres da str original
    	
    	sub t4, s2, s3
    	bgtu t4, zero, diferentes	# se já não tiverem o mesmo tamanho, não podem ser iguais
	
	addi t3, zero, 0	# t3 = 0 (inicializando o cursor da posição)
	
loop_cmp:
	bge t3, s3, iguais	# if( i >= len(str2)) -> percorreu toda a string
	lb t0, 0(s0)		# t0 = buffer[i]
	lb t1, 0(s1)		# t1 = str2[i]
	sub t4, t0, t1			# diferença entre os caracteres
	bgtu t4, zero, diferentes	# se a diferença for 0, são iguais -> continua a verificar
	addi s0, s0, 1		# incrementa o endereço
	addi s1, s1, 1		# incrementa o endereço
	addi t3, t3, 1		# incrementa o contador (i++)
	j loop_cmp
	
# Imprimir se são iguais ou não
diferentes:
	la a0, dif		# "As strings são diferentes"
	addi a7, zero, 4
	ecall
	j end_main
iguais:
	la a0, ig		# "As strings são iguais"
	addi a7, zero, 4
	ecall
	
end_main:
	addi a7, zero, 10
	ecall
	
	
# FUNÇÕES
qtd_caracteres:
	# parâmetro - a0 = endereço da string 
	lb t0, 0(a0)    	# t0 = str[0]
	addi t1, zero, 1	# t1 = i = 1 = qtd_caracteres
loop_caracteres:
	beq t0, zero, sai_loop	# if(str[i] == 0) --> condição de parada
	addi a0, a0, 1    	# a0 = &str + 1
	lb t0, 0(a0)     	# t0 = str[i]
	addi t1, t1, 1    	# i++
	j loop_caracteres
sai_loop:
	# retorno - a1 = len(string)
	add a1, zero, t1
	jr ra
	
	addi a7, zero, 10
	ecall
	
remove_enter:
	add t0, zero, a0 		# passando o endereço do buffer para t0
	addi t2, zero, 10		# '\n' = 10
loop_remove:
	lb t1, 0(t0)            	# Carregar o byte atual do buffer
	beq t1, zero, end_remove  	# Se encontrou o caractere nulo, fim da string
	beq t1, t2, insere_zero    	# Se encontrou '\n' (valor ASCII 10), substituir por '\0'
	addi t0, t0, 1          	# Avançar para o próximo byte
	j loop_remove        	# Repetir para o próximo caractere	
insere_zero:
    	sb zero, 0(t0)          # Substituir '\n' por '\0' (fim da string)
end_remove:
	jr ra