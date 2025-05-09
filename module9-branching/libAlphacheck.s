#
# Program name: libAlphacheck.s

# Author: S.Lee
# Date: 3/29/2025
# Purpose: This is a library of two functions to check whether value at r0 is alphabet or not 
# input:
#    - input: ascii value at r0
# output:
#    - output: 1 for alphabetic and 0 for not alphabetic at r0
#

.global alphacheck1A

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

.global alphacheck1B

.text
alphacheck1B: 
    # check and compare value of r0 and ascii value for a-z and A-Z by quotient of division
    # if r0 is between 65 and 90 or between 97 and 122, then return 1 at r0
    # otherwise return 0 at r0 
    #push stack
    SUB sp, sp, #24
    STR lr, [sp, #0]
    STR r0, [sp, #4]
    
    #function core
    #check if smaller than 122
    MOV r1, #123
    BL __aeabi_idiv
    EOR r0, r0, #1
    STR r0, [sp, #8]
    
    #check if larger than 97
    LDR r0, [sp, #4]
    MOV r1, #97
    BL __aeabi_idiv

    #store result of 97<= <=122 at #12
    LDR r1, [sp, #8]
    AND r0, r0, r1
    STR r0, [sp, #12]

    #check if smaller than 90    
    LDR r0, [sp, #4]
    MOV r1, #91
    BL __aeabi_idiv
    EOR r0, r0, #1
    STR r0, [sp, #8]
    
    #check if larger than 65
    LDR r0, [sp, #4]
    MOV r1, #65
    BL __aeabi_idiv
    
    LDR r1, [sp, #8]
    AND r0, r0, r1
    
    LDR r1, [sp, #12]
    ORR r0, r0, r1
    
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #24
    MOV pc, lr
.data
#End alphacheck1B
