TITLE Fibonacci Numbers     (Assignment2.asm)

; Author: Sheng Bian
; Course / Project ID CS271 / Assignment 2     Date: January 27, 2018
; Description: This program is used to calculate Fibonacci numbers. It will first display program
; title and programmer's name. Then it gets the user's name and greet the user. It prompts the user
; to enter the number of Fibonacci terms to be displayed in the range [1 .. 46]. The user input will
; be validated. Then it calculates and diaplays the required Fibonacci numbers. It ends with a 
; terminating message.

INCLUDE Irvine32.inc

MIN = 1								;constant to store the maximum number of range
MAX = 46							;constant to store the minimum number of range

.data
intro_1			BYTE	"Fibonacci Numbers", 0
intro_2			BYTE	"Programmed by Sheng Bian", 0
prompt_1		BYTE	"What's your name? ", 0
intro_3			BYTE	"Hello, ", 0
intro_4			BYTE	"Enter the number of Fibonacci terms to be displayed", 0
intro_5			BYTE	"Give the number as an integer in the range [1 .. 46].", 0
prompt_2		BYTE	"How many Fibonacci terms do you want? ", 0
errorMg			BYTE	"Out of range.  Enter a number in [1 .. 46]", 0
space			BYTE	"      ", 0
resultMessage	BYTE	"Results certified by Sheng Bian", 0
goodBye			BYTE	"Goodbye, ", 0
period			BYTE	".", 0
userName		BYTE 33 DUP (0)		;string to be entered by user
terms			DWORD	?			;number of Fibonacci terms to be displayed
numOne			DWORD	?			;one number used to store Fibonacci number
numTwo			DWORD	?			;another number used to store Fibonacci number
row				DWORD	0			;count the number of numbers in one row

.code
main PROC
introduction:
; Display program title and my name
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

; Get user's name 
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

; Greet the user
	mov		edx, OFFSET intro_3
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLF

userInstructions:
; Prompt the user to enter Fibonacci terms
	mov		edx, OFFSET intro_4
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_5
	call	WriteString
	call	CrLf
	call	CrLf

getUserData:
; Get user input
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		terms, eax

; Validate user input
	cmp		eax, MIN
	jl		error
	cmp		eax, MAX
	jg		error
	jmp		displayFibs

error:	
; display error message and get user input again
	mov		edx, OFFSET	errorMg
	call	WriteString
	call	CrLf
	jmp		getUserData

displayFibs:
; if user input is 1
	mov		eax, 1
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	inc		row
	cmp		terms, 1
	je		farewell
	dec		terms

; if user input is more than 1
; initialize numOne, numTwo and loop control
	mov		numOne, 0	
	mov		numTwo, 1
	mov		ecx, terms

; Calculate and display required Fibonacci numbers
fibLoop:
	mov		eax, numOne
	mov		ebx, numTwo
	add		eax, ebx 
	call	WriteDec
	mov		numTwo, eax
	mov		numOne, ebx
	mov		edx, OFFSET space
	call	WriteString
	inc		row
	cmp		row, 5
	jl		continueLoop
	call	CrLf
	mov		row, 0
continueLoop:
	loop	fibLoop

farewell:
; End of result
	call	CrLf
	call	CrLf
	mov		edx, OFFSET resultMessage
	call	WriteString
	call	CrLf

; Display terminating message
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
