
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
    LDR r0, =promptfile
    BL printf
    
    #scan user input
    LDR r0, =format1
    LDR r1, =filename
    BL scanf

    #create file descriptor
    LDR r0, =filename
    MOV r1, #0
    MOV r7, #5
    SWI #0
    
    MOV r4, r0
    
    #read into memory, successful byte read returned at r0
    MOV r0, r4
    LDR r1, =outc
    MOV r2, #1
    MOV r7, #3
    SWI #0
    
    #print r1
    MOV r1, r0
    LDR r0, =outputYes
    BL printf
        
    #print
    LDR r1, =outc
    LDRB r1, [r1]
    LDR r0, =outputYes
    BL printf
    
    MOV r0, r4
    MOV r7, #6
    SWI #0
    
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    promptfile: .asciz "Filename:??"
    filename: .word 40

    format1: .asciz "%s"
    
    outc: .byte
    outputYes: .asciz "content: %d\n"


#End main
