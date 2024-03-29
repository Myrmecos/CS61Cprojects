.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)

    add s0, x0, x0 #largest val ind: s0
    lw s1, 0(a0) #larges val: s1
    add t0, x0, x0 #ind: t0

loop_start:
    beq t0, a1, loop_end #if t0 == len, end
    addi t1, x0, 4 #t1 = 4*t0+a0, means t1 = a0[ind]
    mul t1, t0, t1
    add t1, a0, t1
    lw t1, 0(t1)
    addi t0, t0, 1 #t0 += 1
    ble t1, s1, loop_start #if t1 > s1: (else, jump back)
    #update largest ind and val
    add s0, t0, x0
    add s1, t1, x0
    j loop_start

loop_continue:

loop_end:
    add a0, s0, x0 #remember to place back output!!!!
    addi a0, a0, -1
    # Epilogue
    lw s1, 0(sp)
    lw s0, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12


    ret