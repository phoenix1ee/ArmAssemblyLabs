#
# Program name: ft2inch.s

# Author: S.Lee
# Date: 2/23/2025
# Purpose: This program is to use scanf to get user input of two number, 1 of feet and 1 of inch as integer and calculate and print out in inch
# Input:
#   - input: User entered two number, one at a time
# Output:
#   - format: print the correspoding total inch message
#

.global main
main:
    SUB sp, sp, #12
    STR lr, [sp]
    
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input of feet
    LDR r0, = format1
    LDR r1, = num1
    BL scanf

    #print the prompt to user
    LDR r0, =prompt2
    BL printf
    
    #scan user input of inch
    LDR r0, = format1
    LDR r1, = num2
    BL scanf

    #calculate the total number of inch
    LDR r2, =num1
    LDR r2, [r2]
    LDR r1, =num2
    LDR r1, [r1]
    MOV r0, #12
    MUL r2,r2,r0
    ADD r1, r1, r2

    #print the output message
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #12
    MOV pc, lr
.data
    prompt1: .asciz "Please input the number of feet and inch respectively?\nfeet:"
    prompt2: .asciz "inch:"
    format1: .asciz "%d"
    num1: .word 0
    num2: .word 0
    output1: .asciz "It is a total of %d inches.\n"
#End main
