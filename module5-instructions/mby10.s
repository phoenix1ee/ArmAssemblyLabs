#
# Program name: mby10.s

# Author: S.Lee
# Date: 2/23/2025
# Purpose: This program is to use scanf to get user input of a number, multiply it by 10 and then print out the result
# Input:
#   - input: User entered a number
# Output:
#   - format: print the result after multiply input by 10
#

.global main
main:
    SUB sp, sp, #12
    STR lr, [sp]
    
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input for a number
    LDR r0, = format1
    LDR r1, = num1
    BL scanf

    #calculate the multiplication
    LDR r0, =num1
    LDR r0, [r0]
    #shift by 3 bits
    LSL r1, r0,#3
    #shift by 1 bits
    LSL r0, #1
    #add shifted values together
    ADD r1, r1, r0

    #print the output message
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #12
    MOV pc, lr
.data
    prompt1: .asciz "Please input the number\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "The result is %d.\n"
#End main
