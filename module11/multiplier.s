#
# Program name: multiplier.s

# Author: Shun Fai Lee
# Date: 4/9/2025
# Purpose: This program allow user to input two numbers and output the product of it using recursion in arm assembly
# Input: Two integers
# Output: The product of the two integers
# Remarks: for assignment11 q1
#

.text
.global main
main:

    #program library:
    #r4: 
    #r5: 
    #r6: 
        
    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0] 

    
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #8
    MOV pc, lr
.data
    promptCont: .asciz "\n : "
    promptError: .asciz "\n\n\n"

    format1: .asciz "%d"
    input: .word 0

    outputYes: .asciz "\n\n\n"
    outputNo: .asciz "\n\n\n"

#End main

.text
multiplier: 
    # A recursive function to multiply two numbers. Take 2 input: r0:integer 1 r1:integer 2
    # r0 = r0+r0+...+r0 for r1 times 
    # return at r0 the sum
    
    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    
    

        
    return:
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #12
    MOV pc, lr
.data
#End multiplier


.text
findremainder: 
    # A function find reminder. Take 2 input: r0:dividend r1:divisor
    # return the divisor back at r0
    # return the remainder at r1
    
    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    
    # store the r0:dividend
    STR r0, [sp, #4]
    # store r1:divisor
    STR r1, [sp, #8]
    
    #function core    
    #find the quotient
    BL __aeabi_idiv
    MOV r1, r0
    LDR r0, [sp, #8]
    LDR r2, [sp, #4]
    MUL r1, r0, r1
    SUB r1, r2, r1
        
    end:
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #12
    MOV pc, lr
.data
#End findremainder
