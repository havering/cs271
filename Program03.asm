TITLE Program 3    (Program03ohaverd.asm)

; Author: Diana O'Haver
; CS 271 / Program 3                 Date: 1/31/2016
; Description: This program will prompt the user to enter a number. The number will be validated to be between -100 and -1.
;			   The user will be repeatedly prompted and the valid numbers will be accumulated until a non-negative number is entered.
;			   The average of the entered numbers will be calculated and displayed. 
;			   The number of negative numbers entered will also be displayed, as well as the sum of them, and a parting message.

INCLUDE Irvine32.inc

; constants - max and min for input to be validated against
MAX = -1
MIN = -100
MAXNAME = 80

.data

; strings for commands/instruction
progTitle BYTE "Program Title: Program Assignment 3", 0
myName BYTE "Programmer: Diana O'Haver", 0
getName BYTE "Please enter your name: ", 0
helloName BYTE "Hello, ", 0
excl BYTE "!", 0
instructions BYTE "You will be entering a series of negative numbers. The numbers should", 0dh, 0ah
			BYTE "be between -100 and -1. When you are finished entering numbers, enter a", 0dh, 0ah
			BYTE "positive number. Your results will be calculated.", 0
prompt BYTE "Please begin entering your numbers:", 0
tooLow BYTE "That number is too low. Please try again.", 0
noNumbers BYTE "You did not enter any negative numbers.", 0
amountNumbers1 BYTE "You entered ", 0
amountNumbers2 BYTE " negative numbers.", 0
sumOfNumbers BYTE "The sum of your negative numbers is: ", 0
averageOfNumbers BYTE "The average of your numbers, rounded, is: ",0
goodbye BYTE "Goodbye, ", 0
space BYTE ": ", 0
extra BYTE "** EC: EXTRA CREDIT OPTION 1, NUMBER THE LINES DURING USER INPUT", 0

; variables for user input
userName BYTE MAXNAME+1 DUP (?)				; room for null with +1
total SDWORD 0								; variable to hold running total of numbers - starting at 0
current SDWORD ?							; variable to hold currently entered number
average SDWORD ?							; variable to hold average of all numbers
numNeg SDWORD 0								; variable to hold the number of negative numbers entered - starting at 0
remainder SDWORD ?							; variable to hold the remainder for rounding purposes
cutoff SDWORD 0.5							; cutoff for rounding
lineNumber SDWORD 0							; variable to be incremented and output for extra credit line numbering

.code
main PROC

; display name, program title, extra credit option
	mov edx, OFFSET progTitle
	call WriteString
	call CrLf

	mov edx, OFFSET myName
	call WriteString
	call CrLf
	call CrLf

	mov edx, OFFSET extra
	call WriteString
	call CrLf
; get the user's data
; prompt for user input
	mov edx, OFFSET getName
	call WriteString
	call CrLf

; read in user's name - example from http://programming.msjc.edu/asm/help/source/irvinelib/readstring.htm
	mov edx, OFFSET userName
	mov ecx, MAXNAME				; buffer size - 1
	call ReadString
	call CrLf

; output greeting and user's name
	mov edx, OFFSET helloName
	call WriteString
	mov edx, OFFSET userName
	call WriteString
	mov edx, OFFSET excl
	call WriteString
	call CrLf
	call CrLf

; display instructions for the user
	mov edx, OFFSET instructions
	call WriteString
	call CrLf
	call CrLf

; repeatedly prompt the user for a number and validate the number
	mov edx, OFFSET prompt
	call WriteString
	call CrLf

getNums:
	; output line numbers as part of extra credit
	mov eax, lineNumber
	call WriteDec
	mov edx, OFFSET space
	call WriteString
	
	; increment line number with each loop
	inc eax
	mov lineNumber, eax

	; then read in the number from the user
	call ReadInt
	cmp eax, 0					; is the number not a negative? 
	jge doneEntering			; if the number is greater than or equal to 0, done entering numbers
	cmp eax, MIN				; don't need to validate if number is too big - if it is, the user is done entering numbers
	jb numSmall					; if below -100, jump to error message

	; if it makes it here, then the number is a valid negative number
	inc numNeg					; increment the number of negative numbers entered
	mov current, eax			; move the number to current
	mov eax, total				; move the running total to eax
	add eax, current			; add current to the running total
	mov total, eax				; move new running total to the variable 
	jmp getNums					; return to top of loop for next number

doneEntering:
; handle the case that no negative numbers were entered and skip all the below
	cmp numNeg, 0
	je noEntry

; first output the number of numbers entered
	call CrLf
	mov edx, OFFSET amountNumbers1
	call WriteString
	mov eax, numNeg
	call WriteDec
	mov edx, OFFSET amountNumbers2
	call WriteString
	call CrLf

; calculate the average
	mov eax, total
	cdq
	mov ebx, numNeg
	idiv ebx
	mov average, eax			; move quotient to average
	mov remainder, edx			; move remainder to save for later

; figure out if the number should be rounded up or down
	mov eax, remainder
	cmp eax, cutoff
	jle sendAverage				; if 0.5 or less, jump to sendAverage
	jg roundUp					; if greater than 0.5, jump to the rounding up part


; if remainder is greater than 0.5, increment average to round up
; integer will be rounded down by default otherwise
roundUp:
	mov eax, average
	dec eax						; NOT inc to round, since we are using negative numbers
	mov average, eax
	jmp sendAverage

sendAverage:
; then output the average
	mov edx, OFFSET averageOfNumbers
	call WriteString
	mov eax, average
	call WriteInt
	call CrLf

; then output the sum
	mov edx, OFFSET sumOfNumbers
	call WriteString
	mov eax, total				; move running (and now final) total to eax
	call WriteInt
	call CrLf
	call CrLf
	jmp farewell				; skip over the rest and go to the end of the program
	
numSmall:
	mov edx, OFFSET tooLow
	call WriteString
	call CrLf
	call CrLf
	jmp getNums

; if user didn't enter any numbers, skip everything but notification of that
noEntry: 
	mov edx, OFFSET noNumbers
	call WriteString
	call CrLf
	call CrLf
	jmp farewell
	
farewell:
	mov edx, OFFSET goodbye
	call WriteString
	mov edx, OFFSET userName
	call WriteString
	mov edx, OFFSET excl
	call WriteString

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
