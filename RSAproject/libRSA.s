#
# Program name: libRSA.s

# Date: 4/30/2025
# Purpose: This is a library of functions for RSA algorithm
# Remarks: RSA project
#

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

.global cpubexp

# Function: cpubexp
# Author: Shun Fai Lee
# Purpose: This is the function to calculate and return the public key n = p*q
#          and the phi n = (p-1)*(q-1)
# Inputs: r0: P
#         r1: Q
# Outputs: return at r0 = p*q
#          return at r1 = (p-1)*(q-1)

.text
cpubexp:
    # function library
    #r4: p (user input prime number p)
    #r5: q (user input prime number q)

    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    MOV r4, r0
    MOV r5, r1
    MUL r0, r4, r5

    SUB r1, r0, r4
    SUB r1, r1, r5
    ADD r1, r1, #1

    #pop stack
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
#end cpubexp

.global decryptChar

# Function: decryptChar
# Author: Shun Fai Lee
# Purpose: This is the the function to decrypt a cipher character c using private key d and product p*q = n
#          m = c^d (mod n) calculate the cipher text
# Inputs: r0: c (cipher value to be decrypted)
#         r1: d (private key d)
#         r2: n (user chosen public key n p*q)
# Outputs: return at r0 the decrypted value, or -1 if decrypted value is not ascii value, i.e <0 or >127
# Pseudo Code: This function reuse "encryptChar" because they use the same calculation
# dependencies: function "euclidmod"

.text
decryptChar:
    # function library
    #r0: c (cipher value to be decrypted)
    #r1: d (private key d)
    #r2: n (user chosen public key n p*q)

    #push stack
    SUB sp, sp, #4
    STR lr, [sp, #0] 

    #cipher text of 0 return 0
    CMP r0, #0
    BEQ decryptReturn

    BL euclidmod
    
    #check if the decrypted value is an legitimate ascii value
    CMP r0, #0
    BLT decryptError
    
    CMP r0, #127
    BGT decryptError

    B decryptReturn

    decryptError:
    MOV r0, #-1
    B decryptReturn
    
    decryptReturn:
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
# Outputs: return at r0 the cipher text/encrypted value, or -1 if input value is not ascii value, i.e <0 or >127 
# dependencies: function "euclidmod"

.text
encryptChar:
    # function library
    #r4: m (ascii value of character to be encrypted)
    #r5: e (user chosen public key e)
    #r6: n (user chosen public key n p*q)

    #push stack
    #reserve r4-r6 value of caller
    SUB sp, sp, #16
    STR lr, [sp, #0] 
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    #reserve the input in r4-r6
    MOV r4, r0
    MOV r5, r1
    MOV r6, r2

    #check if input is legitimate ascii value
    CMP r4, #0
    BLT encryptError
    #0 return 0
    MOVEQ r0, #0
    BEQ encryptCharReturn
    
    CMP r4, #127
    BGT encryptError

    BL euclidmod
    B encryptCharReturn

    encryptError:
    MOV r0, #-1
    B encryptCharReturn

    encryptCharReturn:

    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr

.data
#end encryptChar

.global euclidmod

# Function: euclidmod
# Author: Shun Fai Lee
# Purpose: This is the function to use extended euclidean algorithm to calculate modulus maths of form of a^b(mod c)
#          for use in encryption and decryption maths
# Inputs: r0: a
#         r1: b
#         r2: c
# Pseudo Code: find the lst remainder of r = a mod c. 
#              Then repeat calculating r*a (mod c) for b-1 times
#              This make use of the multiplicative properties in moduler arithematic
# Outputs: return at r0 = a^b(mod c) or -1 if any of them are < 0 or c = 0
# dependencies: function "mod"

.text
euclidmod:
    # function library
    #r4: a
    #r5: b
    #r6: c
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

    #initialize r8
    MOV r8, #0

    #special conditions

    #if a<0, return -1
    CMP r4, #0
    BLT euclidmodError
    
    #if b<0, return -1
    CMP r5, #0
    BLT euclidmodError

    #if c<=0, return -1
    CMP r6, #1
    BLT euclidmodError

    #if a and b = 0, return -1
    ORR r0, r4, r5
    CMP r0, #0
    BEQ euclidmodError


    MOV r0, #0
    MOV r1, #0

    #if a > 0 and b = 0, return 1
    CMP r4, #0
    MOVGT r0, #1
    CMP r5, #0
    MOVEQ r1, #1
    AND r2, r0, r1
    CMP r2, #1
    MOVEQ r0, #1
    BEQ euclidmodReturn

    MOV r0, #0
    MOV r1, #0

    #if a = 0 and b > 0, return 0
    CMP r4, #0
    MOVEQ r0, #1
    CMP r5, #0
    MOVGT r1, #1
    AND r2, r0, r1
    CMP r2, #1
    MOVEQ r0, #1
    BEQ euclidmodReturn

    #a=1 will return 1
    CMP r4, #1
    BEQ euclidmodReturn

    #if c=1, return 0
    CMP r6, #1
    MOVEQ r0, #0
    BEQ euclidmodReturn

    #initialization
    #find remainder of a^1 mod c, used to simplify calculation of big power
    MOV r1, r6
    BL mod
    #save the remainder found to r7 for reserve
    MOV r7, r1
    #increase r8 by 1
    ADD r8, r8, #1

    #if r8 = b, return the remainder
    CMP r8, r5
    MOVEQ r0, r7
    BEQ euclidmodReturn

    #repeat finding mod until power = b
    StarteuclidmodLoop:
        MUL r0, r4, r7
        MOV r1, r6
        BL mod
        MOV r7, r1
        ADD r8, r8, #1
        CMP r8, r5
        MOVEQ r0, r7
        BEQ EndeuclidmodLoop
        B StarteuclidmodLoop
    EndeuclidmodLoop:
    B euclidmodReturn

    euclidmodError:
    MOV r0, #-1
    B euclidmodReturn

    euclidmodReturn:

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
#end euclidmod

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

.global legitE

# Function: legitE
# Author: Shun Fai Lee
# Purpose: This is the function to prompt user for a public key exponent e
# Inputs: r0: phi n / totient
# Outputs: return at r0: value of a valid e or -1 to quit
# dependencies: "gcd"

.text
legitE:
    # function library
    #r4: e (user input public key e)
    #r5: phi n/totient (from argument input)

    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    MOV r5, r0

    startlegitELoop:
        #print the prompt to user
        LDR r0, =promptE
        MOV r1, r5
        BL printf
        #scan user input
        LDR r0, =formatE
        LDR r1, =inputE
        BL scanf

        #load the input value
        LDR r4, =inputE
        LDR r4, [r4]

        #check the input
        #exit at -1
        CMP r4, #-1
        MOVEQ r0, #-1
        BEQ returnlegitE
        
        #check if E > 1
        CMP r4, #1
        BLE legitEerrorInput

        #check if E < totient
        CMP r4, r5
        BGE legitEerrorInput2

        #check if E is co-prime to totient
        MOV r0, r4
        MOV r1, r5
        BL gcd
        CMP r0, #1
        BNE legitEerrorInput3

        B endlegitELoop

        legitEerrorInput:
        LDR r0, =promptEerror
        BL printf
        B startlegitELoop

        legitEerrorInput2:
        LDR r0, =promptEerror2
        BL printf
        B startlegitELoop

        legitEerrorInput3:
        LDR r0, =promptEerror3
        BL printf
        B startlegitELoop

    endlegitELoop:

    MOV r0, r4
    B returnlegitE

    returnlegitE:
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
    promptE: .asciz "Please enter a public key e < than the totient (P-1)*(Q-1) : %d or -1 to quit\n: "
    promptEerror: .asciz "\nInput is not >1.\n\n"
    promptEerror2: .asciz "\nInput is not <totient.\n\n"
    promptEerror3: .asciz "\nInput is not co-prime to totient.\n\n"

    formatE: .asciz "%d"
    inputE: .word 0
#End legitE

.global legitK

# Function: legitK
# Author: Shun Fai Lee
# Purpose: This is the function to prompt user for two valid prime number as keys
# Inputs: none
# Outputs: return at r0: P and at r1: Q or -1 at r0 to quit
# dependencies: "primeness"

.text
legitK:
    # function library
    #r4: p (user input prime number p)
    #r5: q (user input prime number q)

    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    startlegitKLoop1:
        #print the prompt to user
        LDR r0, =promptP
        BL printf
        #scan user input
        LDR r0, =format1
        LDR r1, =inputP
        BL scanf

        #load the input value
        LDR r4, =inputP
        LDR r4, [r4]

        #check the input
        #exit at -1
        CMP r4, #-1
        MOVEQ r0, #-1
        BEQ returnlegitK
        
        #check if P is prime
        MOV r0, r4
        BL primeness
        CMP r0, #0
        BEQ legitKerrorinput1

        B endlegitKLoop1

        legitKerrorinput1:
        LDR r0, =promptError
        BL printf
        B startlegitKLoop1
    endlegitKLoop1:

    startlegitKLoop2:
        #print the prompt to user
        LDR r0, =promptQ
        BL printf
        #scan user input
        LDR r0, =format1
        LDR r1, =inputQ
        BL scanf

        #load the input value
        LDR r5, =inputQ
        LDR r5, [r5]

        #check the input
        #exit at -1
        CMP r5, #-1
        MOVEQ r0, #-1
        BEQ returnlegitK
        
        #check if Q is prime
        MOV r0, r5
        BL primeness
        CMP r0, #0
        BEQ legitKerrorinput2

        B endlegitKLoop2

        legitKerrorinput2:
        LDR r0, =promptError
        BL printf
        B startlegitKLoop2
    endlegitKLoop2:

    #check if 122<P*Q<0x7fffffff=2,147,483,647
    MUL r0, r4, r5
    CMP r0, #122
    BLE legitKinvalidKey

    MOV r0, r4
    MOV r1, r5
    B returnlegitK

    legitKinvalidKey:
    #print the prompt to user
    LDR r0, =promptError2
    BL printf
    B startlegitKLoop1

    returnlegitK:
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
.data
    promptP: .asciz "Please enter the 1st prime number P or -1 to quit\n: "
    promptQ: .asciz "Please enter the 2nd prime number Q or -1 to quit\n: "
    promptError: .asciz "\nInput is not prime.\n\n"
    promptError2: .asciz "\nKeys chosen are not legitimate. \nPlease make sure product of two prime numbers is greater than 122 and smaller than 0x7fffffff or 2,147,483,647\n\n"

    format1: .asciz "%d"
    inputP: .word 0
    inputQ: .word 0
#End legitK

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
    MUL r1, r0, r4
    MOV r0, r1
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

    CMP r4, #1
    BLE notprime

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
