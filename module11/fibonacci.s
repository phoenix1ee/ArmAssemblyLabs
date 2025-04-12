#
# Program name: fibonacci.s

# Author: Shun Fai Lee
# Date: 4/9/2025
# Purpose: This program allow user to input a number n and calculate and output the Fibonacci number up to n recursively
# Input: 1 positive integer
# Output: The fibonacci number of order n
# Remarks: for assignment11 q2
#

.text
.global main
main:
    #program library:
    #r4: input integer n
        
    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0] 

    # Prompts user to enter an positive integer
    LDR r0, =promptin
    BL printf
    
    LDR r0, =format1
    LDr r1, =int1
    BL scanf

    startSentinelLoop:
        #load the input value and check for exit value
        LDR r4, =int1
        LDR r4, [r4]
        CMP r4, #-1
        BEQ endSentinelLoop
        
        # check for negative value
        CMP r4, #0
        BLT errorinput
        
        #block for sentinel loop
        
        #find F(n) by calling the fibo function
        MOV r0, r4
        BL fibo

        #Print out the results
        MOV r2, r0
        LDR r0, =output
        MOV r1, r4
        BL printf
        
        B next

        # Prompts user to that the input is not acceptable
        errorinput:
        LDR r0, =promptError
        BL printf
        B next

        next:

        #Get next value
        LDR r0, =promptin
        BL printf
        LDR r0, =format1
        LDR r1, =int1
        BL scanf

        B startSentinelLoop

    endSentinelLoop:

    #exit program

    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
    # Prompts user to enter an positive integer
    promptin: .asciz "Please input a positve integer to continue or -1 to exit\n : "

    # Prompts user to that the input is not acceptable
    promptError: .asciz "input is not valid\n : "
    
    # format of input
    format1: .asciz "%d"
    
    # variable to store input
    int1: .word 0

    # Print out the results
    output: .asciz "The fibonacci number of order %d is %d.\n"

#End main

# Function: fibo
# Purpose: A recursive function to calculate the Fibonacci number up to n.
# Inputs: Take 1 input: r0:integer n
# Outputs: return F(n) at r0
# Calculation: F(n) = F(n-1)+F(n-2) for n>=2, F(0)=0, F(1)=1 

.text
fibo: 
    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    
    MOV r4, r0

    #if n=0 or 1, return
    CMP r0, #0
    BEQ return
    CMP r0, #1
    BEQ return

    #if n>1, calculate F(n-1)+F(n-2)

    #calculate F(n-1)
    SUB r0, r4, #1
    BL fibo
    MOV r5, r0

    #calculate F(n-2)
    SUB r0, r4, #2
    BL fibo
    
    #F(n-1)+F(n-2)
    ADD r0, r0, r5
    B return

    return:
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
#End fibo

