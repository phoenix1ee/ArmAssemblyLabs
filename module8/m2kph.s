#
# Program name: m2kph.s

# Author: Shun Fai Lee
# Date: 3/15/2025
# Purpose: This program is to use scanf to get user input of a number of miles and hours and convert it to km/h 
# Input:
#   - input: User entered a number in miles and a number in hours
# Output:
#   - format: print the correspoding number in km per hour
# Remarks: for assignment8
#

.global main
main:
    SUB sp, sp, #4
    STR lr, [sp]
    #print the prompt to user
    LDR r0, =prompt1
    BL printf
    
    #scan user input of miles
    LDR r0, =format1
    LDR r1, =num1
    BL scanf

    #scan user input of hours
    LDR r0, =format1
    LDR r1, =num2
    BL scanf
    
    LDR r0, =num1
    LDR r0, [r0]
    LDR r1, =num2
    LDR r1, [r1]
    BL kph 

    #print the output message
    MOV r1, r0
    LDR r0, =output1
    BL printf

    LDR lr, [sp]
    ADD sp, sp, #4
    MOV pc, lr
.data
    prompt1: .asciz "What is the distance in miles and hours?(separate with space)\n:"
    format1: .asciz "%d"
    num1: .word 0
    num2: .word 0
    output1: .asciz "The km/h is %d.\n"
#End main
