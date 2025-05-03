
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

    LDR r4, =input
    LDR r4, [r4]
    LDR r5, =input2
    LDR r5, [r5]
    LDR r6, =input3
    LDR r6, [r6]
    MOV r7, #0

    starttest:
    CMP r7, #127
    BGT endtest
    LDR r0, =output3
    MOV r1, r7
    BL printf
    MOV r0, r7
    MOV r1, r4
    MOV r2, r6
    BL euclidmod
    MOV r8, r0

    MOV r0, r8
    MOV r1, r5
    MOV r2, r6
    BL euclidmod
    MOV r1, r0
    LDR r0, =output4
    BL printf
    ADD r7, r7, #1
    B starttest
    endtest:
    
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
    output3: .asciz "%d "
    output4: .asciz "%d \n"


#End main
