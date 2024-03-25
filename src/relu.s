.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================




relu:
    # Prologue
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw s3, 0(sp)

    add s0, a0, x0 #s0 = start, a1 = len
    add s1, x0, x0 #s1 = cnt


loop_start:
    beq s1, a1, loop_end# \if s0==a1, jump to end
    addi s3, x0, 4
    mul s2, s1, s3 #ind = 4 * cnt, s2 = ind
    
    add s2, s0, s2 #ind real addr calc
    lw s3, 0(s2) #s3 = array val at ind
    add a0, s3, x0 #argument of reluSIngle
    jal reluSingle
    sw a0, 0(s2)
    addi s1, s1, 1 #cnt = cnt + 1
    j loop_start

loop_continue:



loop_end:
    lw ra, 12(sp)
    lw s1, 8(sp)
    lw s2, 4(sp)
    lw s3, 0(sp)
    addi sp, sp, 16
    #jr ra
    # Epilogue
    
	ret

reluSingle:
    #takes a0, return max(a0, 1)
    bgt a0, x0, reluSingleEnd
    add a0, x0, x0
    jr ra
reluSingleEnd:
    add a0, x0, a0
    jr ra



