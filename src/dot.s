.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    add t1, x0, x0
    add s0, x0, x0 #s0: sum
    add s1, x0, x0 #s1: ind1
    add s2, x0, x0 #s2: ind2

loop_start:
    bge s1, a2, loop_end #if ind1 >= len, break
    bge s2, a2, loop_end #if ind2 >= len, brak

    addi t0, x0, 4 #t1 = a0[ind1]
    mul t0, t0, s1
    add t0, t0, a0
    lw t0, 0(t0)
    add t1, x0, t0

    addi t0, x0, 4 #sum += a1[ind2]*a0[ind1]
    mul t0, t0, s2
    add t0, t0, a0
    lw t0, 0(t0)
    mul t0, t0, t1
    add s0, s0, t0
    

    add s1, s1, a3 #ind1 += a3
    add s2, s2, a4 #ind2 += a4

    j loop_start

loop_end:
    add a0, s0, x0
    # Epilogue
    lw s2, 8(sp)
    lw s1, 8(sp)
    lw s0, 0(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret