.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 20(sp)
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)

    #prepare arg for fopen
    add a1, a0, x0
    add a2, x0, x0
    jal fopen 
    add s0, a0, x0 #s0: file descriptor
    #arg: a1: ptr to string with filename; 
    #a2: int to permission. 0: read only
    #ret: a0: file descrip

    #get row, col size of a mat, store size of matrix in bytes into s1
    addi a0, x0, 8
    jal malloc

    #read
    add a1, s0, x0
    add a2, a0, x0
    addi a3, x0, 8
    jal fread

    #get val
    lw t0, 0(a2) #row num
    lw t2, 4(sp)
    sw t0, 0(t2) #store row number in the reference at a1
    lw t1, 4(a2) #col num
    lw t2, 0(sp)
    sw t1, 0(t2) #store col number in reference at a2

    #calc array size in bytes
    addi s1, x0, 4
    mul s1, s1, t0
    mul s1, s1, t1 #size of array
    add a0, x0, s1
    jal malloc
    
    #malloc arg: a0, number of bytes; 
    #ret: a0, ptr

    #set arguments for fread of whole array
    add a2, a0, x0 #strict link with above malloc
    add a1, s0, x0
    add a3, s1, x0
    add s1, a0, x0
    jal fread
    #check fread error

    #load return
    add a0, s1, x0

    # Epilogue
    lw ra, 20(sp)
    lw s0, 12(sp)
    lw s1, 16(sp)
    addi sp, sp, 24

    ret