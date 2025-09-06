# Archivo: LopezJesus_Menor.asm
# Propósito: Pedir N (3..5) enteros y mostrar el menor.
# Ensamblador destino: MARS/QtSPIM (MIPS32)
# Autor: Lopez, Jesus

# ========================
# Sección de datos
# ========================
.data
msgBienv: .asciiz "\n== Numero menor (3 a 5) ==\n"               # Mensaje de bienvenida
msgPedN: .asciiz "\n¿Cuantos numeros desea comparar (3-5)? "     # Pregunta cantidad de números
msgErrN: .asciiz "Valor invalido. Debe ser 3, 4 o 5. Intente de nuevo.\n" # Mensaje de error
msgIng:  .asciiz "Ingrese un numero: "                           # Solicita número
msgRes:  .asciiz "\nEl menor es: "                               # Muestra resultado
msgFin:  .asciiz "\nGracias por usar el programa.\n"             # Mensaje de despedida

# ========================
# Sección de código
# ========================
.text
.globl main

main:
    # ------------------------
    # Mostrar mensaje de bienvenida
    # ------------------------
    li $v0, 4
    la $a0, msgBienv
    syscall

# ================================
# Leer N válido entre 3 y 5
# ================================
leer_N:
    li $v0, 4
    la $a0, msgPedN
    syscall

    li $v0, 5
    syscall
    move $t0, $v0       # $t0 = cantidad de números a comparar

    blt $t0, 3, errN    # Si N < 3, error
    bgt $t0, 5, errN    # Si N > 5, error
    b leer_datos        # N válido, continuar

errN:
    li $v0, 4
    la $a0, msgErrN
    syscall
    b leer_N            # Reintentar lectura

# ========================================
# Leer N números y calcular el menor
# ========================================
leer_datos:
    move $t1, $zero     # $t1 = contador i = 0
    li $t2, 2147483647  # $t2 = menor = INT_MAX

loop_lectura:
    beq $t1, $t0, fin_lectura   # Si i == N, terminar ciclo

    li $v0, 4
    la $a0, msgIng
    syscall

    li $v0, 5
    syscall
    move $t3, $v0       # $t3 = número ingresado

    bge $t3, $t2, no_actualiza  # Si número >= menor, no actualizar
    move $t2, $t3               # Actualizar menor

no_actualiza:
    addi $t1, $t1, 1            # i++
    b loop_lectura              # Repetir ciclo

# ========================
# Mostrar resultado final
# ========================
fin_lectura:
    li $v0, 4
    la $a0, msgRes
    syscall

    li $v0, 1
    move $a0, $t2               # Mostrar menor
    syscall

    # ------------------------
    # Mensaje de despedida
    # ------------------------
    li $v0, 4
    la $a0, msgFin
    syscall

    # ------------------------
    # Finalizar programa
    # ------------------------
    li $v0, 10
    syscall
