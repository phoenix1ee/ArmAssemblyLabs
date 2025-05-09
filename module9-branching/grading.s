#
# Program name: grading.s

# Author: S.Lee
# Date: 3/29/2025
# Purpose: This program is to allow user to input a name and an average score between 0 to 100
#          and calculate and printout the grade A (90-100), B (80-89), C (70-79) or F (below 70)
# Input:
#   - input: a name start with alphabet and a score in between 0 to 100
# Output:
#   - format: the name and the grade
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
    LDR r1, =name
    BL scanf
    
    LDR r0, =format2
    LDR r1, =score
    BL scanf
    
    #check the input of name
    LDR r0, =name
    LDRB r0, [r0]
    BL alphacheck1A
    
    MOV r1, #0
    CMP r0, r1
    BEQ incorrect
    
    #check input of score
    LDR r0, =score
    LDR r0, [r0]
    MOV r1, #0
    CMP r0, r1
    BLT incorrect
    
    MOV r1, #100
    CMP r0, r1
    BGT incorrect
    
    #check grade
    MOV r1, #90
    CMP r0, r1
    MOVGE r2, #0x41
    BGE print
    
    MOV r1, #80
    CMP r0, r1
    MOVGE r2, #0x42
    BGE print
    
    MOV r1, #70
    CMP r0, r1
    MOVGE r2, #0x43
    BGE print

    MOV r2, #0x46
    B print
    
    print:
    LDR r0, =output1
    LDR r1, =name
    BL printf
    
    B endmain
    
    incorrect:
    LDR r0, =output2
    BL printf

    #LDR r4, =num2
    #LDR r4, [r4]

    #MOV r1, #10
    #MUL r0, r1, r0 
    
    #MOV r1, #12
    #BL __aeabi_idiv

    endmain:
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the name of student (Start with alphabet) and the score? (Separate input with space)\n:"
    format1: .asciz "%s"
    format2: .asciz "%d"
    name: .space 40 
    score: .word 0
    output1: .asciz "The grade of %s is %c.\n"
    output2: .asciz "Incorrect name or score.\n"
#End main

.text
alphacheck1A: 
    # check and compare hex value of r0 and ascii value for a-z and A-Z
    # if r0 is between 0x41 and 0x5A or between 0x61 and 0x7a, then return 1 at r0
    # otherwise return 0 at r0
    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    #function core
    
    # if r0 >= 0x61, turn possible input into uppercase
    MOV r1, #0x61
    CMP r0, r1
    SUBPL r0, r0, #0x20
    
    # if r0 <0x41, put 0 to r1
    MOV r1, #0x41
    CMP r0, r1
    MOVLT r0, #0
    BLT end
    
    # if r0 >=0x41, compare with 0x5a
    mov r1, #0x5a
    cmp r0, r1
    MOVGT r0, #0
    MOVLE r0, #1
    
    end:
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
#End alphacheck1A
