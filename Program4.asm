TITLE Composite Numbers     (Program4.asm)

; Author: Sheng Bian
; Course / Project ID: CS271 / Program 4          Date:February 15, 2018
; Description: This program will instruct user to enter the number of composites to be displayed
; and prompt user to enter an integer in the range [1...400]. The user enters a number, n, and the 
; program verifies that 1<=n<=400. If n is out of range, the user is reprompted until s/he enters a
; value in the specific range. The program then calculates and display all of the composite.

INCLUDE Irvine32.inc
MIN = 1								;constant to store the minimum number of range
MAX = 400							;constant to store the maximum number of range

.data
intro_1			BYTE	"Composite Numbers			Programmed by Sheng Bian", 0
intro_2			BYTE	"Enter the number of composite numbers you would like to see.", 0
intro_3			BYTE	"I'll accept orders for up to 400 composites", 0
prompt			BYTE	"Enter the number of composites to display [1...400]: ", 0
errorMessage	BYTE	"Out of range. Try again.", 0
goodBye			BYTE	"Results certified by Sheng Bian. Goodbye.", 0
space			BYTE	"    ", 0
userInput		DWORD	?			;number used to store user input
counter			DWORD	0			;number used to count the how many factors of the number
number			DWORD	0			;the number of composite numbers have already printed out
numerator		DWORD	1			;numerator to find if the current number can be evenly divided
divisor			DWORD	?			;divisor to find if the current number can be evenly divided
line			DWORD	0			;number to store the number of composites in one line

.code
main PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
introduction PROC

; Display introduction line 1
	mov		edx, OFFSET intro_1
	call	WriteString
	call	Crlf
	call	Crlf
; Display introduction line 2
	mov		edx, OFFSET intro_2
	call	WriteString
	call	Crlf
; Display introduction line 3
	mov		edx, OFFSET intro_3
	call	WriteString
	call	Crlf
	call	Crlf

	ret
introduction ENDP

;Procedure to get the number of composites to display.
;receives: none
;returns: user input value for global variable userInput
;preconditions:  none
;registers changed: eax, edx
getUserData PROC

; get an integer for number
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt
	mov		userInput, eax
	call	validate		

	ret
getUserData ENDP

;Procedure to validate user input in the range [1...400].
;receives: none
;returns: none
;preconditions:  global variable userInput
;registers changed: edx
validate PROC

; Validate the user input to be in [1...400]
	cmp		eax, MAX
	jg		error
	cmp		eax, MIN
	jl		error
	call	Crlf
	ret

; display error message
error:
	mov		edx, OFFSET errorMessage
	call	WriteString
	call	Crlf
	call	getUserData

	ret
validate ENDP

;Procedure to print out all the composites based on user input.
;receives: userInput
;returns: none
;preconditions:  valid golbal variable userInput
;registers changed: eax, edx
showComposites PROC

; This is a while style loop rather than a counting loop!	
outerLoop:
	mov		eax, number
	cmp		eax, userInput
	jge		theOver
	mov		counter, 0
	mov		divisor, 1
	call	isComposite

; if the number is composite, print it out
printNum:
	mov		eax, counter
	cmp		eax, 2
	jle		toOuterLoop
	mov		eax, numerator
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	inc		number
	inc		line
	mov		eax, line
	cmp		eax, 10
	jl		toOuterLoop
	call	Crlf
	mov		line, 0

toOuterLoop:
	inc		numerator
	jmp		outerLoop

theOver:	
	ret
showComposites ENDP

;Procedure to check if current number is composite or not. When the counter is greater than 2, it's composite number.
;receives: divisor and numerator
;returns: global variable counter
;preconditions: current number is updated
;registers changed: eax, ebx, edx
isComposite PROC
	
; inner counting Loop to check if the current number is composite or not
	mov		ecx, numerator
innerLoop:
	mov		eax, numerator
	mov		ebx, divisor
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	jne		notEqual
	inc		counter
notEqual:
	inc		divisor
	loop	innerLoop
	
	ret
isComposite ENDP

;Procedure to display a parting message.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
farewell PROC

; Display a parting message
	call	Crlf
	call	Crlf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	Crlf

	ret
farewell ENDP

END main
