#
# Program name: c2fa.s

# Author: S.Lee
# Date: 3/15/2025
# Purpose: This program is to use scanf to get user input of a number of temperature in celsius and convert it to fahrenheit 
# Input:
#   - input: User entered a number of temperature in celsius
# Output:
#   - format: print the correspoding number in fahrenheit
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input of temperature in celsius
    LDR r0, =format1
    LDR r1, =num1
    BL scanf

    LDR r0, =num1
    LDR r0, [r0]
    BL CToF 

    #print the output message
    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the in celsius?\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "The temperature in Fahrenheit is %d.\n"
#End main
