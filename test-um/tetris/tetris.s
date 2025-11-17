
	.data	
	.align	2
LC000:
	.byte	120
	.space	3
	.word	tecla_salir
	.byte	106
	.space	3
	.word	tecla_izquierda
	.byte	108
	.space	3
	.word	tecla_derecha
	.byte	107
	.space	3
	.word	tecla_abajo
	.byte	105
	.space	3
	.word	tecla_rotar
	.byte	116
	.space	3
	.word	tecla_truco
	.align	2
LC001:
	.string		"Tetris\n\n 1 - Jugar\n 2 - Salir\n\nElige una opción:\n"
	.align	2
LC002:
	.string		"\n¡Adiós!\n"
	.align	2
LC003:
	.string		"\nOpción incorrecta. Pulse cualquier tecla para seguir.\n"
acabar_partida:
	.space	1
	.align	2
pieza_actual_y:
	.space	4
	.align	2
pieza_actual_x:
	.space	4
	.align	2
imagen_auxiliar:
	.space	1032
	.align	2
pieza_actual:
	.space	1032
	.align	2
campo:
	.space	1032
	.align	2
pantalla:
	.space	1032
	.align	2
num_piezas:
	.word	7
	.align	2
piezas:
	.word	pieza_jota
	.word	pieza_ele
	.word	pieza_zeta
	.word	pieza_ese
	.word	pieza_barra
	.word	pieza_cuadro
	.word	pieza_te
	.align	2
pieza_te:
	.word	3
	.word	2
	.string		"\0#\0###"
	.space	1017
	.align	2
pieza_cuadro:
	.word	2
	.word	2
	.string		"####"
	.space	1019
	.align	2
pieza_ese:
	.word	3
	.word	2
	.string		"\0####\0"
	.space	1017
	.align	2
pieza_zeta:
	.word	3
	.word	2
	.string		"##"
	.string		"\0##"
	.space	1017
	.align	2
pieza_barra:
	.word	1
	.word	4
	.string		"####"
	.space	1019
	.align	2
pieza_ele:
	.word	2
	.word	3
	.string		"#"
	.string		"#"
	.string		"##"
	.space	1017
	.align	2
pieza_jota:
	.word	2
	.word	3
	.string		"\0#\0###"
	.space	1017

	.text	

tecla_salir:
	li	a4, 1
	sb	a4, acabar_partida, a5
	ret	

imagen_pixel_addr:
	lw	a5, 0(a0)
	addi	a0, a0, 8
	mul	a2, a2, a5
	add	a2, a2, a1
	add	a0, a0, a2
	ret	

imagen_set_pixel:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	a3, 12(sp)
	call	imagen_pixel_addr
	lw	a3, 12(sp)
	sb	a3, 0(a0)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret	

tecla_truco:
	addi	sp, sp, -32
	sw	s5, 4(sp)
	sw	s1, 20(sp)
	sw	s2, 16(sp)
	sw	s3, 12(sp)
	sw	s4, 8(sp)
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	la	s1, campo
	li	s2, 13
	li	s4, 1
	li	s3, 18
L000:
	lw	a5, 0(s1)
	li	s0, 0
	beq	a5, s4, L002
L001:
	mv	a1, s0
	li	a3, 35
	mv	a2, s2
	mv	a0, s1
	call	imagen_set_pixel
	lw	a5, 0(s1)
	addi	s0, s0, 1
	addi	a5, a5, -1
	bgtu	a5, s0, L001
L002:
	addi	s2, s2, 1
	bne	s2, s3, L000
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	lw	s1, 20(sp)
	lw	s2, 16(sp)
	lw	s3, 12(sp)
	lw	s4, 8(sp)
	la	a0, campo
	lw	s5, 4(sp)
	li	a3, 0
	li	a2, 16
	li	a1, 10
	addi	sp, sp, 32
	tail	imagen_set_pixel

imagen_get_pixel:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	call	imagen_pixel_addr
	lw	ra, 12(sp)
	lbu	a0, 0(a0)
	addi	sp, sp, 16
	ret	

imagen_clean:
	lw	a4, 4(a0)
	beqz	a4, L006
	lw	a5, 0(a0)
	addi	sp, sp, -32
	sw	s1, 20(sp)
	sw	s2, 16(sp)
	sw	s3, 12(sp)
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	mv	s3, a1
	mv	s1, a0
	li	s2, 0
L003:
	li	s0, 0
	beqz	a5, L005
L004:
	mv	a1, s0
	mv	a3, s3
	mv	a2, s2
	mv	a0, s1
	call	imagen_set_pixel
	lw	a5, 0(s1)
	addi	s0, s0, 1
	bgtu	a5, s0, L004
	lw	a4, 4(s1)
L005:
	addi	s2, s2, 1
	bgtu	a4, s2, L003
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	lw	s1, 20(sp)
	lw	s2, 16(sp)
	lw	s3, 12(sp)
	addi	sp, sp, 32
	ret	
L006:
	ret	

imagen_init:
	mv	a5, a1
	sw	a5, 0(a0)
	mv	a1, a3
	sw	a2, 4(a0)
	tail	imagen_clean

imagen_copy:
	lw	a4, 0(a1)
	lw	a5, 4(a1)
	sw	a4, 0(a0)
	sw	a5, 4(a0)
	beqz	a5, L010
	lw	a5, 0(a1)
	addi	sp, sp, -32
	sw	s1, 20(sp)
	sw	s2, 16(sp)
	sw	s3, 12(sp)
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	mv	s3, a0
	mv	s2, a1
	li	s1, 0
L007:
	li	s0, 0
	beqz	a5, L009
L008:
	mv	a1, s0
	mv	a2, s1
	mv	a0, s2
	call	imagen_get_pixel
	mv	a3, a0
	mv	a1, s0
	mv	a2, s1
	mv	a0, s3
	call	imagen_set_pixel
	lw	a5, 0(s2)
	addi	s0, s0, 1
	bgtu	a5, s0, L008
L009:
	lw	a4, 4(s2)
	addi	s1, s1, 1
	bgtu	a4, s1, L007
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	lw	s1, 20(sp)
	lw	s2, 16(sp)
	lw	s3, 12(sp)
	addi	sp, sp, 32
	ret	
L010:
	ret	

imagen_print:
	lw	a5, 4(a0)
	beqz	a5, L014
	addi	sp, sp, -16
	sw	s1, 4(sp)
	sw	s2, 0(sp)
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	mv	s1, a0
	li	s2, 0
L011:
	lw	a5, 0(s1)
	li	s0, 0
	beqz	a5, L013
L012:
	mv	a1, s0
	mv	a2, s2
	mv	a0, s1
	call	imagen_get_pixel
	call	print_character
	lw	a5, 0(s1)
	addi	s0, s0, 1
	bgtu	a5, s0, L012
L013:
	li	a0, 10
	call	print_character
	lw	a5, 4(s1)
	addi	s2, s2, 1
	bgtu	a5, s2, L011
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	lw	s1, 4(sp)
	lw	s2, 0(sp)
	addi	sp, sp, 16
	ret	
L014:
	ret	

imagen_dibuja_imagen:
	lw	a5, 4(a1)
	beqz	a5, L020
	addi	sp, sp, -32
	sw	s2, 16(sp)
	lw	s2, 0(a1)
	sw	s1, 20(sp)
	sw	s3, 12(sp)
	sw	s4, 8(sp)
	sw	s5, 4(sp)
	sw	s6, 0(sp)
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	mv	s6, a2
	mv	s5, a0
	mv	s1, a1
	mv	s4, a3
	li	s3, 0
L015:
	li	s0, 0
	bnez	s2, L017
	j	L019
L016:
	addi	s0, s0, 1
	bleu	s2, s0, L018
L017:
	mv	a2, s3
	mv	a1, s0
	mv	a0, s1
	call	imagen_get_pixel
	beqz	a0, L016
	mv	a3, a0
	add	a1, s0, s6
	mv	a2, s4
	mv	a0, s5
	call	imagen_set_pixel
	lw	s2, 0(s1)
	addi	s0, s0, 1
	bgtu	s2, s0, L017
L018:
	lw	a5, 4(s1)
L019:
	addi	s3, s3, 1
	addi	s4, s4, 1
	bgtu	a5, s3, L015
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	lw	s1, 20(sp)
	lw	s2, 16(sp)
	lw	s3, 12(sp)
	lw	s4, 8(sp)
	lw	s5, 4(sp)
	lw	s6, 0(sp)
	addi	sp, sp, 32
	ret	
L020:
	ret	

imagen_dibuja_imagen_rotada:
	addi	sp, sp, -48
	sw	s3, 28(sp)
	lw	s3, 4(a1)
	sw	ra, 44(sp)
	beqz	s3, L025
	sw	s4, 24(sp)
	lw	s4, 0(a1)
	sw	s1, 36(sp)
	sw	s2, 32(sp)
	sw	s5, 20(sp)
	sw	s6, 16(sp)
	sw	s7, 12(sp)
	sw	s0, 40(sp)
	mv	s6, a3
	mv	s7, a0
	mv	s1, a1
	addi	s5, a2, -1
	li	s2, 0
L021:
	li	s0, 0
	bnez	s4, L023
	j	L024
L022:
	addi	s0, s0, 1
	bleu	s4, s0, L024
L023:
	mv	a2, s2
	mv	a1, s0
	mv	a0, s1
	call	imagen_get_pixel
	beqz	a0, L022
	add	a1, s5, s3
	mv	a3, a0
	add	a2, s0, s6
	sub	a1, a1, s2
	mv	a0, s7
	call	imagen_set_pixel
	lw	s4, 0(s1)
	addi	s0, s0, 1
	lw	s3, 4(s1)
	bgtu	s4, s0, L023
L024:
	addi	s2, s2, 1
	bltu	s2, s3, L021
	lw	s0, 40(sp)
	lw	s1, 36(sp)
	lw	s2, 32(sp)
	lw	s4, 24(sp)
	lw	s5, 20(sp)
	lw	s6, 16(sp)
	lw	s7, 12(sp)
L025:
	lw	ra, 44(sp)
	lw	s3, 28(sp)
	addi	sp, sp, 48
	ret	

integer_to_string:
	beqz	a0, L030
	srai	a4, a0, 31
	xor	a5, a4, a0
	li	a7, -858992640
	sub	a5, a5, a4
	addi	a7, a7, -819
	mv	a4, a1
L026:
	mulhu	a3, a5, a7
	mv	a6, a4
	addi	a4, a4, 1
	srli	a3, a3, 3
	slli	a2, a3, 2
	add	a2, a2, a3
	slli	a2, a2, 1
	sub	a5, a5, a2
	addi	a5, a5, 48
	sb	a5, -1(a4)
	mv	a5, a3
	bnez	a3, L026
	blt	a0, zero, L031
L027:
	sb	zero, 0(a4)
	bgeu	a1, a6, L029
L028:
	lbu	a5, -1(a4)
	addi	a1, a1, 1
	sb	a5, -1(a1)
	bne	a1, a6, L028
L029:
	ret	
L030:
	li	a5, 48
	sb	zero, 1(a1)
	sb	a5, 0(a1)
	ret	
L031:
	addi	a5, a6, 2
	li	a3, 45
	sb	a3, 0(a4)
	mv	a6, a4
	mv	a4, a5
	j	L027

pieza_aleatoria:
	addi	sp, sp, -16
	li	a1, 7
	li	a0, 0
	sw	ra, 12(sp)
	call	random_int_range
	lw	ra, 12(sp)
	slli	a0, a0, 2
	la	a5, piezas
	add	a5, a5, a0
	lw	a0, 0(a5)
	addi	sp, sp, 16
	ret	

actualizar_pantalla:
	addi	sp, sp, -32
	sw	s4, 8(sp)
	sw	s5, 4(sp)
	la	a0, pantalla
	li	a1, 32
	sw	s0, 24(sp)
	sw	ra, 28(sp)
	sw	s1, 20(sp)
	la	s0, campo
	call	imagen_clean
	lw	a5, 4(s0)
	beqz	a5, L033
	li	s1, 0
L032:
	addi	a2, s1, 2
	li	a3, 124
	li	a1, 0
	la	a0, pantalla
	call	imagen_set_pixel
	lw	a1, 0(s0)
	addi	a2, s1, 2
	la	a0, pantalla
	addi	a1, a1, 1
	li	a3, 124
	call	imagen_set_pixel
	lw	a5, 4(s0)
	addi	s1, s1, 1
	bgtu	a5, s1, L032
L033:
	lw	a4, 0(s0)
	li	a5, -2
	beq	a4, a5, L035
	li	s1, 0
L034:
	lw	a2, 4(s0)
	mv	a1, s1
	li	a3, 45
	addi	a2, a2, 2
	la	a0, pantalla
	call	imagen_set_pixel
	lw	a5, 0(s0)
	addi	s1, s1, 1
	addi	a5, a5, 2
	bgtu	a5, s1, L034
L035:
	la	a1, campo
	la	a0, pantalla
	li	a3, 2
	li	a2, 1
	call	imagen_dibuja_imagen
	lw	a3, pieza_actual_y
	lw	a2, pieza_actual_x
	la	a0, pantalla
	addi	a3, a3, 2
	addi	a2, a2, 1
	la	a1, pieza_actual
	call	imagen_dibuja_imagen
	call	clear_screen
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	lw	s1, 20(sp)
	lw	s5, 4(sp)
	la	a0, pantalla
	lw	s4, 8(sp)
	addi	sp, sp, 32
	tail	imagen_print

nueva_pieza_actual:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	call	pieza_aleatoria
	mv	a1, a0
	la	a0, pieza_actual
	call	imagen_copy
	lw	ra, 12(sp)
	li	a3, 8
	sw	a3, pieza_actual_x, a4
	sw	zero, pieza_actual_y, a5
	addi	sp, sp, 16
	ret	

probar_pieza:
	addi	sp, sp, -48
	sw	s7, 12(sp)
	sw	ra, 44(sp)
	li	s7, 0
	blt	a1, zero, L036
	sw	s2, 32(sp)
	sw	s8, 8(sp)
	la	s2, campo
	lw	s8, 0(a0)
	lw	a5, 0(s2)
	sw	s1, 36(sp)
	add	s7, s8, a1
	sgtu	s7, s7, a5
	srli	a5, a2, 31
	or	s7, s7, a5
	mv	s1, a1
	beqz	s7, L037
	lw	s1, 36(sp)
	lw	s2, 32(sp)
	lw	s8, 8(sp)
	li	s7, 0
L036:
	lw	ra, 44(sp)
	mv	a0, s7
	lw	s7, 12(sp)
	addi	sp, sp, 48
	ret	
L037:
	sw	s6, 16(sp)
	lw	s6, 4(a0)
	lw	a5, 4(s2)
	add	a4, s6, a2
	bgtu	a4, a5, L042
	beqz	s8, L043
	beqz	s6, L043
	sw	s3, 28(sp)
	sw	s4, 24(sp)
	sw	s5, 20(sp)
	sw	s0, 40(sp)
	mv	s4, a2
	mv	s3, a0
	li	s5, 0
L038:
	li	s0, 0
L039:
	mv	a2, s0
	mv	a1, s5
	mv	a0, s3
	call	imagen_get_pixel
	mv	a5, a0
	add	a2, s0, s4
	mv	a1, s1
	mv	a0, s2
	beqz	a5, L040
	call	imagen_get_pixel
	bnez	a0, L041
L040:
	addi	s0, s0, 1
	bne	s6, s0, L039
	addi	s5, s5, 1
	addi	s1, s1, 1
	bne	s5, s8, L038
	li	s7, 1
L041:
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	lw	s1, 36(sp)
	lw	s2, 32(sp)
	lw	s3, 28(sp)
	lw	s4, 24(sp)
	lw	s5, 20(sp)
	lw	s6, 16(sp)
	lw	s8, 8(sp)
	mv	a0, s7
	lw	s7, 12(sp)
	addi	sp, sp, 48
	ret	
L042:
	lw	ra, 44(sp)
	lw	s1, 36(sp)
	lw	s2, 32(sp)
	lw	s6, 16(sp)
	lw	s8, 8(sp)
	mv	a0, s7
	lw	s7, 12(sp)
	addi	sp, sp, 48
	ret	
L043:
	lw	s1, 36(sp)
	lw	s2, 32(sp)
	lw	s6, 16(sp)
	lw	s8, 8(sp)
	li	s7, 1
	j	L036

intentar_movimiento:
	addi	sp, sp, -16
	sw	s0, 8(sp)
	sw	s1, 4(sp)
	mv	s0, a0
	mv	a2, a1
	mv	s1, a1
	mv	a1, a0
	la	a0, pieza_actual
	sw	ra, 12(sp)
	call	probar_pieza
	beqz	a0, L044
	sw	s0, pieza_actual_x, a4
	sw	s1, pieza_actual_y, a5
L044:
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	lw	s1, 4(sp)
	addi	sp, sp, 16
	ret	

tecla_izquierda:
	lw	a0, pieza_actual_x
	lw	a1, pieza_actual_y
	addi	a0, a0, -1
	tail	intentar_movimiento

tecla_derecha:
	lw	a0, pieza_actual_x
	lw	a1, pieza_actual_y
	addi	a0, a0, 1
	tail	intentar_movimiento

bajar_pieza_actual:
	addi	sp, sp, -16
	sw	s1, 4(sp)
	sw	s0, 8(sp)
	lw	a1, pieza_actual_y
	lw	a0, pieza_actual_x
	addi	a1, a1, 1
	sw	ra, 12(sp)
	call	intentar_movimiento
	beqz	a0, L045
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	lw	s1, 4(sp)
	addi	sp, sp, 16
	ret	
L045:
	lw	a3, pieza_actual_y
	lw	a2, pieza_actual_x
	la	a1, pieza_actual
	la	a0, campo
	call	imagen_dibuja_imagen
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	lw	s1, 4(sp)
	addi	sp, sp, 16
	tail	nueva_pieza_actual

tecla_abajo:
	tail	bajar_pieza_actual

intentar_rotar_pieza_actual:
	addi	sp, sp, -16
	sw	s0, 8(sp)
	la	s0, pieza_actual
	lw	a2, 0(s0)
	lw	a1, 4(s0)
	sw	s1, 4(sp)
	la	a0, imagen_auxiliar
	li	a3, 0
	sw	ra, 12(sp)
	call	imagen_init
	mv	a1, s0
	la	a0, imagen_auxiliar
	li	a2, 0
	li	a3, 0
	call	imagen_dibuja_imagen_rotada
	lw	a2, pieza_actual_y
	lw	a1, pieza_actual_x
	la	a0, imagen_auxiliar
	call	probar_pieza
	bnez	a0, L046
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	lw	s1, 4(sp)
	addi	sp, sp, 16
	ret	
L046:
	mv	a0, s0
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	la	a1, imagen_auxiliar
	lw	s1, 4(sp)
	addi	sp, sp, 16
	tail	imagen_copy

tecla_rotar:
	tail	intentar_rotar_pieza_actual

procesar_entrada:
	la	a5, LC000
	lw	t5, 0(a5)
	lw	t4, 4(a5)
	lw	t3, 8(a5)
	lw	t1, 12(a5)
	lw	a7, 16(a5)
	lw	a6, 20(a5)
	lw	a0, 24(a5)
	lw	a1, 28(a5)
	lw	a2, 32(a5)
	lw	a3, 36(a5)
	lw	a4, 40(a5)
	lw	a5, 44(a5)
	addi	sp, sp, -64
	sw	s0, 56(sp)
	sw	s1, 52(sp)
	sw	ra, 60(sp)
	sw	t5, 0(sp)
	sw	t4, 4(sp)
	sw	t3, 8(sp)
	sw	t1, 12(sp)
	sw	a7, 16(sp)
	sw	a6, 20(sp)
	sw	a0, 24(sp)
	sw	a1, 28(sp)
	sw	a2, 32(sp)
	sw	a3, 36(sp)
	sw	a4, 40(sp)
	sw	a5, 44(sp)
	call	keyio_poll_key
	mv	s1, a0
	mv	s0, sp
L047:
	lbu	a5, 0(s0)
	bne	a5, s1, L048
	lw	a5, 4(s0)
	jalr	a5
	call	actualizar_pantalla
L048:
	addi	s0, s0, 8
	addi	a5, sp, 48
	bne	s0, a5, L047
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	lw	s1, 52(sp)
	addi	sp, sp, 64
	ret	

jugar_partida:
	addi	sp, sp, -32
	la	a0, pantalla
	li	a3, 32
	li	a2, 22
	li	a1, 20
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	sw	s1, 20(sp)
	sw	s2, 16(sp)
	call	imagen_init
	li	a3, 0
	li	a2, 18
	la	a0, campo
	li	a1, 14
	call	imagen_init
	call	nueva_pieza_actual
	sb	zero, acabar_partida, s1
	call	get_time
	mv	s0, a0
	li	s2, 1000
	call	actualizar_pantalla
	j	L050
L049:
	call	procesar_entrada
	call	get_time
	sub	a5, a0, s0
	bgt	a5, s2, L051
L050:
	lbu	a5, acabar_partida
	beqz	a5, L049
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	lw	s1, 20(sp)
	lw	s2, 16(sp)
	addi	sp, sp, 32
	ret	
L051:
	sw	a0, 12(sp)
	call	bajar_pieza_actual
	call	actualizar_pantalla
	lw	s0, 12(sp)
	j	L050

	.globl	main
main:
	addi	sp, sp, -32
	sw	s0, 24(sp)
	sw	s2, 16(sp)
	sw	s1, 20(sp)
	sw	s3, 12(sp)
	sw	ra, 28(sp)
	la	s0, LC001
	la	s2, LC003
	li	s1, 49
	li	s3, 50
L052:
	call	clear_screen
	mv	a0, s0
	call	print_string
	call	read_character
	andi	a0, a0, 0xff
	beq	a0, s1, L053
	beq	a0, s3, L054
	mv	a0, s2
	call	print_string
	call	read_character
	j	L052
L053:
	call	jugar_partida
	j	L052
L054:
	la	a0, LC002
	call	print_string
	li	a0, 0
	call	exit

hack:
	addi	sp, sp, -16
	li	a0, 0
	sw	ra, 12(sp)
	call	imagen_print
	li	a1, 0
	li	a0, 0
	call	imagen_copy
	li	a1, 0
	li	a0, 0
	li	a3, 0
	li	a2, 0
	call	imagen_dibuja_imagen_rotada
	call	hack
	call	tecla_salir
	call	tecla_izquierda
	call	tecla_derecha
	call	tecla_abajo
	call	tecla_rotar
	call	tecla_truco
	lw	ra, 12(sp)
	li	a1, 0
	li	a0, 0
	addi	sp, sp, 16
	tail	integer_to_string

print_integer:
	li	a7, 1
	ecall	
	ret	

read_integer:
	li	a7, 5
	ecall	
	ret	

read_string:
	li	a7, 8
	ecall	
	ret	

print_character:
	li	a7, 11
	ecall	
	ret	

print_string:
	li	a7, 4
	ecall	
	ret	

get_time:
	li	a7, 30
	ecall	
	ret	

system_sleep:
	li	a7, 32
	ecall	
	ret	

read_character:
	li	a7, 12
	ecall	
	ret	

clear_screen:
	li	a7, 39
	ecall	
	ret	

exit:
	li	a7, 93
	ecall	
	ret	

random_int:
	li	a7, 41
	ecall	
	ret	

random_int_range:
	li	a7, 42
	ecall	
	ret	

	.eqv	KEYBOARD_0_BASE,0xffff0000
keyio_poll_key:
	li	a0, 0
	li	t0, KEYBOARD_0_BASE
	lb	a1, 0(t0)
	andi	a2, a1, 0x1
	beqz	a2, keyio_poll_key_return
	lb	a0, 4(t0)
	andi	a2, a1, 0xfffffffe
	sb	a2, 0(t0)
keyio_poll_key_return:
	ret	

memcpy:
	mv	a3, a0
memcpy_loop:
	beqz	a2, memcpy_return
	lbu	t0, 0(a1)
	sb	t0, 0(a3)
	addi	a3, a3, 1
	addi	a1, a1, 1
	addi	a2, a2, -1
	j	memcpy_loop
memcpy_return:
	ret	

memset:
	mv	t0, a0
memset_loop:
	beqz	a2, memset_return
	sb	a1, 0(t0)
	addi	t0, t0, 1
	addi	a2, a2, -1
	j	memset_loop
memset_return:
	ret	
