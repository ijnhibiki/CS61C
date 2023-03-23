.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    #Call fopen
    li a1, 1
    jal fopen
    li t0, -1
    bne a0, t0, open_success
    li a0, 27
    lw ra, 0(sp)
    addi sp, sp, 16
    j exit
    
open_success:
    sw a0, 4(sp)             #Store file descriptor to stack
    li a0, 4
    jal malloc
    bne a0, x0, malloc_success_1
    lw ra, 0(sp)
    addi sp, sp, 16
    li a0, 26
    j exit
    
malloc_success_1:
    add a1, a0, x0
    lw t0, 12(sp)
    sw t0, 0(a1)
    lw a0, 4(sp)
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    beq a0, t0, write_row_success
    li a0, 30
    addi sp, sp, 20
    j exit
    
write_row_success:
    li a0, 4
    jal malloc
    bne a0, x0, malloc_success_2
    lw ra, 0(sp)
    addi sp, sp, 16
    li a0, 26
    j exit
    
malloc_success_2:
    
    add a1, a0, x0
    lw a0, 4(sp)
    lw t0, 16(sp)
    sw t0, 0(a1)
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    beq a0, t0, write_col_success
    li a0, 30
    addi sp, sp, 20
    j exit
    
write_col_success:
    lw a2, 12(sp)
    lw a3, 16(sp)
    mul a2, a2, a3
    sw a2, 12(sp)
    li a3, 4
    lw a0, 4(sp)
    lw a1, 8(sp)
    jal fwrite
    lw a2, 12(sp)
    beq a0, a2, write_matrix_success
    li a0, 30
    addi sp, sp, 20
    j exit

write_matrix_success:
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
    addi sp, sp, 20


    jr ra
