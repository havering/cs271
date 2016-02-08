TITLE Program 2     (Program02.asm)

; Author: Diana O'Haver
; CS 271 / Project 2            Date: 1/24/2016
; Description: Program to calculate n Fibonacci numbers as entered by user
;			   Program also should greet and bid farewell to user, and validate user input

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; strings for commands/instructions
progTitle BYTE "Program Title: Program Assignment 2", 0
myName BYTE "Programmer: Diana O'Haver", 0
getName BYTE "Please enter your name: ", 0
helloName BYTE "Hello, ", 0
numConstraints BYTE "You will be entering an integer between 1 and 46.", 0
enterNum BYTE "Please enter the number of Fibonacci terms to be displayed: ", 0
goodbyeName BYTE "Goodbye, ", 0
resultOutput BYTE "The Fibonacci numbers up to your entered number are: ", 0
excl BYTE "!", 0

; strings for data validation
tooBig BYTE "That is too many numbers.", 0
tooSmall BYTE "That is not enough numbers.", 0

; strings for formatting
spaces BYTE "     ", 0			; results should be displayed 5 terms per line with at least 5 spaces between terms

; variables for user input
MAX = 80						; max characters to read 
UPPERFIB = 46					; for validation later - only allowed up to 46th fibonacci number
LOWERFIB = 1					; for validation later - must enter at least 1 number to calculate
userName BYTE MAX+1 DUP (?)		; room for null with +1
fibNum SDWORD ?					; number of fibonacci numbers to output, chosen by user

; variables for output
prev SDWORD ?					; iterative fibonacci calculation from http://www.codeproject.com/Articles/21194/Iterative-vs-Recursive-Approaches
prevPrev SDWORD ?
result SDWORD ?
counter SDWORD ?				; to hold counter to ensure only 5 values per row are output

.code
main PROC

; SECTION A: introduction
; display name, program title
	mov edx, OFFSET progTitle
	call WriteString
	call CrLf

	mov edx, OFFSET myName
	call WriteString
	call CrLf
	call CrLf

; SECTION C: getUserData
; prompt for user input
	mov edx, OFFSET getName
	call WriteString
	call CrLf

; read in user's name - example from http://programming.msjc.edu/asm/help/source/irvinelib/readstring.htm
	mov edx, OFFSET userName
	mov ecx, MAX				; buffer size - 1
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

; SECTION B: userInstructions
; prompt for fibonacci input
getNums: 
	mov edx, OFFSET numConstraints
	call WriteString
	call CrLf
	mov edx, OFFSET enterNum
	call WriteString
	call CrLf
	call ReadInt			; read in number of fibonacci numbers to calculate
	mov fibNum, eax
	call CrLf
	jmp validate

; validate that fibNum is between 1 and 46
validate:
	cmp fibNum, UPPERFIB
	ja numBig				; jump if left is bigger than right
	cmp fibNum, LOWERFIB
	jb numSmall				; jump if left is below right
	jmp calculate			; if it gets here without hitting other jumps, we are good to calculate fibonacci numbers

; if it is too big, output error message and jump back to getNums
numBig: 
	mov edx, OFFSET tooBig
	call WriteString
	call CrLf
	call CrLf
	jmp getNums

; if it is too small, output error message and jump back to getNums
numSmall:
	mov edx, OFFSET tooSmall
	call WriteString
	call CrLf
	call CrLf
	jmp getNums

; SECTION D: displayFibs
; send number to ecx counter for loop - example on page 124
calculate:
	; first compare fibNum to 1 - if it is 1, then the user only wants 1 fibonacci number, which is 1
	cmp fibNum, 1
	je oneValue				; jump to oneValue if fibNum = 1, otherwise continue down to loop

	mov prevPrev, 0
	mov prev, 1
	mov result, 1			; starting with 1 instead of 0 due to input constraints			
	mov counter, 5			; counter starts at 5
	mov eax, prev
	mov ebx, prevPrev
	mov ecx, fibNum

	; output header for the results
	mov edx, OFFSET resultOutput
	call WriteString
	call CrLf

; create loop
	L1: 
		cmp counter, 0		; if counter hits 0, we need to call CrLf to maintain formatting
		jne noJump			; if it isn't equal to 0, skip the formatting lines below and go straight to output

		mov counter, 5
		call CrLf 

		noJump: 
			mov eax, result		; output the latest calculated value
			call WriteDec
			mov edx, OFFSET spaces
			call WriteString
			dec counter			; decrement counter
			mov eax, prev		; move prev to eax
			mov ebx, prevPrev	; move prevPrev to ebx to be added to prev
			add eax, ebx		; add prev and prevPrev
			mov result, eax		; move result of the addition to result
			mov ebx, prev		; move prev to ebx
			mov prevPrev, ebx	; now prevPrev = prev
			mov prev, eax		; now prev = result

		loop L1
		call CrLf
		jmp goodbye

		
oneValue:
	mov edx, OFFSET resultOutput
	call WriteString
	call CrLf
	mov eax, fibNum
	call WriteDec
	call CrLf
	call CrLf
	jmp goodbye

; SECTION E: farewell
goodbye:
	call CrLf
	mov edx, OFFSET goodbyeName
	call WriteString
	mov edx, OFFSET userName
	call WriteString
	mov edx, OFFSET excl
	call WriteString
	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
