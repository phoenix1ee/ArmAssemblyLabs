.text
.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]

    LDR r0, =formatString
    LDR r1, =name
    LDR r2, =name2
    MOV r3, #35
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    formatString: .asciz "Hello %s, I am %s. Are you %d years old?\n"
    name: .asciz "morpheus"
    name2: .asciz "leo"
#End main
