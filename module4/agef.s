#
# Program name: agetab.s

# Author: Shun Fai Lee
# Date: 2/15/2025
# Purpose: This program is to use scanf to get use input of their age as integer and print input by user with tab before
#          and after number
# Input:
#   - input: User entered number
# Output:
#   - format: prints the number
# Remarks: for assignmentxxxxxxx
#

.text
.global main
main:
    #push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
    
    #print a prompt
    LDR r0, = prompt1
    BL printf

    #use scanf to read the input age
    #LDR r0, =format1
    #LDR r1, =age
    #BL scanf
    
    #print the output age
    LDR r0, =output1
    LDR r1, =age
    LDR r1, [r1, #0]
    BL printf

    #pop the stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
.data
    #Prompt user to input their age
    prompt1: .asciz "Hello user, What is your age?\n"
    #Format for input (read a number)
    format1: .asciz "%f"
    #reserves space in the memory for age
    age:     .float  2.5
    #Format of the program output
    output1: .asciz "Your age is \t%f\t.\n"
#End main
