#
# Program name: grading.s

# Author: Shun Fai Lee
# Date: 3/29/2025
# Purpose: This program is to allow user to input 3 integer values and printout the maximum of them
# Input:
#   - input: 3 values
# Output:
#   - format: the maximum of the 3 values
# Remarks: for assignment9 q3
#
.text
.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input
    LDR r0, =format1
    LDR r1, =value1
    BL scanf
    
    LDR r0, =format1
    LDR r1, =value2
    BL scanf
    
    LDR r0, =format1
    LDR r1, =value3
    BL scanf

    #load the input value
    LDR r0, =value1
    LDR r0, [r0]
    LDR r1, =value2
    LDR r1, [r1]
    LDR r2, =value3
    LDR r2, [r2]

    #call function findMaxOf3
    BL findMaxOf3
    
    #print the maximum value found
    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "Please input 3 values to compare (Separate input with space)\n:"
    format1: .asciz "%d"
    value1: .word 0
    value2: .word 0
    value3: .word 0
    output1: .asciz "The maximum is %d.\n"
#End main

.text
findMaxOf3: 
    # check and compare the value at r0, r1 and r2 and return the maximum of 3 at r0
    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    #function core
    
    # Compare value at r0 and r1 and replace r0 with r1 if r0<r1
    CMP r0, r1
    MOVLT r0, r1
    
    # Compare value at r0 and r2 and replace r0 with r2 if r0<r2
    CMP r0, r2
    MOVLT r0, r2
    
    end:
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
#End alphacheck1A
