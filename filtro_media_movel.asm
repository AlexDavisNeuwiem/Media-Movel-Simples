# Aluno: Alex Davis Neuwiem da Silva
# Matricula: 21202103

# $s0 = Ponteiro para Entrada
# $s1 = Ponteiro para qualquer Saida
# $s2 = Armazena a quantidade de valores de Entradas
# $s3 = Armazena N
# $s4 = Ponteiro para Saida01
# $s5 = Ponteiro para Saida02
# $s6 = Armazena N da Saida01
# $s7 = Armazena N da Saida02

.data
	N:		.asciiz "\nDigite N: "
	
	Valor01:	.asciiz "\nDigite o "
	
	Valor02:	.asciiz "� valor: "
	
	Espaco:		.asciiz "	"
	
	MensFinal:	.asciiz "\nValor	Curta	Longa	Tendencia\n"
	
	Constante:	.asciiz	"Constante\n"
	
	Queda:		.asciiz	"Queda\n"
	
	Alta:		.asciiz	"Alta\n"
	
	.align 2
	Entradas:	.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	
	.align 2
	Saida01:	.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	
	.align 2
	Saida02:	.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

.text
.globl Main

Main:
	# Procedimento para armazenar na memoria os valores digitados
	jal	Inicio
	
	# $s1 = ponteiro para Saidas01
	la	$s1, Saida01
	jal	MediaMovel
	
	# $s4 = ponteiro para Saidas01
	move	$s4, $s1
	
	# $s6 armazena N
	move	$s6, $s3
	
	# $s1 = ponteiro para Saidas02
	la	$s1, Saida02
	jal	MediaMovel
	
	# $s5 = ponteiro para Saidas02
	move	$s5, $s1
	
	# $s7 armazena N
	move	$s7, $s3
	
	# Procedimento pra comparar os valores das medias moveis
	jal	Compara
	
	# Encerra o programa
	j	Fim

# Procedimento para armazenar na memoria os valores digitados ----------------------#
Inicio:
 	# $s0 = ponteiro para Entradas
 	la	$s0, Entradas
 	
 	# $t0 = ponteiro auxiliar para Entradas
	move	$t0, $s0
	
	# $s2 comeca com 0
 	li	$s2, 0
 	
 	# Armazena 0 em $f1
	mtc1	$zero, $f1
	
LoopEntrada:
	
	# $s2 armazena a quantidade de valores de Entradas
 	addi	$s2, $s2, 1
	
	# Mostrando mensagem na tela
    	la      $a0, Valor01
    	li      $v0, 4
    	syscall
    	
    	# Mostrando $s2 na tela
    	move	$a0, $s2
    	li	$v0, 1
    	syscall
    	
    	# Mostrando mensagem na tela
    	la      $a0, Valor02
    	li      $v0, 4
    	syscall
 	
	# 6 = comando para ler float do teclado
	li 	$v0, 6
	syscall 
	
	# $f0 = $f1?
	c.eq.s	$f0, $f1
	
	# Se $f0 = $f1, entao vai para Continua
	bc1t  	Continua
	
	# Armazena a entrada digitada em Entradas
	s.s 	$f0, 0($t0)
 	
 	# Indo para o proximo valor de Entradas
 	addi	$t0, $t0, 4
 	
 	# Se atingir a quantidade maxima de valores, vai para Continua
	beq	$s2, 10, Continua
 	
 	j	LoopEntrada
 
 Continua:
 	# Resetando $t0
 	li	$t0, 0
 	
 	# Retornando para Main
 	jr	$ra

#-----------------------------------------------------------------------------------#

# Procedimento pra calcular a media movel simples ----------------------------------#
MediaMovel:
	# Mostrando mensagem na tela
    	la      $a0, N
    	li      $v0, 4
    	syscall

	# 5 = comando para ler inteiro do teclado
	li 	$v0, 5
	syscall

	# $s3 armazena N
 	move 	$s3, $v0

	# $t6 = ponteiro auxiliar para Entradas
	move	$t6, $s0
	
	# $t0 = ponteiro auxiliar para Entradas
	move	$t0, $s0
	
	# $t1 = ponteiro auxiliar para Saida
	move	$t1, $s1
	
	# $t2 = contador
	li	$t2, 0
	
	# $f2 comecam com 0
	mtc1	$zero, $f2
	
	# $f4 comeca com o primeiro valor de Entradas
	l.s	$f4, 0($t0)
	
	# $f3 armazena um valor N posi��es  atraz de $f4
	l.s	$f3, 0($t6)
	
	# $f5 armazena N
	mtc1	$s3, $f5
	cvt.s.w $f5, $f5
	
	# Registrador auxiliar para truncamento
	li	$t8, 10000
	mtc1	$t8, $f8
	cvt.s.w	$f8, $f8
	
CalculaMedia:
	# Incrementando o contador
 	addi	$t2, $t2, 1
 	
 	# $f6 armazena o somatorio dos valores de Entradas
 	add.s	$f2, $f2, $f4
 	
 	# $f7 armazena a media dos valores
 	div.s	$f7, $f2, $f5
 	
 	# Truncando o resultado final
 	mul.s		$f7, $f7, $f8
 	trunc.w.s	$f7, $f7
 	cvt.s.w		$f7, $f7
 	div.s		$f7, $f7, $f8
 	
 	# Media armazenada na Saida
 	s.s	$f7, 0($t1)
 	
 	# Subtraindo $f3 de $f2
 	bge	$t2, $s3, Subtrai
 	
Volta:
	# Quando $t2 for igual a $s2, deve-se parar de calcular
	beq	$t2, 10, AntesDeSair
	
 	# Atualizando os valores
 	addi	$t0, $t0, 4
 	addi	$t1, $t1, 4
	l.s	$f4, 0($t0)

	j	CalculaMedia

AntesDeSair:
	# Resetando todos os registradores utilizados no calculo
	li	$t0, 0
	li	$t1, 0
	li	$t2, 0
	li	$t6, 0
	li	$t8, 0
	
	mtc1	$zero, $f2
	mtc1	$zero, $f3
	mtc1	$zero, $f4
	mtc1	$zero, $f5
	mtc1	$zero, $f6
	mtc1	$zero, $f7
	
	# Retornando para Main
 	jr	$ra

Subtrai:
	sub.s	$f2, $f2, $f3
	addi	$t6, $t6, 4
	l.s	$f3, 0($t6)
	
	j	Volta

#-----------------------------------------------------------------------------------#

# Procedimento pra comparar os valores das medias moveis ---------------------------#
Compara:
	# Mostrando a mensagem final na tela
    	la      $a0, MensFinal
    	li      $v0, 4
    	syscall

	# $t3 = ponteiro pra Entradas
	move	$t3, $s0
	
	# Reseta $t2
	li	$t2, 0

	# Verifica qual a maior media movel
	blt	$s7, $s6, SegundoMenor

	# $t0 e $t1 tambem sao ponteiros
	move	$t0, $s4
	move	$t1, $s5
	
	# Variavel auxiliar
	mtc1	$zero, $f10
	
	j	LoopCompara

SegundoMenor:
	# $t0 e $t1 tambem sao ponteiros
	move	$t0, $s5
	move	$t1, $s4

	j	LoopCompara

LoopCompara:
	# $f0 armazena valores da menor media movel
	l.s	$f0, 0($t0)
	
	# $f1 armazena valores da maior media movel
	l.s	$f1, 0($t1)
	
	# $f2 armazena valores de Entradas
	l.s	$f2, 0($t3)
	
	# $f2 = $f10?
	c.eq.s	$f2, $f10
	
	# Se $f2 = $f10, entao vai para Sair
	bc1t  	Sair
	
	# Incrementando o contador
	addi	$t2, $t2, 1

	# Mostrando o valor de Entradas na tela
    	mov.s	$f12, $f2
    	li      $v0, 2
    	syscall
 	
	# Mostrando espaco na tela
    	la      $a0, Espaco
    	li      $v0, 4
    	syscall
    	
    	# Mostrando o valor da menor media movel na tela
    	mov.s	$f12, $f0
    	li      $v0, 2
    	syscall
 	
	# Mostrando espaco na tela
    	la      $a0, Espaco
    	li      $v0, 4
    	syscall
 	
	# Mostrando o valor da maior media movel na tela
    	mov.s	$f12, $f1
    	li      $v0, 2
    	syscall
 	
	# Mostrando espaco na tela
    	la      $a0, Espaco
    	li      $v0, 4
    	syscall

	# Verifica se $f0 = $f1
	c.eq.s	$f0, $f1
	
	# Se $f0 = $f1, entao vai para Igual
	bc1t  	Igual

	# Verifica se $f0 < $f1
	c.lt.s 	$f0, $f1
	
	# Se $f0 < $f1, entao vai para Menor
	bc1t	Menor
	
	# Mostrando alta na tela
    	la      $a0, Alta
    	li      $v0, 4
    	syscall
    	
    	# Se $t2 = $s2, deve-se parar de comparar valores
	beq	$t2, 10, Sair
    	
    	# Atualizando os valores
    	addi	$t0, $t0, 4
    	addi	$t1, $t1, 4
    	addi	$t3, $t3, 4

	j	LoopCompara
 	
Igual:
	# Mostrando constante na tela
    	la      $a0, Constante
    	li      $v0, 4
    	syscall
    	
    	# Se $t2 = $s2, deve-se parar de comparar valores
	beq	$t2, 10, Sair
    	
    	# Atualizando os valores
    	addi	$t0, $t0, 4
    	addi	$t1, $t1, 4
    	addi	$t3, $t3, 4

	j	LoopCompara

Menor:
	# Mostrando queda na tela
    	la      $a0, Queda
    	li      $v0, 4
    	syscall
    	
    	# Se $t2 = $s2, deve-se parar de comparar valores
	beq	$t2, 10, Sair
    	
    	# Atualizando os valores
    	addi	$t0, $t0, 4
    	addi	$t1, $t1, 4
    	addi	$t3, $t3, 4

	j	LoopCompara
 	
 Sair:
 	# Retornando para Main
 	jr	$ra

#-----------------------------------------------------------------------------------#

# Fim do programa ------------------------------------------------------------------#
Fim:
	li      $v0, 10
    	syscall

#-----------------------------------------------------------------------------------#
