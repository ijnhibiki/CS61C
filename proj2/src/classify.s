.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0, 5
    beq a0, t0, correct_num_args
    li a0, 31
    j exit
correct_num_args:
    addi sp, sp, -68
    sw a1, 40(sp)                    #Store a pointer to an array of argument strings
    addi t0, a1, 4
    lw t0, 0(t0)
    sw t0, 44(sp)                    #Store A pointer to the filepath string of the first matrix file m0
    
    addi t0, a1, 8
    lw t0, 0(t0)
    sw t0, 48(sp)                    #Store A pointer to the filepath string of the second matrix file m1.
    
    addi t0, a1, 12
    lw t0, 0(t0)
    sw t0, 52(sp)                   #Store A pointer to the filepath string of the input matrix file input.
    
    addi t0, a1, 16
    lw t0, 0(t0)
    sw t0, 56(sp)                   #Store A pointer to the filepath string of the output file.
    sw a2, 60(sp)                   #If set to 0, print out the classification. Otherwise, do not print anything.
    sw ra, 64(sp)                   #Store return address
    
    #Allocate space for A pointer to an integer which will contain the number of rows
    li a0, 4
    jal malloc
    bne a0, x0, malloc_success_row
    addi sp, sp, 68
    li a0, 26
    j exit
    
malloc_success_row:
    sw a0, 36(sp)
    li a0, 4
    jal malloc
    bne a0, x0, malloc_success_col
    addi sp, sp, 68
    li a0, 26
    j exit
malloc_success_col:
    sw a0, 32(sp)
    
    # Read pretrained m0
    lw a0, 44(sp)
    lw a1, 36(sp)
    lw a2, 32(sp)
    jal read_matrix
    lw t0, 36(sp)
    lw t0, 0(t0)
    lw t1, 32(sp)
    lw t1, 0(t1)
    sw t0, 28(sp)
    sw t1, 24(sp)
    sw a0, 44(sp)                 #Store matrix m0 to m0 in stack


    # Read pretrained m1
    lw a0, 48(sp)
    lw a1, 36(sp)
    lw a2, 32(sp)
    jal read_matrix
    lw t0, 36(sp)
    lw t0, 0(t0)
    lw t1, 32(sp)
    lw t1, 0(t1)
    sw t0, 20(sp)
    sw t1, 16(sp)
    sw a0, 48(sp)                #Store matrix m1 to m1 in stack

    # Read input matrix
    lw a0, 52(sp)
    lw a1, 36(sp)
    lw a2, 32(sp)
    jal read_matrix
    lw t0, 36(sp)
    lw t0, 0(t0)
    lw t1, 32(sp)
    lw t1, 0(t1)
    sw t0, 12(sp)
    sw t1, 8(sp)
    sw a0, 52(sp)                #Store matrix input to input in stack


    # Compute h = matmul(m0, input)
    lw t0, 28(sp)
    lw t1, 8(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    bne a0, x0, malloc_success_matrix_h
    addi sp, sp, 68
    li a0, 26
    j exit
malloc_success_matrix_h:
    sw a0, 4(sp)
    add a6, a0, x0
    lw a0, 44(sp)
    lw a1, 28(sp)
    lw a2, 24(sp)
    lw a3, 52(sp)
    lw a4, 12(sp)
    lw a5, 8(sp)
    jal matmul
    
    # Compute h = relu(h)
    lw a0, 4(sp)
    lw t0, 28(sp)
    lw t1, 8(sp)
    mul a1, t0, t1
    jal relu
    
    # Compute o = matmul(m1, h)
    lw t0, 20(sp)
    lw t1, 8(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    bne a0, x0, malloc_success_matrix_o
    addi sp, sp, 68
    li a0, 26
    j exit
malloc_success_matrix_o:
    sw a0, 0(sp)
    add a6, a0, x0
    lw a0, 48(sp)
    lw a1, 20(sp)
    lw a2, 16(sp)
    lw a3, 4(sp)
    lw a4, 28(sp)
    lw a5, 8(sp)
    jal matmul
    
    


    # Write output matrix o
    lw a0, 56(sp)
    lw a1, 0(sp)
    lw a2, 20(sp)
    lw a3, 8(sp)
    jal write_matrix
    

    # Compute and return argmax(o)
    lw a0, 0(sp)
    lw t0, 20(sp)
    lw t1, 8(sp)
    mul a1, t0, t1
    jal argmax
    


    # If enabled, print argmax(o) and newline
    sw a0, 40(sp)
    
    lw t0, 60(sp)
    bne t0, x0, done
    jal print_int
    li a0 '\n'
    jal print_char
    

done:
    lw a0, 0(sp)
    jal free
    lw a0, 4(sp)
    jal free
    lw a0, 32(sp)
    jal free
    lw a0, 36(sp)
    jal free
    lw a0, 44(sp)
    jal free
    lw a0, 48(sp)
    jal free
    lw a0, 52(sp)
    jal free
    lw a0, 40(sp)
    lw ra, 64(sp)
    addi sp, sp, 68

    jr ra
