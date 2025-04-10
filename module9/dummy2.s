#
# Program name: .s

# Author: Shun Fai Lee
# Date: //2025
# Purpose: This program is to use and convert it to 
# Input:
#   - input: 
# Output:
#   - format: 
# Remarks: for assignment
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    #print the prompt to user
    
    LDR r0, =format1
    LDR r1, =num1
    BL scanf
    
    LDR r0, =num1
    LDR r0, [r0]
    
    BL alphacheck1B
    
    MOV r1, r0
    LDR r0, =output1

    BL printf

    #LDR r4, =num2
    #LDR r4, [r4]

    #MOV r1, #10
    #MUL r0, r1, r0 
    
    #MOV r1, #12
    #BL __aeabi_idiv

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "number?\n:"
    format1: .asciz "%d"
    num1: .word 1
    num2: .word 0
    output1: .asciz "%d\n"
    output2: .asciz "no.%d\n"
#End main
