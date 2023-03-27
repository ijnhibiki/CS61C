andi t0, s0, 2047
andi t0, s0, -2048
ori  t0, s0, 2047
ori  t0, s0, -2048
xori t0, s0, 2047
xori t0, s0, -2048

slli t0, s0, 30
slli t0, s0, 31
srai t0, s0, 30
srai t0, s0, 31
srli t0, s0, 30
srli t0, s0, 31

slti t0, s0, 2047
slti t0, s0, -2048

add t0, s0, x0
add t0, x0, t0
mul t1, s0, t0
sub t1, s0, x0
mulh t1, s0, t0
mulhu t1, s0, t0
xor t1, s0, x0
and t1, s0, x0
lui t0, 0x7ff
lui t1, 23

mul t1, s0, t0
sll t1, s0, t0
mulh t1, s0, t0
mulhu t1, s0, t0
srl t1, s0, t0
or t1, s0, t0
and t1, s0, t0

add t1, s0, t0
auipc t0, 0x7ff
slli t1, s0, 1
slti t1, s0, 23
srli t1, s0, 4
ori t1, s0, 0x7ff
andi t1, s0, 0x7ff


# Test program for branch and jump pipeline

# initialize variables
addi x1, x0, 0  # x1 = 0
addi x2, x0, 1  # x2 = 1

# loop 10 times
addi x3, x0, 0
loop:
  beq x3, x2, end  # branch to end if x3 == x2
  addi x1, x1, 1   # increment x1
  addi x3, x3, 1   # increment loop counter
  j loop           # jump back to loop

# end of program
end:
  addi x0, x0, 0   # do nothing (no-op)

# Comprehensive test program for CPU instruction set

# initialize variables
addi x1, x0, 0  # x1 = 0
addi x2, x0, 1  # x2 = 1
addi x3, x0, 2  # x3 = 2

# arithmetic instructions
add x4, x1, x2   # x4 = x1 + x2
sub x5, x4, x1   # x5 = x4 - x1
sll x6, x2, 2    # x6 = x2 << 2
srl x7, x3, 1    # x7 = x3 >> 1
and x8, x1, x2   # x8 = x1 & x2
or x9, x1, x3    # x9 = x1 | x3
xor x10, x2, x3  # x10 = x2 ^ x3

# load and store instructions
sw x1, 0(x2)    # store x1 at address x2+0
lw x11, 0(x2)   # load from address x2+0 into x11
sh x2, 2(x3)    # store 16-bit value of x2 at address x3+2
lh x12, 2(x3)   # load 16-bit value from address x3+2 into x12
sb x3, 4(x2)    # store 8-bit value of x3 at address x2+4
lb x13, 4(x2)   # load 8-bit value from address x2+4 into x13

# branch and jump instructions
beq x1, x2, label1  # branch to label1 if x1 == x2
bne x2, x3, label2  # branch to label2 if x2 != x3
j label3            # jump to label3
jal label4          # jump and link to label4
jr x4               # jump to the address in x4
jalr x5             # jump and link to the address in x5

# label definitions
label1:
  addi x1, x1, 1     # increment x1
  j label3           # jump to label3
label2:
  addi x2, x2, 2     # increment x2
  jal label4         # jump and link to label4
label3:
  addi x3, x3, 3     # increment x3
  jalr x6            # jump and link to the address in x6
label4:
  addi x4, x4, 4     # increment x4
  jr x7              # jump to the address in x7
