.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


	# =====================================
    # LOAD MATRICES
    # =====================================
    #prologue
    addi sp, sp, -60
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw s2, 20(sp)
    sw ra, 24(sp)



    #malloc: a0 number of bytes needed
    #addi a0, x0, 32
    #malloc 
    #sw a0, 28(sp) #here are the six num (24 bytes) representing dimensions of three matrices, all stored in stack



    # Load pretrained m0
    lw a0, 4(a1) #a1: char**
    addi a1, sp, 28 #ptr to an integer, will be set to number of rows
    addi a2, sp, 32 #ptr to an integer, will be set to number of col
    jal read_matrix
    add s0, a0, x0 #s0 contains m0

    #for debugging==========
    #add s3 a1, x0
    #lw a1, 32(sp)
    #jal print_int
    #add a1, s3, x0
    #for debugging===========

    

    # Load pretrained m1
    lw a0, 4(sp) #loads original a1 val stored at 4(sp). is char**
    lw a0, 8(a0) #addr of m1
    addi a1, sp, 36 #addr of row number to be set
    addi a2, sp, 40 #addr of col number to be set
    jal read_matrix #commented for debug
    add s1, a0, x0 #s1 contains m1


    # Load input matrix
    lw a0, 4(sp) #loads a1
    lw a0, 12(a0) #loads addr of file location of inp
    addi a1, sp, 44 #addr of row num to be set
    addi a2, sp, 48 #addr of col num to be set
    jal read_matrix #commented for debug
    add s2, a0, x0 #s2 contains input



    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    #malloc mem for result, d
    lw t0, 28(sp) #number of row for d
    lw t1, 48(sp) #nuber of col for d
    mul a0, t0, t1
    addi t0, x0, 4
    mul a0, a0, t0 #size of result, d, in bytes
    
    jal malloc


    add a6, a0, x0 #a6 now contains ptr to newly allocated mem
    #above line is also filling in arg for matmul
    #fill in arguments for matmul
    add a0, s0, x0 #ptr to start of m0
    add a3, s2, x0 #ptr to start of inp
    lw a1, 28(sp) #m0 row
    lw a2, 32(sp) #m0 col
    lw a4, 44(sp) #inp row
    lw a5, 48(sp) #inp col
    add s0, a6, x0 #s0 now contains product of m0*input, d
    #don't pull above statement around! as s0 is vacant for addr of d only after filling in arguments
    jal matmul #a2 here is <= 0?

    #for debugging==========
    add s3 a1, x0

    add a0, x0, a6
    addi a1, x0, 3
    addi a2, x0, 1
    jal print_int_array

    add a1, s3, x0
    #for debugging===========

    #prepare arg for relu function
    add a0, s0, x0 #a0: ptr to array
    lw t0, 28(sp)#a1, number of elements in array
    lw t1, 48(sp)
    mul a1, t0, t1

    jal relu

    #ready to go for next multiplication!
    #malloc memory for second result first!
    lw t0, 36(sp) #this is number of rows for result of m1*(d)
    lw t1, 40(s0) #cols for result of m1*d
    addi a0, x0, 4
    mul a0, a0, t0 
    mul a0, a0, t1#a0 now contains size of m1*d in bytes

    jal malloc 
    add a6, a0, x0 #moves the returned ptr, a0, to a6

    #prepare for matmul
    add a0, s1, x0 #s1 contains m1
    add a3, s0, x0 #s0 contains d
    add s0, a6, x0 #s0 will contains the result of second matrix multiplication!
    lw a1, 28(sp)#row of first
    lw a2, 48(sp)#col of first
    lw a4, 36(sp)#row of second
    lw a5, 40(sp)#col of second

    jal matmul


    # =====================================
    # WRITE OUTPUT
    # now that addr of output matrix is in s0!
    # row number at sp + 36
    # col number at sp + 48
    # =====================================
    # Write output matrix
    
    #fill arguments
    #a0: ptr to filename
    lw a0 4(sp)
    lw a0, 12(a0)
    #a1: ptr to start of matrix in mem
    add a1, s0, x0
    #a2: number of rows in matrix
    lw a2, 36(sp)
    #a3: number of col in matrix
    lw a2, 48(sp)
    jal write_matrix



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    #a0: ptr to start of vector
    add a0, s0, x0
    #a1: number of elements in vector
    lw t0, 36(sp)
    lw t1, 48(sp)
    mul a1, t0, t1

    jal argmax #now a0 has the index of the largest element!



    # Print classification
    add a1, a0, x0
    jal print_int



    # Print newline afterwards for clarity
    addi a1, x0, '\n'
    jal print_char

    #epilogue
    lw s0, 12(sp)
    lw s1, 16(sp)
    lw s2, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 60



    ret