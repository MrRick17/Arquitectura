.text
.globl main

main:
    li $a0, 5           # Número de prueba (n = 5)
    jal paridad_iter    # Llamada a la función
    
    move $a0, $v0
    li $v0, 1
    syscall
    
    li $v0, 10
    syscall

# Función Iterativa
paridad_iter:
    li $v0, 0           # Inicializar resultado en 0
    move $t0, $a0       # Copiar n a $t0 como contador

loop:
    beq $t0, $zero, fin_iter  # Si contador == 0, salir
    li $t1, 1
    sub $v0, $t1, $v0   # resultado = 1 - resultado
    addi $t0, $t0, -1   # contador--
    j loop

fin_iter:
    jr $ra