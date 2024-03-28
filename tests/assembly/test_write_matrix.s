.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 # MAKE CHANGES HERE TO TEST DIFFERENT MATRICES
file_path: .asciiz "/Users/entomophile/CS/CS61Cprojects/proj2/CS61Cprojects/tests/outputs/test_write_matrix/myOp.bin"

.text
main:
    # Write the matrix to a file
    #load addresses
    la s0, m0
    la s1, file_path
    add a0, s1, x0
    add a1, s0, x0
    addi a2, x0, 4
    addi a3, x0, 3
    jal write_matrix



    # Exit the program
    jal exit
