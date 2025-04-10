#
# Program name: alpha.s

# Author: Shun Fai Lee
# Date: 3/29/2025
# Purpose: This program is a driver program to call and use a function to check whether user input is an alphabet or not
# Input:
#   - input: any ascii character
# Output:
#   - format: printed to terminal "yes" or "no"
# Remarks: for assignment9 question 1
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan the input
    LDR r0, =format1
    LDR r1, =char
    BL scanf
    
    #LDR r0, =output1
    #LDR r1, =char
    #LDRB r1, [r1]
    #BL printf

    #load input to r0
    LDR r0, =char
    LDRB r0, [r0]
    
    #call function "alphacheck" to check r0
    BL alphacheck1A   

    #check if returned value at r0 is 0 or 1
    MOV r1, #0
    CMP r0, r1
    BEQ incorrect
    
    #if input is alphabet
    LDR r0, =output1
    LDR r1, =char
    LDR r1, [r1]
    BL printf
    B end
    
    #if input is not alphabet
    incorrect:
    LDR r0, =output2
    LDR r1, =char
    LDR r1, [r1]
    BL printf
    B end

    end:

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "Please input a character\n:"
    format1: .asciz "%c"
    char: .byte 0
    output1: .asciz "input %c is an alphabet.\n"
    output2: .asciz "input %c is not an alphabet.\n"
#End main
