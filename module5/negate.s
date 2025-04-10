#
# Program name: negate.s

# Author: Shun Fai Lee
# Date: 2/23/2025
# Purpose: This program is to use scanf to get user input of an integer and print out the negative value of it
# Input:
#   - input: User entered an integer
# Output:
#   - format: print the correspoding negative value
# Remarks: for assignment5 Q2
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input
    LDR r0, =format1
    LDR r1, =num1
    BL scanf

    #use 2 complement to negate the value 
    LDR r0, =num1
    LDR r0, [r0]
    MVN r0, r0
    ADD r0, r0, #1

    #print the output message
    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the integer?\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "The negative value is %d.\n"
#End main
