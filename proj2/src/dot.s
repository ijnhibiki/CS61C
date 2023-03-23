.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0, 1              # Setup 1 to compare 
    li t1, 0              # Index of arr0
    li t2, 0              # Index of arr1
    li t3, 0              # Product result
    li t5, 0              # Number of elements counter
    bge a2, t0, check_2
    li a0, 36
    j exit
check_2:
    bge a3, t0, check_3
    li a0, 37
    j exit
check_3:
    bge a4, t0, loop_continue
    li a0, 37
    j exit

    # Prologue


loop_start:
    slli t0, t1, 2
    add t0, t0, a0
    lw t0, 0(t0)
    slli t4, t2, 2
    add t4, t4, a1
    lw t4, 0(t4)
    mul t0, t0, t4
    add t3, t3, t0
    add t1, t1, a3
    add t2, t2, a4
    addi t5, t5, 1
loop_continue:
    blt t5, a2, loop_start
    j loop_end




loop_end:
    add a0, t3, x0

    # Epilogue


    jr ra
