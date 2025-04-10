#
# Program name: checkprime.s

# Author: Shun Fai Lee
# Date: 4/5/2025
# Purpose: This program is to allow user to input an positive integer >2 and check if it is prime number
# Input:
#   - input: an positive integer >2
# Output:
#   - format: print to termainl Yes or no
# Remarks: for assignment10 q2
#
.text
.global main
main:
    #program library:
    #r4: input value

    SUB sp, sp, #4
    STR lr, [sp]
    
    #print the prompt to user
    LDR r0, =promptCont
    BL printf
    
    #scan user input
    LDR r0, =format1
    LDR r1, =input
    BL scanf

    startSentinelLoop:
        #load the input value
        LDR r4, =input
        LDR r4, [r4]
        CMP r4, #-1
        BEQ endSentinelLoop
        
        CMP r4, #2
        BLE errorinput
        
        #block for sentinel loop
        MOV r0, r4
        BL primeness
        CMP r0, #0
        BEQ No
        
        LDR r0, =outputYes
        LDR r1, =input
        LDR r1, [r1]
        BL printf
        B next

        No:
        LDR r0, =outputNo
        LDR r1, =input
        LDR r1, [r1]
        BL printf
        B next

        errorinput:
        LDR r0, =promptError
        BL printf
        B next

        next:
        #Get next value
        #print the prompt to user
        LDR r0, =promptCont
        BL printf
        #scan user input
        LDR r0, =format1
        LDR r1, =input
        BL scanf

        B startSentinelLoop

    endSentinelLoop:
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    promptCont: .asciz "Please enter any positive integer other than 0 , 1 & 2 to check if they are prime.\nOr enter -1 to end the program\n : "
    promptError: .asciz "\nInput is not valid.\n\n"

    format1: .asciz "%d"
    input: .word 0

    outputYes: .asciz "\nNumber %d is prime.\n\n"
    outputNo: .asciz "\nNumber %d is not prime.\n\n"

#End main

.text
primeness:
    # take input of an integer n at r0 by dividing input with all integers from 2 to n/2
    # return 1 at r0 if input is prime
    # return 0 at r0 if input is not prime
    
    # function library
    #r4: input value
    #r5: end of loop value
    #r6: divisor and counter
        
    #push stack
    SUB sp, sp, #8
    STR lr, [sp, #0] 
    # reserve r4 value caller
    STR r4, [sp, #4]
    MOV r4, r0

    #initialize
    MOV r1, #2
    BL __aeabi_idiv
    MOV r5, r0
    MOV r6, #2
    
    Startloop:
        CMP r6, r5
        BGT isprime
        
        MOV r0, r4
        MOV r1, r6
        BL findremainder
        CMP r1, #0
        BEQ notprime
        ADD r6, r6, #1
        B Startloop
        
        notprime:
        MOV r0, #0
        B Endloop
    
        isprime:
        MOV r0, #1
    Endloop:
    
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #8
    MOV pc, lr
.data
#End primeness

.text
findremainder: 
    # take 2 input:
    # r0:dividend 
    # r1:divisor
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
