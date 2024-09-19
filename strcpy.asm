		.data
		.align 0
str_src: 	.asciz "Teste do strcpy"
str_dst: 	.space 16

		.text
		.align 2 # *****
		.global main
main:
		# quero percorrer minha string str_src e ir copiando byte por byte até encontrar um 0
		la s0, str_src # ****** preciso pegar o endereço da string str_src
		la s1, str_dst # ****** preciso pegar tbm o endereço da string str_dst
		
copia:
		# lê o byte (t0) de s0 e escreve o byte (t0) no s1 (destino)
		lb t0, 0(s0) # ******* antes tinha colocado direto o str_src em vez do seu endereço (s0)
		sb t0, 0(s1)        # ****** copiar byte para 0(str_dst)  --- sb <registrador_fonte>, valor (<registrador destino>)
		# mudar o ponteiro para a proxima posicao
		addi s0, s0, 1   
		addi s1, s1, 1
		
		bne t0, zero, copia             # branch NOT EQUAL   
		# j copia                       nao precisa mais tbm
#sai_loop:					nao precisa dessa label!!! é sequencial mesmo....
		addi a7, zero, 4     # printa a str_dst 
		la a0, str_dst       # carrega o endereço de str_dst para a0===
		ecall
		
		addi a7, zero, 10    # encerra programa
		ecall
		