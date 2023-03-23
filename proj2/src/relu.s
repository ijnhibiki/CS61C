.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    li t1, 0
    bge a1, t0, loop_continue
    li a0 36
    j exit


loop_start:
    slli t2, t1, 2
    add t2, t2, a0
    lw t3, 0(t2)
    bge t3, x0, else
    li t3, 0
else:
    sw t3, 0(t2)
    addi t1, t1, 1
loop_continue:
    blt t1, a1, loop_start



loop_end:


    # Epilogue


    jr ra
