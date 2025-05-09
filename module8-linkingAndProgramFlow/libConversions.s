#
# Program name: libConversions.s

# Author: S.Lee
# Date: 3/15/2025
# Purpose: This is a library of functions to be called by other program 
#

.global miles2km

.text
miles2km:
    # r0 = r0*161/100
    
    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
    
    #calculate the miles
    MOV r1, #161
    MUL r0, r0, r1
    MOV r1, #100
    BL __aeabi_idiv

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
#End miles2km

.global kph

.text
kph:
    # r0 = (r0*161/100)/r1
    
    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
    
    #store hours at r2 temporarily
    MOV r4, r1
    #calculate the miles
    BL miles2km
    #move back hours from r2 to r1 and calculate the kmh
    MOV r1, r4
    BL __aeabi_idiv

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
#End kph

.global CToF

.text
CToF:
    # r0 = (r0*9/5)+32
    
    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
    
    #calculate the fahrenheit
    MOV r1, #9
    MUL r0, r0, r1
    MOV r1, #5
    BL __aeabi_idiv
    MOV r1, #32
    ADD r0, r0, r1

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
#End CToF

.global InchesToFt

.text
InchesToFt:
    # r0 = (r0/12)
    # r1 = r0 mod 12
    
    #push stack
    SUB sp, sp, #4
    STR lr, [sp]
    
    #calculate the number of feet
    MOV r4, r0
    MOV r1, #12
    BL __aeabi_idiv
    
    MUL r2, r1, r0
    SUB r1, r4, r2

    #pop stack
    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
#End InchesToFt
