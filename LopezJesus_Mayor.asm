# Archivo: LopezJesus_Mayor.asm
# Propósito: Pedir N (3..5) enteros y mostrar el mayor.
# Ensamblador destino: MARS/QtSPIM (MIPS32)
# Autor: Lopez, Jesus

# ========================
# Sección de datos
# ========================
.data
msgBienv: .asciiz "\n== Numero mayor (3 a 5) ==\n"               # Mensaje de bienvenida
msgPedN: .asciiz "\n¿Cuantos numeros desea comparar (3-5)? "     # Pregunta cantidad de números
msgErrN: .asciiz "Valor invalido. Debe ser 3, 4 o 5. Intente de nuevo.\n" # Mensaje de error
msgIng:  .asciiz "Ingrese un numero: "                           # Solicita número
msgRes:  .asciiz "\nEl mayor es: "                               # Muestra resultado
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
    li $v0, 4                       # Servicio: imprimir cadena
    la $a0, msgBienv                # Dirección del mensaje
    syscall                         # Mostrar mensaje

# ========================
# Leer N válido entre 3 y 5
# ========================
leer_N:
    li $v0, 4                       # Servicio: imprimir cadena
    la $a0, msgPedN                 # Dirección del mensaje
    syscall                         # Mostrar pregunta

    li $v0, 5                       # Servicio: leer entero
    syscall                         # Leer valor ingresado
    move $t0, $v0                   # $t0 = cantidad de números a comparar (N)

    blt $t0, 3, errN                # Si N < 3, ir a error
    bgt $t0, 5, errN                # Si N > 5, ir a error
    b leer_datos                    # N válido, continuar

errN:
    li $v0, 4                       # Servicio: imprimir cadena
    la $a0, msgErrN                 # Dirección del mensaje de error
    syscall                         # Mostrar error
    b leer_N                        # Reintentar lectura

# ========================
# Leer N números y calcular el mayor
# ========================
leer_datos:
    move $t1, $zero                 # $t1 = contador i = 0
    li $t2, -2147483648             # $t2 = mayor = INT_MIN (-2^31)

loop_lectura:
    beq $t1, $t0, fin_lectura       # Si i == N, terminar ciclo

    li $v0, 4                       # Servicio: imprimir cadena
    la $a0, msgIng                  # Dirección del mensaje "Ingrese un número"
    syscall                         # Mostrar mensaje

    li $v0, 5                       # Servicio: leer entero
    syscall                         # Leer número
    move $t3, $v0                   # $t3 = número actual ingresado

    # Comparar con el mayor actual
    ble $t3, $t2, no_actualiza      # Si número <= mayor, no actualizar
    move $t2, $t3                   # Actualizar mayor

no_actualiza:
    addi $t1, $t1, 1                # i++
    b loop_lectura                  # Repetir ciclo

# ========================
# Mostrar resultado final
# ========================
fin_lectura:
    li $v0, 4                       # Servicio: imprimir cadena
    la $a0, msgRes                  # Dirección del mensaje "El mayor es:"
    syscall                         # Mostrar mensaje

    li $v0, 1                       # Servicio: imprimir entero
    move $a0, $t2                   # Cargar valor del mayor
    syscall                         # Mostrar número

    # ------------------------
    # Mensaje de despedida
    # ------------------------
    li $v0, 4                       # Servicio: imprimir cadena
    la $a0, msgFin                  # Dirección del mensaje final
    syscall                         # Mostrar mensaje

    # ------------------------
    # Finalizar programa
    # ------------------------
    li $v0, 10                      # Servicio: salir
    syscall                         # Terminar ejecución