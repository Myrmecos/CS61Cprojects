.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "/Users/entomophile/CS/CS61Cprojects/proj2/CS61Cprojects/tests/inputs/simple0/bin/m0.bin"
vector0: .word 0 0

.text
main:
    #load addresses into reg
    la s0 file_path
    la s1 vector0
    # Read matrix into memory
    add a0, s0, x0
    add a1, s1, x0
    addi a2, s1, 4
    jal read_matrix

    # Print out elements of matrix
    lw a1, 0(s1)
    lw a2, 4(s1)
    jal print_int_array



    # Terminate the program
    jal exit