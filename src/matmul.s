.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0  #left matrix
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1 #right matrix
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    ble a1, x0, Error2
    ble a2, x0, Error2
    ble a4, x0, Error3
    ble a5, x0, Error3
    bne a2, a4, Error4


    # Prologue
    

    addi sp, sp, -32
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw s0, 20(sp)
    sw s1, 24(sp)
    sw ra, 28(sp)

    add s0, x0, x0 #row 1

outer_loop_start:

    beq s0, a1, outer_loop_end
    add s1, x0, x0
    
inner_loop_start:
    beq s1, a5, inner_loop_end
    #prepare 

    #fetch sth from dot.s
    #prepare arguments
    addi t0, x0, 4 #prepare a0
    mul t0, t0, s0
    mul t0, t0, a2
    add t0, t0, a0 #prepare a1
    addi t1, x0, 4
    mul t1, s1, t1
    add t1, t1, a3

    #plug in argument
    add a0, x0, t0
    add a1, x0, t1
    #a2 = a2, and therefore in dot.s, only the row is tracked
    #as we step through matrix
    
    addi a3, x0, 1
    add a4, x0, a5

    jal dot
    #get return val in t3
    add t2, a0, x0
    #restore a
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    #addi sp, sp, 20

    #store element in d
    mul t0, a5, s0 #t0: index for nth element in d
    add t0, t0, s1
    addi t1, x0, 4
    mul t0, t0, t1
    add t0, a6, t0
    sw t2, 0(t0)



    
    addi s1, s1, 1 #updates s1
    j inner_loop_start

inner_loop_end:


    addi s0, s0, 1
    j outer_loop_start

outer_loop_end:


    # Epilogue
    lw s0, 20(sp)
    lw s1, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 28

    
    
    ret


Error2: 
    addi a0, x0, 2
    jal exit
Error3:
    addi a0, x0, 3
    jal exit
Error4:
    addi a0, x0, 4
    jal exit

