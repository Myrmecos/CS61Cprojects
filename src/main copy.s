.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s
.import classify.s

.data
m0: .word 0, 0, 0, 0, 0
M0_PATH: .asciiz "/Users/entomophile/CS/CS61Cprojects/proj2/CS61Cprojects/tests/inputs/simple0/bin/m0.bin"
M1_PATH: .asciiz "/Users/entomophile/CS/CS61Cprojects/proj2/CS61Cprojects/tests/inputs/simple0/bin/m1.bin"
INPUT_PATH: .asciiz "/Users/entomophile/CS/CS61Cprojects/proj2/CS61Cprojects/tests/inputs/simple0/bin/inputs/input0.bin"
OUTPUT_PATH: .asciiz "/Users/entomophile/CS/CS61Cprojects/proj2/CS61Cprojects/tests/outputs/test_basic_main/student_basic_outputs.bin"



.text
.globl main

# This is a dummy main function which imports and calls the classify function.
# While it just exits right after, it could always call classify again.
main:
    la s0, m0
    la t0, M0_PATH
    sw t0, 4(s0)
    la t0, M1_PATH
    sw t0, 8(s0)
    la t0, INPUT_PATH
    sw t0, 12(s0)
    la t0, OUTPUT_PATH
    sw t0 16(s0)
    addi a0, x0, 0 #what is this
    add a1, s0, x0
    add a2, x0, x0

    jal classify
    jal exit
