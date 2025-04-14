#
# Program name: libRSA.s

# Author: Shun Fai Lee
# Date: 4/X/2025
# Purpose: This is a library of functions for RSA algorithm
# Remarks: RSA project
#

# Function: pow
# Purpose: A function to calculate exponential of an integer
# Inputs: r0:integer , r1: integer of the power
# Outputs: return at r0 the value r0^r1
# Pseudo Code: 
# dependencies: function ""

.global pow
.text
    # function library
    #r4: input integer 1
    #r5: input power of the integer

    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0] 
    # reserve r4-r5 value of caller
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    CMP r5, #0
    MOV r0, #0
    BEQ return

    
    
    return:
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
#end pow



# Function: gcd
# Purpose: A function to find the GCD of two positive integers
# Inputs: r0:integer1 , r1: integer2
# Outputs: return at r0 the value of GCD of r0 and r1
# Pseudo Code: check for the remainder of r0/r1, and repeat the process
# using Euclidean algorithm until reaching remainder = 0
# dependencies: function "mod"

.global gcd

.text
gcd:

    # function library
    #r4: input integer 1
    #r5: input integer 2

    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0] 
    # reserve r4-r5 value of caller
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    #take absolute value for both input integers
    CMP r0, #0
    RSBLT r0, r0, #0
    CMP r1, #0
    RSBLT r1, r1, #0

    # store the input value at r4 and r5
    # put bigger input at r4 and smaller at r5
    CMP r0, r1
    MOVLT r4, r1
    MOVLT r5, r0
    MOV r4, r0
    MOV r5, r1
    
    # gcd(0, 0) defined as 0
    ADD r3, r4, r5
    CMP r3, #0
    MOVEQ r0, #0
    BEQ return

    # smaller integer always at r5, gcd of any non zero integer with 0 = 0
    CMP r5, #0
    BEQ return

    # do r0/r1 and check remainder
    # divisor returned at r0 and remainder returned by "mod" at r1
    # if remainder != 0, loop back and call "mod" again until remainder =0
    # the divisor at r0 is the gcd
    gcdstart:
    BL mod
    CMP r1, #0
    BEQ return
    B gcdstart

    return:
    #the divisor at r0 is the gcd

    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
#end gcd

.global primeness

# Function: primeness
# Purpose: A function to check if an integer is prime or not by dividing input with all integers from 2 to n/2
# Inputs: Take 1 input: r0:integer n at r0
# Outputs: return at r0 the value 1 if input is prime or 0 if input is not prime
# Pseudo Code: check the remainder by dividing input n with all integers from 2 to n/2 

.text
primeness:
    
    # function library
    #r4: input value
    #r5: end of loop value
    #r6: divisor and counter
        
    #push stack
    SUB sp, sp, #16
    STR lr, [sp, #0] 
    # reserve r4-r6 value of caller
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

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
        BL mod
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
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr
.data
#End primeness

.global mod

# Function: mod
# Purpose: A function to find the remainder of a division
# Inputs: Take 2 input: r0:dividend and r1:divisor
# Outputs: return the divisor back at r0 return the remainder of r0/r1 at r1

.text
mod: 
    
    # function library
    #r4: input value
    #r5: end of loop value
    #r6: divisor and counter

    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    
    # reserve r4 and r5 value of caller
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    
    # store the r0:dividend
    MOV r4, r0
    # store r1:divisor
    MOV r5, r1
  
    #find the quotient of r0/r1
    BL __aeabi_idiv

    #calculate the remainder
    #grep the quotient
    MOV r1, r0
    #grep the divisor
    MOV r0, r5
    #quotient x divisor
    MUL r1, r0, r1
    #grep the dividend
    MOV r2, r4
    #dividend - quotient x divisor 
    SUB r1, r2, r1
        
    end:
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
#End mod
