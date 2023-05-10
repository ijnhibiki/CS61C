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
    addi sp, sp, -20                 # Allocate stack
    sw ra, 0(sp)                     # Store return address to stack
    sw a0, 4(sp)                     # Store arguments to stack
    sw a1, 8(sp)                     # Store arguments to stack
    sw a2, 12(sp)                    # Store arguments to stack
    sw a3, 16(sp)                    # Store arguments to stack
    #Call fopen
    li a1, 1                         # Store 1 to a1
    jal fopen                        # Call fopen function
    li t0, -1                        # Store -1 to t0
    bne a0, t0, open_success         # Check if fopen is successful, if so, jump to open_success
    li a0, 27                        # Store error code to a0
    lw ra, 0(sp)                     # Load return address to ra
    addi sp, sp, 16                  # Deallocate stack
    j exit                           # Jump to exit to terminate program
    
open_success:
    sw a0, 4(sp)                     # Store file descriptor to stack
    li a0, 4                         # Store 4 to a0
    jal malloc                       # Call malloc function
    bne a0, x0, malloc_success_1     # Check if malloc is successful, if so, jump to malloc_success_1
    lw ra, 0(sp)                     # If malloc is not successful, load return address to ra
    addi sp, sp, 16                  # Deallocate stack
    li a0, 26                        # Store error code to a0
    j exit                           # Jump to exit to terminate program
    
malloc_success_1:
    add a1, a0, x0                   # Store the address of the allocated memory to a1
    lw t0, 12(sp)                    # Load the number of rows from stack 
    sw t0, 0(a1)                     # Store the number of rows to stack
    lw a0, 4(sp)                     # Load file descriptor from stack
    li a2, 1                         # Store 1 to a2 as inital value
    li a3, 4                         # Store 4 to a3 as inital value
    jal fwrite                       # Call fwrite function
    li t0, 1                         # Store 1 to t0
    beq a0, t0, write_row_success    # Check if fwrite is successful, if so, jump to write_row_success
    li a0, 30                        # Store error code to a0
    addi sp, sp, 20                  # Deallocate stack
    j exit                           # Jump to exit to terminate program
    
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
