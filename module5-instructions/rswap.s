#
# Program name: rswap.s

# Author: S.Lee
# Date: 2/23/2025
# Purpose: This program is to swap two registers
# Input:
#   - input: 
# Output:
#   - nil
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    #print the prompt to user
    #LDR r0, =prompt1
    #BL printf
    
    #swap the two registers with EOR 
    LDR r1, =num1
    LDR r2, =num2

    #swap
    EOR r1, r1, r2
    EOR r2, r2, r1
    EOR r1, r1, r2

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    output1: .asciz "r1 is %x and r2 is %x\n"
    num1: .word 10
    num2: .word 20
#End main
