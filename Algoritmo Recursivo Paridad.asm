.text
.globl main

main:
    li $a0, 4           # Número de prueba (n = 4)
    jal paridad_rec     # Llamada a la función
    
    move $a0, $v0       # Mover resultado para imprimir
    li $v0, 1
    syscall
    
    li $v0, 10          # Terminar programa
    syscall

# Función Recursiva
paridad_rec:
    # Prólogo: Guardar contexto
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp)

    # Caso Base: si n == 0, retornar 0
    bne $a0, $zero, paso_recursivo
    li $v0, 0
    j fin_rec

paso_recursivo:
    addi $a0, $a0, -1   # n - 1
    jal paridad_rec     # paridad(n-1)
    
    # Operación: 1 - paridad(n-1)
    li $t0, 1
    sub $v0, $t0, $v0   # $v0 = 1 - resultado_anterior

fin_rec:
    # Epílogo: Restaurar contexto
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra