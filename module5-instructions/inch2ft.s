#
# Program name: inch2ft.s

# Author: S.Lee
# Date: 2/23/2025
# Purpose: This program is to use scanf to get user input of a number of inch as integer and calculate and print out in feet and inch
# Input:
#   - input: User entered number
# Output:
#   - format: print the correspoding feet and inch message
#

.global main
main:
    SUB sp, sp, #12
    STR lr, [sp]
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input
    LDR r0, = format1
    LDR r1, = num1
    BL scanf

    #calculate the number of feet
    LDR r4, =num1
    LDR r4, [r4]
    MOV r0, r4
    MOV r1, #12
    BL __aeabi_idiv

    #calculate the number of inch remains
    MUL r2,r1,r0
    SUB r2, r4, r2

    #print the output message
    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #12
    MOV pc, lr
.data
    prompt1: .asciz "What is the total inch?\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "It is %d feet and %d inches.\n"
#End main
