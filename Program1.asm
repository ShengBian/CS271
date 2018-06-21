TITLE Elementary Arithmetic     (Assignment1.asm)

; Author: Sheng Bian
; Course / Project ID: CS271 / Programming Assignment #1    Date: January 20, 2018 
; Description: This program will first introduce the programmer name and program title on the screen. Then 
;	it prompts the user to enter two numbers and  calculates the sum, difference, product, (integer) quotient 
;	and remainder of the numbers. Finally, it displays the results and ends with a terminating message.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
intro_1			BYTE	"		Elementary Arithmetic		by Sheng Bian", 0
intro_2			BYTE	"**EC: Program verifies second number less than first", 0
prompt_1		BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
prompt_2		BYTE	"First number: ", 0
firstNumber		DWORD	?		;first number to be entered by user
prompt_3		BYTE	"Second number: ", 0
secondNumber	DWORD	?		;second number to be entered by user
exMessage		BYTE	"The second number must be less than the first!", 0
sum				DWORD	?		;sum of the numbers
difference		DWORD	?		;difference of the numbers
product			DWORD	?		;product of the numbers
quotient		DWORD	?		;quotient of the numbers
remainder		DWORD	?		;remainder of the numbers
plus			BYTE	" + ", 0
minus			BYTE	" - ", 0
multiplication	BYTE	" ¡Á ", 0
Subtraction		BYTE	" ¡Â ", 0
equal			BYTE	" = ", 0
result_1		BYTE	" remainder ", 0
goodBye			BYTE	"Impressed?	Bye!", 0

.code
main PROC

;Display my name and program title
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

;Display extra credut option
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

;Display instructions
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	call	CrLf

;Get the first number from user
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		firstNumber, eax

;Get the second number from user
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	ReadInt
	mov		secondNumber, eax
	call	CrLf

;Compare the first number and the second number
	mov		eax, secondNumber
	cmp		eax, firstNumber
	jl		L1

;If the second number is greater or equal to the first number, display extra credit message
	mov		edx, OFFSET exMessage
	call	WriteString
	call	CrLf
	call	CrLf
	jmp		L2

;If the second number is less than the first number, do the calculation
L1:
;Calculate the sum
	mov		eax, firstNumber
	add		eax, secondNumber
	mov		sum, eax

;Calculate the difference
	mov		eax, firstNumber
	sub		eax, secondNumber
	mov		difference, eax

;Calculate the product
	mov		eax, firstNumber
	mov		ebx, secondNumber
	mul		ebx
	mov		product, eax

;Calculate the quotient and remainder
	mov		edx, 0
	mov		eax, firstNumber
	mov		ebx, secondNumber
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

;Display the result of sum
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

;Display the result of difference
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf

;Display the result of product
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET multiplication
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf

;Display the result of quotient and remainder
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET Subtraction
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf
	call	CrLf

L2:
;Say goodbye
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit	
main ENDP

END main
