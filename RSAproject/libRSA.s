#
# Program name: libRSA.s

# Date: 4/16/2025
# Purpose: This is a library of functions for RSA algorithm
# Remarks: RSA project
#
.global modulus

# Function: modulus
# Author: Shun Fai Lee
# Purpose: This is the function to calculate the product n of p*q
# Inputs: r0: p (user input prime number p)
#         r1: q (user input prime number q)
# Outputs: return at r0 p*q
# dependencies: none

.text
modulus:
    # function library
    #r0: p (user input prime number p)
    #r1: q (user input prime number q)

    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0] 

    MUL r0, r0, r1
    
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
#end modulus

.global cprivexp

# Function: cprivexp
# Author: Shun Fai Lee
# Purpose: This is the the function to calculate the private key or in other word
#          a function to find the modular inverse d of integer a s.t. da = 1 (mod b)
# Inputs: r0: phi n ( integer b), r1: e (integer a)
# pre-requisite: phi n > e
# Outputs: return at r0 the value private key (modular inverse found, integer d)
# Pseudo Code: Using Extended Euclidean algorithm and algebra to find a general solution (s,t) of 
#              bt+as=1
# dependencies: function "mod"

.text
cprivexp:
    # function library
    #r4: equation 1, coefficient of b
    #r5: equation 1, coefficient of a
    #r6: equation 2, coefficient of b
    #r7: equation 2, coefficient of a
    #r8: temp variable to store a dividend/divisor from mod function
    #r10: temp variable to store a divisor/remainder from mod function
    #r11: temp variable to store a quotient

    #push stack
    #reserve r4-r8,r10-r11 value of caller
    SUB sp, sp, #40
    STR lr, [sp, #0] 
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]
    STR r10, [sp, #24]
    STR r11, [sp, #28]
    #reserve the input phi n
    STR r0, [sp, #32]
    #reserve the input e
    STR r1, [sp, #36]

    #initialization
    MOV r4, #1
    MOV r5, #0
    MOV r6, #0
    MOV r7, #1
    MOV r8, r0
    MOV r10, r1

    #use a loop to solve for the coefficients of equation 1 and 2 repeatedly until reaching remainder = 1
    StartCpriexpLoop:
        #calculate a quotient
        BL __aeabi_idiv
        MOV r11, r0

        #update coefficient of equations
        MUL r0, r6, r11
        SUB r0, r4, r0
        MOV r4, r6
        MOV r6, r0
        MUL r0, r7, r11
        SUB r0, r5, r0
        MOV r5, r7
        MOV r7, r0

        #calculate a remainder and reserve at r8 and r10
        #for next iteration
        MOV r0, r8
        MOV r1, r10
        BL mod
        MOV r8, r0
        MOV r10, r1

        #if remainder = 1, end condition
        CMP r10, #1
        BEQ EndCpriexpLoop
        B StartCpriexpLoop

    EndCpriexpLoop:
    LDR r1, [sp, #32]

    StartCpriexpOutputLoop:
        #if coefficient of a at r7 found < 0, add phi n until it become positive
        CMP r7, #0
        ADDLT r7, r7, r1
        BLT StartCpriexpOutputLoop
        B EndCpriexpOutputLoop
    EndCpriexpOutputLoop:
    B CprivexpReturn

    CprivexpReturn:
    MOV r0, r7

    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    LDR r10, [sp, #24]
    LDR r11, [sp, #28]
    ADD sp, sp, #40
    MOV pc, lr
.data
#end cprivexp

.global decryptChar

# Function: decryptChar
# Author: Shun Fai Lee
# Purpose: This is the the function to decrypt a cipher character c using private key d and product p*q = n
#          m = c^d (mod n) calculate the cipher text
# Inputs: r0: c (cipher value to be decrypted)
#         r1: d (private key d)
#         r2: n (user chosen public key n p*q)
# Outputs: return at r0 the decrypted value
# Pseudo Code: This function reuse "encryptChar" because they use the same calculation
# dependencies: function "encryptChar"

.text
decryptChar:
    # function library
    #r0: c (cipher value to be decrypted)
    #r1: d (private key d)
    #r2: n (user chosen public key n p*q)

    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0] 

    BL encryptChar

    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
#end decryptChar

.global encryptChar

# Function: encryptChar
# Author: Shun Fai Lee
# Purpose: This is the the function to encrypt a character c using public key e and product p*q = n
#          c = m^e (mod n) calculate the cipher text
# Inputs: r0: m (ascii value of character to be encrypted)
#         r1: e (user chosen public key e)
#         r2: n (user chosen public key n p*q)
# Outputs: return at r0 the cipher text/encrypted value
# Pseudo Code: find the least power i that yield a remainder 1. 
#              Then simplify calculation to m^(e-ki) (mod n)
#              This make use of the multiplicative properties in moduler arithematic
# dependencies: function "mod"

.text
encryptChar:
    # function library
    #r4: m (ascii value of character to be encrypted)
    #r5: e (user chosen public key e)
    #r6: n (user chosen public key n p*q)
    #r7: temp variable for remainder
    #r8: temp variable for power

    #push stack
    #reserve r4-r8 value of caller
    SUB sp, sp, #24
    STR lr, [sp, #0] 
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]

    #reserve the input in r4-r6
    MOV r4, r0
    MOV r5, r1
    MOV r6, r2

    #find remainder of m^1 mod n, used to simplify calculation of big power
    MOV r1, r6
    BL mod
    #save to r7 for reserve
    MOV r7, r1
    #save a count, this is the power of m s.t. m^1 mod n
    MOV r8, #1

    #find the integer a s.t. m^a = 1 mod(n)
    StartencryLoop1:
        CMP r1, #1
        MULNE r0, r1, r7
        ADDNE r8, r8, #1
        MOVNE r1, r6
        BLNE mod
        BNE StartencryLoop1
        B EndencryLoop1
    EndencryLoop1:

    # find e mod r8 and replace e
    MOV r0, r5
    MOV r1, r8
    BL mod
    MOV r5, r1

    #find remainder of m^1 mod n
    MOV r0, r4
    MOV r1, r6
    BL mod
    #save to r7 for reserve
    MOV r7, r1
    #save a count, to count against r5
    MOV r8, #1

    #find m^e mod(n)
    StartencryLoop2:
        CMP r8, r5
        MULNE r0, r1, r7
        ADDNE r8, r8, #1
        MOVNE r1, r6
        BLNE mod
        BNE StartencryLoop2
        B EndencryLoop2
    EndencryLoop2:

    encryptCharReturn:
    MOV r0, r1

    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    ADD sp, sp, #24
    MOV pc, lr

.data
#end encryptChar

.global gcd

# Function: gcd
# Author: Shun Fai Lee
# Purpose: A function to find the GCD of two positive integers
# Inputs: r0:integer1 , r1: integer2
# Outputs: return at r0 the value of GCD of r0 and r1
# Pseudo Code: check for the remainder of r0/r1, and repeat the process
# using Euclidean algorithm until reaching remainder = 0
# dependencies: function "mod"

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

.global mod

# Function: mod
# Author: Shun Fai Lee
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

.global modulus

# Function: modulus
# Author: Shun Fai Lee
# Purpose: This is the function to calculate the product n of p*q
# Inputs: r0: p (user input prime number p)
#         r1: q (user input prime number q)
# Outputs: return at r0 p*q
# dependencies: none

.text
modulus:
    # function library
    #r0: p (user input prime number p)
    #r1: q (user input prime number q)

    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0] 

    MUL r0, r0, r1
    
    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
#end modulus

.global pow

# Function: pow
# Author: Shun Fai Lee
# Purpose: A function to calculate positive power of an integer
# Scope: this function take care of only positve power index >= 0
# Definition: 0^0 defined = 0
# Inputs: r0:integer , r1: power index
# Outputs: return at r0 the value r0^r1
# Pseudo Code: 
# dependencies: function ""

.text
pow:
    # function library
    #r4: input integer
    #r5: input power of the integer

    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0] 
    # reserve r4-r5 value of caller
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    
    MOV r4, r0
    MOV r5, r1

    CMP r5, #0
    MOVEQ r0, #1
    BEQ powreturn

    CMP r4, #0
    MOVEQ r0, #0
    BEQ powreturn

    startpow:
    CMP r5, #1
    BEQ powreturn
    MUL r0, r0, r4
    SUB r5, r5, #1
    B startpow

    powreturn:
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
#end pow

.global primeness

# Function: primeness
# Author: Shun Fai Lee
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

