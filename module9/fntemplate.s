#
# Program name: fntemplate.s

# Author: Shun Fai Lee
# Date: X/XX/2025
# Purpose: This is a library of functions to be called by other program 
# Remarks: for assignmentX
#
# Store r4-r7 to stack and restore before exit.
# allow using r0-r7 for any function implementation

.global template

template:
    # 
    
    #push stack
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    
    #function core


    #pop stack
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR lr, [sp, #0]
    ADD sp, sp, #20
    MOV pc, lr
.data
#End template
