.data
buffer:     .space 100
index:      .word 0
msg_flush:  .asciiz "\n[20 seg] Vaciando Buffer: "
newline:    .asciiz "\n"

.text
.globl main

main:
# Habilitar interrupciones del Teclado
li $t0, 0xFFFF0000
li $t1, 2
sw $t1, 0($t0)

# Habilitar interrupciones a nivel del Procesador
mfc0 $t0, $12
ori $t0,$t0, 1
mtc0 $t0, $12

# Iniciar temporizador
li $v0, 30
syscall
move $s0,$a0


loop_principal:
li $v0, 30
syscall
move $t1,$a0

sub $t2, $t1,$s0
li $t3, 20000

blt $t2,$t3, loop_principal

# Imprimir y vaciar buffer cada 20 segundos
la $a0, msg_flush
li $v0, 4
syscall

la $a0, buffer
li $v0, 4
syscall

la $t4, index
sw $zero, 0($t4)

la $t5, buffer
li $t6, 0


clean_loop:
beq $t6, 100, end_clean
add $t7, $t5,$t6
sb $zero, 0($t7)
addi $t6,$t6, 1
j clean_loop
end_clean:

li $v0, 30
syscall
move $s0,$a0
j loop_principal





.ktext 0x80000180
move $k0,$t0
move $k1,$t1

li $t0, 0xFFFF0004
lw $t1, 0($t0)

# Filtrar solo mayúsculas (A-Z)
li $t0, 65
blt $t1,$t0, fin_interrupcion
li $t0, 90
bgt $t1,$t0, fin_interrupcion

la $t0, index
lw $t2, 0($t0)

la $t0, buffer
add $t0, $t0,$t2
sb $t1, 0($t0)

addi $t2,$t2, 1
la $t0, index
sw $t2, 0($t0)


fin_interrupcion:
move $t0,$k0
move $t1,$k1
eret