.data
LuzControl:  .word 0
LuzEstado:   .word 0
LuzDatos:    .word 0

TensionControl: .word 0
TensionEstado:  .word 0
TensionSistol:  .word 0
TensionDiastol: .word 0

msg_luz:    .asciiz "Luminosidad leida: "
msg_sis:    .asciiz "\nTension Sistolica: "
msg_dia:    .asciiz "\nTension Diastolica: "


.text
.globl main

main:
# Simulación de respuesta de hardware para Ejercicio 1
la $t0, LuzEstado
li $t1, 1
sw $t1, 0($t0)
la $t0, LuzDatos
li $t1, 850
sw $t1, 0($t0)

jal InicializarSensorLuz
jal LeerLuminosidad

move $s0,$v0
la $a0, msg_luz
li $v0, 4
syscall
move $a0,$s0
li $v0, 1
syscall

# Simulación de respuesta de hardware para Ejercicio 2
la $t0, TensionEstado
li $t1, 1
sw $t1, 0($t0)
la $t0, TensionSistol
li $t1, 120
sw $t1, 0($t0)
la $t0, TensionDiastol
li $t1, 80
sw $t1, 0($t0)

jal controlador_tension

move $s0,$v0
move $s1,$v1

la $a0, msg_sis
li $v0, 4
syscall
move $a0,$s0
li $v0, 1
syscall

la $a0, msg_dia
li $v0, 4
syscall
move $a0,$s1
li $v0, 1
syscall

li $v0, 10
syscall


InicializarSensorLuz:
la $t0, LuzControl
li $t1, 1
sw $t1, 0($t0)

espera_luz:
la $t0, LuzEstado
lw $t1, 0($t0)
beq $t1,$zero, espera_luz
jr $ra

LeerLuminosidad:
la $t0, LuzEstado
lw $t1, 0($t0)
li $t2, -1
beq $t1,$t2, luz_error

la $t0, LuzDatos
lw $v0, 0($t0)
li $v1, 0
jr $ra


luz_error:
li $v0, 0
li $v1, 1
jr $ra

controlador_tension:
la $t0, TensionControl
li $t1, 1
sw $t1, 0($t0)

espera_tension:
la $t0, TensionEstado
lw $t1, 0($t0)
beq $t1,$zero, espera_tension

la $t0, TensionSistol
lw $v0, 0($t0)
la $t0, TensionDiastol
lw $v1, 0($t0)
jr $ra
