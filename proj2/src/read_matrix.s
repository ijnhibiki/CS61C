.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    # Setup stack
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    #Call fopen
    li a1, 0
    jal fopen
    li t0, -1
    bne a0, t0, open_success
    li a0, 27
    lw ra, 0(sp)
    addi sp, sp, 16
    j exit
    
open_success:
    lw a1, 8(sp)
    sw a0, 4(sp)
    li a2, 4
    jal fread
    li t0, 4
    beq a0, t0, read_row_success
    lw ra, 0(sp)
    addi sp, sp, 16
    li a0, 29
    j exit
    
read_row_success:
    lw a2, 12(sp)
    add a1, a2, x0
    lw a0, 4(sp)
    li a2, 4
    jal fread
    li t0, 4
    beq a0, t0, read_col_success
    lw ra, 0(sp)
    li a0, 29
    addi sp, sp, 16
    j exit
    
read_col_success:
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw t0, 0(a1)
    lw t1, 0(a2)
    mul a0, t0, t1
    slli a0, a0, 4
    jal malloc
    bne a0, x0, malloc_success
    lw ra, 0(sp)
    addi sp, sp, 16
    li a0, 26
    j exit
    
malloc_success:
    add a1, a0, x0                    #Setup the a1 to be allocated buffer
    lw a0, 4(sp)                      #Setup a0 to be file descriptor 
    lw t0, 8(sp)
    lw t0, 0(t0)
    lw t1, 12(sp)
    lw t1, 0(t1)
    mul a2, t0, t1
    slli a2, a2, 2
    addi sp, sp, -8
    sw a2, 0(sp)                      #Store number of bits
    sw a1, 4(sp)                      #Strore buffer address
    jal fread
    lw t1, 0(sp)
    beq a0, t1, read_matrix_success
    lw ra, 0(sp)
    addi sp, sp, 16
    li a0, 29
    j exit
    
read_matrix_success:
    lw a1, 4(sp)
    addi sp, sp, 8
    sw a1, 8(sp)
    lw a0, 4(sp)
    jal fclose
    beq a0, x0, close_success
    lw ra, 0(sp)
    addi sp, sp, 16
    li a0, 28
    j exit
    
close_success:

    # Epilogue
    lw ra, 0(sp)
    lw a0, 8(sp)
    addi sp, sp, 16


    jr ra
