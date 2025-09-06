# Archivo: LopezJesus_Fibonacci.asm
# Propósito: Pedir K (cantidad de términos) y mostrar la serie desde 0,1,...
#            Además, imprimir la suma total de los K términos.
# Ensamblador destino: MARS/QtSPIM (MIPS32)
# Autor: Lopez, Jesus

# ========================
# Sección de datos
# ========================
.data
msgBienv: .asciiz "\n== Serie Fibonacci ==\n"                    # Mensaje de bienvenida
msgPedK:  .asciiz "\n¿Cuantos terminos de Fibonacci desea generar? " # Pregunta cantidad
msgErrK:  .asciiz "Valor invalido. Debe ser un entero >= 1. Intente de nuevo.\n"
msgSerie: .asciiz "\nSerie: "                                    # Encabezado de serie
msgComa:  .asciiz ", "                                           # Separador visual
msgSuma:  .asciiz "\nSuma total: "                               # Encabezado de suma
msgFin:   .asciiz "\nGracias por usar el programa.\n"            # Mensaje de despedida

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

# ========================
# Leer K válido (K >= 1)
# ========================
leer_K:
    li $v0, 4
    la $a0, msgPedK
    syscall

    li $v0, 5
    syscall
    move $t0, $v0       # $t0 = cantidad de términos

    blez $t0, errK      # Si K <= 0, error
    b generar           # K válido, continuar

errK:
    li $v0, 4
    la $a0, msgErrK
    syscall
    b leer_K

# ========================================
# Generar e imprimir la serie y la suma
# ========================================
generar:
    li $t1, 0           # $t1 = a = 0
    li $t2, 1           # $t2 = b = 1
    li $t3, 0           # $t3 = i = 0
    move $t4, $zero     # $t4 = suma = 0

    li $v0, 4
    la $a0, msgSerie
    syscall

loop_fib:
    beq $t3, $t0, fin_fib   # Si i == K, terminar ciclo

    li $v0, 1
    move $a0, $t1           # Imprimir término actual
    syscall

    addu $t4, $t4, $t1      # suma += a

    addi $t5, $t3, 1
    blt $t5, $t0, imprime_coma
    b avanza

imprime_coma:
    li $v0, 4
    la $a0, msgComa
    syscall

avanza:
    addu $t6, $t1, $t2      # t6 = a + b
    move $t1, $t2           # a = b
    move $t2, $t6           # b = a + b
    addi $t3, $t3, 1        # i++
    b loop_fib

# ========================
# Mostrar suma total
# ========================
fin_fib:
    li $v0, 4
    la $a0, msgSuma
    syscall

    li $v0, 1
    move $a0, $t4           # Mostrar suma
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