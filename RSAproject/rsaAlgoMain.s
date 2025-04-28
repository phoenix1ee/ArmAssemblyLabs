#
# Program name: rsaAlgo.s

# Author: Section 82 Team 5
# member: Shun Fai Lee
#         Kat Russell
# Date: 4/X/2025
# Purpose: This is a program to encrypt or decrypt text with RSA Algorithm
# Functions: cprivexp, cpubexp, decryptChar, encryptChar, gcd, legitE, legitK, mod, pow, primeness
# input: encryption keys, file containing text to encrypt/text to decrypt
# output: file containing the cipher text or decrypted text
# Remarks: RSA project
#

.text
.global main
main:
    #program library:
    #r4: modulus n = p*q
    #r5: modulus totient / phi n = (p-1)*(q-1)
    #r6: public key e
    #r7: private key d

    #push stack
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    startRSAloop:
        #prompt user for options
        LDR r0, =prompttaskcontent
        BL printf
        LDR r0, =prompttask
        BL printf

        #scan user input
        LDR r0, =format1
        LDR r1, =inputtask
        BL scanf

        #check task and branch
        LDR r0, =inputtask
        LDR r0, [r0]
        CMP r0, #-1
        BEQ endRSAloop

        CMP r0, #1
        BEQ startGenKeys

        CMP r0, #2
        BEQ startEncryptloop

        CMP r0, #3
        BEQ startDecryptloop

        startGenKeys:
            #prompt for entering public keys component p and q
            BL legitK
            CMP r0, #-1
            BEQ endGenKeys
    
            #calculate public key and store n and totient at r4 and r5
            BL cpubexp
            MOV r4, r0
            MOV r5, r1

            #prompt for public key e and store at r6
            MOV r0, r5
            BL legitE
            CMP r0, #-1
            BEQ endGenKeys
            MOV r6, r0

            #calculate private key d and store at r7
            MOV r0, r5
            MOV r1, r6
            BL cprivexp
            MOV r7, r0

            #print the public key and private keys to user
            MOV r1, r4
            MOV r2, r6
            MOV r3, r7
            LDR r0, =outputkey
            BL printf
            B endGenKeys

        endGenKeys:
        B startRSAloop

        startEncryptloop:

            #block for encrypt
            #prompt for entering public keys n and e
            LDR r0, =promptpubkeyn
            BL printf
            
            #scan user input
            LDR r0, =format1
            LDR r1, =inputn
            BL scanf
            
            LDR r4, =inputn
            LDR r4, [r4]
            CMP r4, #-1
            BEQ endEncryptloop

            LDR r0, =promptpubkeye
            BL printf
            
            #scan user input
            LDR r0, =format1
            LDR r1, =inpute
            BL scanf

            LDR r6, =inpute
            LDR r6, [r6]
            CMP r6, #-1
            BEQ endEncryptloop

            MOV r1, r4
            MOV r2, r6
            LDR r0, =outputkey2
            BL printf

            #prompt for and encrypt input text
            #call encryptChar
            #

        endEncryptloop:
        B startRSAloop

        startDecryptloop:

            #block for decrypt
            #prompt for entering public key n and private key d
            LDR r0, =promptpubkeyn
            BL printf
            
            #scan user input
            LDR r0, =format1
            LDR r1, =inputn
            BL scanf

            LDR r4, =inputn
            LDR r4, [r4]
            CMP r4, #-1
            BEQ endDecryptloop

            LDR r0, =promptprikeyd
            BL printf
            
            #scan user input
            LDR r0, =format1
            LDR r1, =inputd
            BL scanf
            
            LDR r7, =inputd
            LDR r7, [r7]
            CMP r7, #-1
            BEQ endDecryptloop

            MOV r1, r4
            MOV r2, r7
            LDR r0, =outputkey3
            BL printf

            #prompt for and decrypt input cipher
            #call decryptChar
            #

        endDecryptloop:
        B startRSAloop

    endRSAloop:

    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr
.data
    prompttask:.asciz "\nPlease choose a function (enter 1/2/3 or -1 to quit):"
    prompttaskcontent:.asciz "\n1. To generate your public and private keys\n2. To encrypt a message\n3. To decrypt a message\n"
    promptpubkeyn: .asciz "\nPlease enter public key n (enter -1 to quit):"
    promptpubkeye: .asciz "\nPlease enter public key exponent e (enter -1 to quit):"
    promptprikeyd: .asciz "\nPlease enter private key d (enter -1 to quit):"

    format1: .asciz "%d"

    inputtask: .word 0
    inputn: .word 0
    inpute: .word 0
    inputd: .word 0

    outputkey: .asciz "\npublic key n: %d\npublic key e: %d\nprivate key d: %d\n"
    outputkey2: .asciz "\npublic key n: %d\npublic key e: %d\n"
    outputkey3: .asciz "\npublic key n: %d\nprivate key d: %d\n"

#End main
