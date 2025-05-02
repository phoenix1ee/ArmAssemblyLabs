#
# Program name: rsaAlgo.s

# Author: Section 82 Team 5
# member: Shun Fai Lee
#         Kat Russell
# Date: 4/30/2025
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
            BEQ endGenKeys1
    
            #calculate public key and store n and totient at r4 and r5
            BL cpubexp
            MOV r4, r0
            MOV r5, r1

            #prompt for public key e and store at r6
            MOV r0, r5
            BL legitE
            CMP r0, #-1
            BEQ endGenKeys1
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
            B endGenKeys2

        endGenKeys1:
        B startRSAloop

        endGenKeys2:
        #prompt for how to use the keys
        LDR r0, =promptafterkeygen
        BL printf

        #scan the input
        LDR r0, =format2
        LDR r1, =inputtask
        BL scanf

        #load input to r0
        LDR r0, =inputtask
        LDRB r0, [r0]
        CMP r0, #0x59
        BEQ prepareToEncrypt
        CMP r0, #0x79
        BEQ prepareToEncrypt
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

            prepareToEncrypt:

            #prompt for file
            LDR r0, =prompt4enfile
            BL printf

            LDR r0, =fmt_scan
            LDR r1, =input_buf
            BL scanf

            #call encrypter
            LDR r0, =input_buf
            MOV r1, r6
            MOV r2, r4
            BL     encrypt_file
            CMP    r0, #-1
            BEQ    encryptFail               @ on error, print error message
            MOV r12, r0
            LDR r0, =fmt_filename
            MOV r1, r12
            BL printf
            LDR r0, =outputendone
            BL printf
            B endEncryptloop

            encryptFail:
            LDR r0, =outputenfail
            BL printf
            B endEncryptloop
            
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

            #prompt for file
            LDR r0, =prompt4defile
            BL printf

            LDR r0, =fmt_scan
            LDR r1, =input_buf
            BL scanf

            #call decrypter
            LDR r0, =input_buf
            MOV r1, r7
            MOV r2, r4
            BL decrypt_file
            CMP    r0, #-1
            BEQ    decryptFail               @ on error, print error message

            MOV r12, r0
            LDR r0, =fmt_filename
            MOV r1, r12
            BL printf

            LDR r0, =outputdedone
            BL printf
            B endDecryptloop

            decryptFail:
            LDR r0, =outputdefail
            BL printf
            B endDecryptloop

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
    promptafterkeygen: .asciz "\nDo you want to use your keys to encrypt a file? (enter Y/y to continue or any other keys to quit) :"
    prompt4enfile: .asciz "\nEnter input file path for encryption:"
    prompt4defile: .asciz "\nEnter input file path for decryption:"

    format1: .asciz "%d"
    format2: .asciz "%s"
    fmt_scan: .asciz "%255s"
    fmt_filename: .asciz "%s"

    inputtask: .word 0
    inputn: .word 0
    inpute: .word 0
    inputd: .word 0

    input_buf: .space 256

    outputkey: .asciz "\npublic key n: %d\npublic key e: %d\nprivate key d: %d\n"
    outputkey2: .asciz "\npublic key n: %d\npublic key e: %d\n"
    outputkey3: .asciz "\npublic key n: %d\nprivate key d: %d\n"
    outputendone: .asciz " is generated.\n"
    outputenfail: .asciz "\nEncrypt is not successful. Please check your input file and/or keys.\n"
    outputdedone: .asciz " is generated.\n"
    outputdefail: .asciz "\nDecrypt is not successful. Please check your input file and/or keys.\n"

#End main
