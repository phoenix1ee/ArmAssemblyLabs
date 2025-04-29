
.text
.global main
main:
    #program library:
    #r4: modulus n = p*q
    #r5: modulus totient / phi n = (p-1)*(q-1)
    #r6: public key e
    #r7: private key d

    SUB sp, sp, #4
    STR lr, [sp]
    
    #print the prompt to user
    LDR r0, =promptCont
    BL printf
    
    #scan user input
    LDR r0, =format1
    LDR r1, =input
    BL scanf

    #scan user input
    LDR r0, =format1
    LDR r1, =input2
    BL scanf

    #scan user input
    LDR r0, =format1
    LDR r1, =input3
    BL scanf

    LDR r0, =input
    LDR r0, [r0]
    LDR r1, =input2
    LDR r1, [r1]
    LDR r2, =input3
    LDR r2, [r2]
    
    BL decryptChar
    #BL euclidmod


    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    promptCont: .asciz "Please enter 3 number.\n: "
    promptError: .asciz "\nInput is not valid.\n\n"

    format1: .asciz "%d"
    input: .word 0
    input2: .word 0
    input3: .word 0

    outputYes: .asciz "\nNumber %d is prime.\n\n"
    outputNo: .asciz "\nNumber %d is not prime.\n\n"
    output1: .asciz "\noutput is %d.\n\n"
    output2: .asciz "\nd is %d e is %d n is %d.\n\n"

#End main
