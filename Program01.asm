TITLE Program 1   (Program1.asm)

; Author: Diana O'Haver
; CS 271 / Program 1               Date: 1/13/2016
; Description: Simple program to output name, program title, instructions, and prompt user for input
;              Also to perform calculations and display a terminating messages

INCLUDE Irvine32.inc

.data

; strings for commands/instructions
myName BYTE "Name: Diana O'Haver", 0dh, 0ah, 0
progTitle BYTE "Program title: Program 1", 0dh, 0ah, 0
instructions BYTE "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, ", 0dh, 0ah
	BYTE "and remainder.", 0dh, 0ah, 0
ecInstr BYTE "**EC: Validate the second number to be less than the first.", 0	

prompt1 BYTE "Please enter your first number: ", 0
prompt2 BYTE "Please enter your second number: ", 0
bye BYTE "Impressed? Bye!", 0
notValid BYTE "The second number must be less than the first!", 0

addedOutput BYTE "Your numbers added together: ", 0
subOutput BYTE "Your numbers subtracted from each other: ", 0
prodOutput BYTE "Your numbers multiplied together: ", 0
quoOutput BYTE "The quotient of your numbers is: ", 0
remOutput BYTE "The remainder from your numbers is: ", 0

; symbols to better align with example execution
plus BYTE " + ", 0
minus BYTE " - ", 0
mult BYTE " * ", 0
divide BYTE " / ", 0
equal BYTE " = ", 0
remain BYTE " remainder ", 0

; variables for user input
numOne SDWORD ?																					
numTwo SDWORD ?

; variables to hold calculated values
added DWORD ?
subtracted DWORD ?
multiplied DWORD ?
remainder DWORD ?
quotient DWORD ?

.code
main PROC

; display name, program title, and instructions using example provided on page 169
	mov edx,OFFSET myName
	call WriteString

	mov edx,OFFSET progTitle
	call WriteString
	call CrLf

	mov edx,OFFSET instructions
	call WriteString
	call CrLf

	mov edx, OFFSET ecInstr
	call WriteString
	call CrLf
	call CrLf

	mov edx,OFFSET prompt1
	call WriteString

; read in input from keyboard - example on page 166 of textbook
	call ReadInt
	mov numOne, eax
	call CrLf

	mov edx,OFFSET prompt2
	call WriteString

; read in second input
	call ReadInt
	mov numTwo, eax
	call CrLf

; validate input and jump to error if found
	mov ebx, numOne
	mov ecx, numTwo
	cmp ebx, ecx					; check if left is greater than right
	jb L1							; drop down to error message if not


; ADDITION
	mov eax, numOne					; move the first input to eax
	call WriteDec					; print out first value
	mov edx, OFFSET plus			; print out symbol
	call WriteString
	mov eax, numTwo					; move second input to eax for output
	call WriteDec					; print out second value
	mov edx, OFFSET equal			; print out equal sign
	call WriteString
	add eax, numOne					; add numTwo currently held in eax to numOne
	mov added, eax					; move sum of two values to variable for storage

	mov eax, added
	call WriteDec
	call CrLf

; SUBTRACTION
	mov eax, numOne
	call WriteDec
	mov edx, OFFSET minus
	call WriteString
	mov eax, numTwo
	call WriteDec
	mov edx, OFFSET equal
	call WriteString
	mov eax, numOne				; move numOne back to eax
	sub eax, numTwo				; subtract numTwo from numOne
	mov subtracted, eax			; move result to subtracted

	mov eax, subtracted
	call WriteDec
	call CrLf

; MULTIPLICATION - example on page 256
	mov eax, numOne
	call WriteDec
	mov edx, OFFSET mult
	call WriteString
	mov eax, numTwo				; move numTwo to eax for output to console
	call WriteDec
	mov eax, numOne				; move numOne back for multiplication
	mov ebx, numTwo
	mul ebx

	mov edx, OFFSET equal
	call WriteString
	call WriteDec
	call CrLf

; DIVISION - finding quotient, example on page 262
	mov eax, numOne
	call WriteDec
	mov edx, OFFSET divide
	call WriteString
	mov eax, numTwo		
	call WriteDec
	mov eax, numOne
	mov ebx, numTwo
	sub edx, edx		; set edx to zero - integer overflow error fix from stack overflow
	div ebx

; move quotient and remainder to their own variables
	mov quotient, eax
	mov remainder, edx

; output quotient
	mov edx, OFFSET equal
	call WriteString
	mov eax, quotient
	call WriteDec

; output remainder
	mov edx, OFFSET remain
	call WriteString
	mov eax, remainder
	call WriteDec
	call CrLf
	call CrLf

; say goodbye
	jmp L2

	L1: 
		mov edx, OFFSET notValid
		call WriteString
		call CrLf
		call CrLf

	L2: 
		mov edx, OFFSET bye
		call WriteString

	exit	; exit to operating system
main ENDP

END main
