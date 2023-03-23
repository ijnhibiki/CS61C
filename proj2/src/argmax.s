.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    li t0, 1
    li t1, 0
    li t4, 0
    bge a1, t0, loop_continue
    li a0, 36
    j exit


loop_start:
    slli t2, t1, 2
    add t2, t2, a0
    lw t3, 0(t2)
    slli t2, t4, 2
    add t2, t2, a0
    lw t2, 0(t2)
    bge t2, t3, else
    add t4, t1, x0
else:
    addi, t1, t1, 1

loop_continue:
    blt t1, a1, loop_start


loop_end:
    # Epilogue
    add a0, t4, x0

    jr ra
