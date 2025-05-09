#
# Program name: f2c.s

# Author: S.Lee
# Date: 2/23/2025
# Purpose: This program is to use scanf to get user input of a degree in fahrenheit and convert it to celsius 
# Input:
#   - input: User entered a number in fahrenheit
# Output:
#   - format: print the correspoding degree in celsius
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

    #calculate the celsius
    LDR r0, =num1
    LDR r0, [r0]
    MOV r1, #32
    SUB r0, r0, r1
    MOV r1, #5
    MUL r0, r0, r1
    MOV r1, #9
    BL __aeabi_idiv

    #print the output message
    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the degree in Fahrenheit?\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "The degree in Celsius is %d.\n"
#End main
