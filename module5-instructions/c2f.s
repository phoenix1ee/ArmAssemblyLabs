#
# Program name: c2f.s

# Author: S.Lee
# Date: 2/23/2025
# Purpose: This program is to use scanf to get user input of a degree in celsius and convert it to fahrenheit 
# Input:
#   - input: User entered a number in celsius
# Output:
#   - format: print the correspoding degree in fahrenheit
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

    #calculate the fahrenheit
    LDR r0, =num1
    LDR r0, [r0]
    MOV r1, #9
    MUL r0, r0, r1
    MOV r1, #5
    BL __aeabi_idiv
    MOV r1, #32
    ADD r1, r0, r1

    #print the output message
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the degree in Celsius?\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "The degree in Fahrenheit is %d.\n"
#End main
