	.data
	.align 0
concat: .asciz "A concatenação ficou: "
buffer1:.space 30
buffer2:.space 30
	.align 2
ptr:	.word 0

	.text
	.align 2
	.globl main
	# Definições:
	# s0: endereço do buffer1
	# s1: endereço do buffer2
	# s2: qtd de caracteres do buffer1
	# s3: qtd de caracteres do buffer2
	# s4: endereço do ptr
main:
	# Leitura da primeira string
	la a0, buffer1    	# a0 tem que ter o endereço do buffer de entrada
	addi a7, zero, 8
	addi a1, zero, 40
	ecall
    
	la s0, buffer1       	# s0 = &buffer1
	add a0, zero, s0
	jal remove_enter
    
    	add a0, zero, s0	# a0 = &buffer1
    	jal qtd_caracteres
    	add s2, zero, a1 	# s2 = qtd de caracteres do buffer1
   	
   	# Leitura da segunda string
    	la a0, buffer2    	# a0 tem que ter o endereço do buffer de entrada
	addi a7, zero, 8
	addi a1, zero, 40
	ecall
    
	la s1, buffer2         	# s1 = &buffer2
	add a0, zero, s1
	jal remove_enter
    
    	add a0, zero, s1	# a0 = &buffer2
    	jal qtd_caracteres
    	add s3, zero, a1 	# s3 = qtd de caracteres do buffer2

	add t0, s2, s3 		# soma da quantidade de caracteres das duas strings
	add a0, zero, t0
	addi a7, zero, 9
	ecall
	
	la s4, ptr
	sw a0, 0(s4)
	lw t4, 0(s4)		# t4 = &str_concatenada

	addi t1, zero, 0	# indica a posição da string concatenada
	add t2, zero, s0	# endereço do buffer2
	addi t5, s2, -1		# tam do buffer1 menos o \0
loop_str1:
	lb t3, 0(t2)
	sb t3, 0(t4)
	addi t1, t1, 1
	addi t2, t2, 1
	addi t4, t4, 1
	blt t1, t5, loop_str1
	
	add t2, zero, s1	# endereço do buffer2
	add t5, t1, s3	# não retira o \0 pq vai finalizar a string concatenada
loop_str2:
	lb t3, 0(t2)
	sb t3, 0(t4)
	addi t1, t1, 1
	addi t2, t2, 1
	addi t4, t4, 1
	blt t1, t5, loop_str2

	lw a0, 0(s4)		# endereço da string concatenada
	addi a7, zero, 4	#imprime string
	ecall
	
	addi a7, zero, 10
	ecall
	
	
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
	add t0, zero, a0     	# passando o endereço do buffer para t0
	addi t2, zero, 10    	# '\n' = 10
loop_remove:
	lb t1, 0(t0)            	# Carregar o byte atual do buffer
	beq t1, zero, end_remove  	# Se encontrou o caractere nulo, fim da string
	beq t1, t2, insere_zero    	# Se encontrou '\n' (valor ASCII 10), substituir por '\0'
	addi t0, t0, 1          	# Avançar para o próximo byte
	j loop_remove        	# Repetir para o próximo caractere    
insere_zero:
    	sb zero, 0(t0)      	# Substituir '\n' por '\0' (fim da string)
end_remove:
	jr ra
