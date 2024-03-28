.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
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
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw s0, 16(sp)
    sw s1, 20(sp)
    sw ra, 24(sp)

    #calc matrix size 
    mul s1, a2, a3


    #open the file in write mode
    addi a2, x0, 1
    add a1, a0, x0
    jal fopen
    add s0, a0, x0 #s0 stores descriptor

    #write number a1, a2
    add a1, s0, x0
    addi a2, sp, 8 #ptr to buffer containing what to write
    addi a3, x0, 2 #number of elements to write
    addi a4, x0, 4 #size of each buffer element in bytes
    jal fwrite

    #write matrix into file
    
    add a1, s0, x0
    lw a2, 4(sp)
    add a3, s1, x0
    addi a4, x0, 4
    jal fwrite

    
    #close the file
    add a1, s0, x0
    jal fflush
    

    # Epilogue
    lw s0, 16(sp)
    lw s1, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret
