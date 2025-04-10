#
# Program name: grading.s

# Author: Shun Fai Lee
# Date: 3/29/2025
# Purpose: This program is to allow user to input a name and an average score between 0 to 100
#          and calculate and printout the grade A (90-100), B (80-90), C (70-80) or F (below 70)
# Input:
#   - input: a name in alphabets and a score in between 0 to 100
# Output:
#   - format: the name and the grade
# Remarks: for assignment9 q2
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    LDR r0, =format1
    LDR r1, =name
    BL scanf
    
    LDR r0, =format2
    LDR r1, =score
    BL scanf
    
    LDR r0, =score
    LDRB r1, [r0, #0]
    LDRB r2, [r0, #1]
    LDRB r3, [r0, #2]
    
    CMP r3, #0
    BEQ twodigit
    
    B end

    twodigit:
    LDR r0, =output2
    BL printf
    
    end:
    #LDR r0, =output2
    #LDR r1, =num1
    #LDR r1, [r1]
    
    #BL printf

    #LDR r4, =num2
    #LDR r4, [r4]

    #MOV r1, #10
    #MUL r0, r1, r0 
    
    #MOV r1, #12
    #BL __aeabi_idiv

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the name of student the score?\n:"
    format1: .asciz "%s"
    format2: .asciz "%s"
    name: .space 40 
    score: .space 3
    output1: .asciz "The grade of %s is %d.\n"
    output2: .asciz "two digits\n"
#End main
