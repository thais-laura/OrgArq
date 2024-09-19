# Lê um número do teclado: se for n >= 0, ++; se não, --
	
	.data
	.align 0
str1:	.asciz "Hello World! ++"
str2:	.asciz "Hello World! --"

	.text
	.align 2
	.global main
main:
	addi a7, zero, 5    # ler um inteiro
	ecall               # chamada ao sistema de acordo com o registrador a7
	# a leitura do número vai direto para o registrador a0
	add s0, a0, zero
	# branch less than
	blt s0, zero, print_neg
	# já comparei com zero e vi que é maior ou igual a 0
	# preciso printar a string correta (str1), fazer a chamada ecall
	# ir para outro label que printa o numero
	addi a7, zero, 4   # 4 significa printar uma string
	# o registrador a0 é o meu registrador que contém a saída!
	# então tenho que dar um load adress pro a0 pra receber o endereço do primeiro byte da string str1
	la a0, str1  	# aqui não coloca 0(str1) -- so no load word/byte
	ecall           # chamada ao sistema
	j fim	
	
print_neg:
	
	addi a7, zero, 4
	la a0, str2
	ecall	
fim:
	addi a7, zero, 1
	# tinha pensado em dar um load adress no endereço: la a0, s0; mas não precisa, pois é um inteiro!
	add a0, zero, s0
	ecall
	
	li a7, 10          # encerra o programa
	ecall