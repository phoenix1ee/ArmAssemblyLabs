.text
.global main
main:
    SUB sp, sp, #12
    STR lr, [sp]

    LDR r0, =prompt1
    BL printf

    LDR r0, = format1
    LDR r1, = num1
    BL scanf

    LDR r4, =num1
    LDR r4, [r4]
    MOV r2, r4
    MOV r0, r4
    MOV r1, #60
    BL __aeabi_idiv
    #hours
    MOV r3, r0

    MUL r1,r1,r3
    SUB r2, r4, r1
    MOV r1, r3
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #12
    MOV pc, lr
.data
    prompt1: .asciz "What is the minute?\n:"
    format1: .asciz "%d"
    num1: .word 0
    output1: .asciz "It is %d hours and %d minutes.\n"
    num2: .word 0
#End main
