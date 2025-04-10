#
# Program name: guess.s

# Author: Shun Fai Lee
# Date: 4/5/2025
# Purpose: This program is to allow user to input a positive integer as maximum and let the user to guess the value
# Input:
#   - input: a positive integer as maximum of range
# Output:
#   - format: print to termainl message of guess/correct answer
# Remarks: for assignment10 q3
#
.text
.global main
main:
    #program library:
    #r4: the random number generated
    #r5: count of guess

    SUB sp, sp, #4
    STR lr, [sp]
    
    #print the prompt to user
    LDR r0, =promptCont
    BL printf
    
    #scan user input
    LDR r0, =format1
    LDR r1, =max
    BL scanf

    startSentinelLoop:
        #load the input of max value
        LDR r0, =max
        LDR r0, [r0]
        CMP r0, #-1
        BEQ endSentinelLoop
        
        CMP r0, #0
        BLE errorinput
        
        #generate random number and initialize
        BL getrandom
        MOV r4, r0
        MOV r5, #0

        LDR r0, =promptready
        BL printf

        #block for sentinel loop
        startguess:
            LDR r0, =promptguess
            BL printf
            #take guess
            LDR r0, =format1
            LDR r1, =guessinput
            BL scanf
            
            ADD r5, r5, #1
            LDR r0, =guessinput
            LDR r0, [r0]
            CMP r0, r4
            BEQ endguess
            BLT lower
            BGT higher
            
            higher:
            LDR r0, =outputhigh
            BL printf
            B startguess
            
            lower:
            LDR r0, =outputlow
            BL printf
            B startguess
            
        endguess:
        MOV r1, r0
        MOV r2, r5
        LDR r0, =outputyes
        BL printf
        
        B nextgame

        errorinput:
        LDR r0, =promptError
        BL printf
        B nextgame

        nextgame:
        #Get next value
        #print the prompt to user
        LDR r0, =promptCont
        BL printf
        #scan user input
        LDR r0, =format1
        LDR r1, =max
        BL scanf

        B startSentinelLoop

    endSentinelLoop:
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    promptCont: .asciz "Type -1 to exit or start by entering a positive integer as the maximum of range.\nA secret number will be generated in between\n: "
    promptError: .asciz "\nInput is not valid.\n\n"
    promptready: .asciz "\nIt is ready. Lets start guessing the secret number.\n "
    promptguess: .asciz "\nPlease enter your guess:"
    format1: .asciz "%d"
    max: .word 0
    guessinput: .word 0

    outputhigh: .asciz "guess is too high.\n"
    outputlow: .asciz "guess is too low.\n"
    outputyes: .asciz "\nCorrect. The number is %d. You use %d guesses to find the correct answer.\n\n"

#End main


.text
getrandom: 
    # take 1 input:
    # input: r0:an integer as upperbound 
    # return: r0: a number between 1 and r0
    
    #r4: input integer
    #r5: power of 10
    #r6: accumulation
    #r7: temporary random number at each loop

    #push stack
    SUB sp, sp, #20
    STR lr, [sp, #0]
    
    # reserve value of r4 - r7 of callee
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    #function core    
    
    MOV r4, r0
    MOV r5, #1
    MOV r6, #0
    MOV r8, #0

    getrandstart:

        #get the instant system time of seconds
        LDR r0, =time2
        MOV r1, #0
        MOV r7, #78
        SVC 0
        #get a number between 1-10
        LDR r0, =time2
        ADD r0, r0, #4
        LDRB r0, [r0]
        MOV r1, #10
        BL findremainder
        MOV r7, r1
        ADD r7, r7, #1

        #check digit
        CMP r4, r5
        BLT getrandend
        MOV r0, r4
        MOV r1, r5
        BL decimaldigit

        MUL r0, r0, r5
        MUL r0, r0, r7
        MOV r1, #10
        BL __aeabi_idiv
        ADD r6, r0, r6
        MOV r0, #10
        MUL r5, r5, r0
        B getrandstart
        
    getrandend:
    
    MOV r0, r6
    CMP r0, #0
    ADDEQ r0, r0, #1

    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr
.data
    time2: .word 0
           .word 0
#End getrandom


.text
decimaldigit: 
    # take 2 input:
    # r0:decimal number 
    # r1:the required place digit, must be the power of 10
    # return the digit back at r0
    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    #function core    
    #find the quotient
    BL __aeabi_idiv
    MOV r1, #10
    BL findremainder
    MOV r0, r1
    
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
#end decimaldigit

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
