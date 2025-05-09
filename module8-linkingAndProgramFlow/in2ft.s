#
# Program name: in2ft.s

# Author: S.Lee
# Date: 3/15/2025
# Purpose: This program is to use scanf to get user input of number of inches and convert it to feet 
# Input:
#   - input: User entered a number in inches
# Output:
#   - format: print the correspoding number in ft and inches
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input of inches
    LDR r0, =format1
    LDR r1, =num1
    BL scanf

    LDR r0, =num1
    LDR r0, [r0]
    BL InchesToFt 

    #print the output message
    MOV r2, r1
    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the number of inches?\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "It is %d feet and %d inches.\n"
#End main
