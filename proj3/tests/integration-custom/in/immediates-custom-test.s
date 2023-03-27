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