.import ../src/utils.s
.import ../src/relu.s

.data
.align 4
m0: .word -23221 -2672726 378373 28928 -1 -3 78 1234567 2147483641 -2147483641
.align 4
m1: .word 0 0 378373 28928 0 0 78 1234567 2147483641 0
msg0: .asciiz "Expected m0 to be:\n0 0 378373 28928 0 0 78 1234567 2147483641 0\nInstead it is:\n"

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load 10 into a1
    li a1 10

    # call relu function
    jal ra relu

    ##################################
    # check that m0 == [0, 0, 378373, 28928, 0, 0, 78, 1234567, 2147483641, 0]
    ##################################
    # a0: exit code
    li a0, 2
    # a1: expected data
    la a1, m1
    # a2: actual data
    la a2, m0
    # a3: length
    li a3, 10
    # a4: error message
    la a4, msg0
    jal compare_int_array

    # exit normally
    li a0 0
    jal exit
