.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error
    li t0, 0                   #Setup the row index for a6(output)
    li t1, 0                   #Setup the col index for a6(output)
    li t2, 0                   #Setup general index for a6
    j outer_loop_start
    
error:
    li a0, 38
    j exit
    
    


    # Prologue


outer_loop_start:
    mul t4, a1, a2
    bge t0, t4, outer_loop_end
    
    




inner_loop_start:
    addi sp, sp, -44
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a6, 28(sp)
    sw t0, 32(sp)
    sw t1, 36(sp)
    sw t2, 40(sp)
    
    slli t2, t0, 2
    add a0, t2, a0
    slli t3, t1, 2
    add a1, t3, a3
    li a3, 1
    add a4, a5, x0
    
    jal dot
    
    lw ra, 0(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a6, 28(sp)
    lw t0, 32(sp)
    lw t1, 36(sp)
    lw t2, 40(sp)
    slli t3, t2, 2
    add t3, t3, a6
    sw a0, 0(t3)
    lw a0, 4(sp)
    addi sp, sp, 44
    addi t1, t1, 1
    addi t2, t2, 1
inner_loop_end:
    blt t1, a5, inner_loop_start
    li t1, 0
    add t0, t0, a2
    j outer_loop_start



outer_loop_end:


    # Epilogue


    jr ra
