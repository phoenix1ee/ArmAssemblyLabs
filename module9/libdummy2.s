#
# Program name: libConversions.s

# Author: Shun Fai Lee
# Date: X/XX/2025
# Purpose: This is a library of functions to be called by other program 
# Remarks: for assignmentX
#

.global double2

double2:
    # r0 = (r0/12)
    # r1 = r0 mod 12
    
    #push stack
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r0, [sp, #4]
    
    #double r1
    MOV r0, #2
    MUL r1, r0, r1

    LDR r0, [sp, #4]

    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #8
    MOV pc, lr
.data
#End double2
