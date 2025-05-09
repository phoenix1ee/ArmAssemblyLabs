#
# Program name: multiplier.s

# Author: S.Lee
# Date: 4/9/2025
# Purpose: This program allow user to input two numbers and output the product of it using recursion in arm assembly
# Input: Two integers
# Output: The product of the two integers
#

.text
.global main
main:

    #program library:
    #r4: sign of r0, 1 denote +ve, 0 denote -ve
    #r5: sign of r1, 1 denote +ve, 0 denote -ve
        
    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0] 

    # prompt user for two integers
    LDR r0, =promptin
    BL printf
    
    LDR r0, =format1
    LDr r1, =int1
    BL scanf

    LDR r0, =format1
    LDr r1, =int2
    BL scanf

    # Load integer 1 into register
    LDR r0, =int1
    LDR r0, [r0]

    #check the sign of integer1 or if int1=0
    MOV r2, #0
    CMP r0, r2
    BEQ zero
    SUBLT r0, r2, r0
    MOVLT r4, #0
    MOVGT r4, #1

    # Load integer 1 into register
    LDR r1, =int2
    LDR r1, [r1]

    #check the sign of integer2 or if int2=0
    MOV r2, #0
    CMP r1, r2
    BEQ zero
    SUBLT r1, r2, r1
    MOVLT r5, #0
    MOVGT r5, #1
    
    #call the multiply function
    BL product
    #after return, output results with correct sign
    CMP r4, r5
    BEQ positve
    BNE negative
    
    #if int1/int2 = 0, output 0
    zero:
    MOV r1, #0
    B endmain

    #if int1 and int2 have same sign, i.e. +ve, move calculated value for output
    positve:
    MOV r1, r0
    B endmain

    #if int1 and int2 have different sign, i.e. -ve subtract it with 0 and move calculated value for output
    negative:
    MOV r2, #0
    SUB r1, r2, r0
    B endmain

    #printout products with correct sign
    endmain:
    LDR r0, =output
    BL printf

    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
    # prompt user for two integers
    promptin: .asciz "Please input two integers\n : "

    format1: .asciz "%d"

    # variable to store the two input integers
    int1: .word 0
    int2: .word 0

    # output the results
    output: .asciz "The product of the two number is %d.\n"

#End main

# Function: product
# Purpose: A recursive function to multiply two numbers. Take 2 input: r0:integer x r1:integer y
# Inputs: Take 2 input: r0:integer x r1:integer y
# Outputs: return at r0 the sum
# Pseudo Code: r0 = r0+r0+...+r0 for r1 times 

.text
product: 
    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    
    # store the input value at r4 and r5
    MOV r4, r0
    MOV r5, r1

    #if y=1, return
    CMP r1, #1
    BEQ return

    #if y>0, y=y-1
    SUB r1, r1, #1
    #call function recursively
    BL product
    #add the returned value with r4
    ADD r0, r0, r4
    
    return:
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
#End product

