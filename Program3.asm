TITLE Integer Accumulator     (Program3.asm)

; Author: Sheng Bian
; Course / Project ID: CS271 / Program 3       Date: February 10, 2018
; Description: This program get the user's name and greet the user. It repeatedly prompts
; user to enter a number in [-100, -1]. It will count and accumulate the valid user numbers
; until a non-negative number is entered. If user entered a non-negative number, the program
; will display the number of negative numbers entered, the sum and the average of all valid 
; numbers. It will end with a parting message.

INCLUDE Irvine32.inc
MIN = -100							;constant to store the minimum number of range
MAX = -1							;constant to store the maximum number of range
ZERO = 0							;constant to store zero

.data
intro_1			BYTE	"Welcome to the Integer Accumlator by Sheng Bian", 0
prompt_1		BYTE	"What's your name? ", 0
intro_2			BYTE	"Hello, ", 0
intro_3			BYTE	"Please enter numbers in [-100, -1].", 0
intro_4			BYTE	"Enter a non-negative number when you are finished to see results.", 0
prompt_2		BYTE	"Enter number: ", 0
countMessage_1	BYTE	"You entered ", 0
countMessage_2	BYTE	" valid numbers.", 0
sumMessage		BYTE	"The sum of your valid numbers is ", 0
avgMessage		BYTE	"The rounded average is ", 0
errorMessage	BYTE	"The number entered is less than -100. Please enter numbers in [-100, -1].", 0
specialMessage	BYTE	"No negative number is entered!", 0
goodBye			BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
period			BYTE	".", 0
userName		BYTE 33 DUP (0)		;string to be entered by user
count			DWORD	0			;number used to count the number of negative numbers entered
sum				DWORD	0			;number used to display the sum of negative numbers entered
avg				DWORD	?			;number used to display the average of negative numbers entered

.code
main PROC
introduction:
; Display program title and programmer's name
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

; Get the user's name 
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

; greet the user
	mov		edx, OFFSET intro_2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf

userInstructions:
; Display the introduction for the user
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_4
	call	WriteString
	call	CrLf

getUserData:
; Repeatedly prompt the user to enter a number
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt

; Validate the user input to be in [-100, -1]	
	cmp		eax, MAX
	jg		displayResults
	cmp		eax, MIN
	jl		error

; Count and accumulate the valid user numbers
	add		eax, sum
	mov		sum, eax
	inc		count
	jmp		getUserData

error:
; Display error message whem user enter number less than -100
	mov		edx, OFFSET errorMessage
	call	WriteString
	call	CrLf
	jmp		getUserData
	
displayResults:
; If no negative numbers were entered, jump to special message
	mov		eax, count
	cmp		eax, ZERO
	je		special

; Display the number of negative number entered
	mov		edx, OFFSET countMessage_1
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET countMessage_2
	call	WriteString
	call	CrLf

; Display the sum of negative numbers entered
	mov		edx, OFFSET sumMessage
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

; Calculate the average of negative numbers entered
	mov		edx, 0
	mov		eax, sum
	mov		ebx, count
	cdq
	idiv	ebx
	mov		avg, eax

; Display the average of negative numbers, rounded to nearest integer
	mov		edx, OFFSET avgMessage
	call	WriteString
	mov		eax, avg
	call	WriteInt
	call	CrLf
	jmp		farewell

special:
; Display a special message
	mov		edx, OFFSET specialMessage
	call	WriteString
	call	CrLf

farewell:
; Display a parting message
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
