TITLE Sorting Random Integers     (Program5.asm)

; Author: Sheng Bian
; Course / Project ID: CS271 / Program 5           Date: March 4, 2018
; Description: This program will instruct user to enter the number of random integers to be displayed
; between 10 to 200. The generated random integers are in the range [100, 900]. The program displays 
; the original list, sorts the list, and calculates the median value. Finally, it displays the list 
; sorted in descending order.

INCLUDE Irvine32.inc
MIN = 10								;constant to store the minimum number of user input
MAX = 200								;constant to store the maximum number of user input
LO = 100								;constant to store the lowest random integer
HI = 999								;constant to store the highest random integer

.data
intro_1				BYTE		"Sorting Random Integers			Programmed by Sheng Bian", 0
intro_2				BYTE		"This program generates random numbers in the range [100 .. 999],", 0
intro_3				BYTE		"displays the original list, sorts the list, and calculates the", 0
intro_4				BYTE		"median value. Finally, it displays the list sorted in descending order.", 0
prompt				BYTE		"How many numbers should be generated? [10 .. 200]: ", 0
errorMeg			BYTE		"Invalid input", 0
resultMeg_1			BYTE		"The unsorted random numbers:", 0
resultMeg_2			BYTE		"The median is ", 0
resultMeg_3			BYTE		"The sorted list:", 0
space				BYTE		"	", 0
userInput			DWORD		?		;number used to store user input
list				DWORD		MAX DUP(?)
line				DWORD		0		;number used to store how many integers in one line


.code
main PROC
	call	Randomize				;Irvine library procedure for generating random numbers
	call	introduction			;introduce the program

	push	OFFSET userInput		;pass userInput by reference
	call	getData					;get values for userInput

	push	OFFSET list				;pass list by reference
	push	userInput				;pass userInput by value
	call	fillArray				;put random numbers in the array

	push	OFFSET list				;pass list by reference
	push	userInput				;pass userInput by value
	push	OFFSET resultMeg_1		;pass resultMeg_1 by reference
	call	displayList				;display unsorted list

	push	OFFSET list				;pass list by reference
	push	userInput				;pass userInput by value
	call	sortList				;sort the list
	
	push	OFFSET list				;pass list by reference
	push	userInput				;pass userInput by value
	push	OFFSET resultMeg_2		;pass resultMeg_2 by reference
	call	displayMedian			;display unsorted list

	push	OFFSET list				;pass list by reference
	push	userInput				;pass userInput by value
	push	OFFSET resultMeg_3		;pass resultMeg_3 by reference
	call	displayList				;display unsorted list


	exit							; exit to operating system
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
; Display introduction line 2
	mov		edx, OFFSET intro_2
	call	WriteString
	call	Crlf
; Display introduction line 3
	mov		edx, OFFSET intro_3
	call	WriteString
	call	Crlf
; Display introduction line 4
	mov		edx, OFFSET intro_4
	call	WriteString
	call	Crlf
	call	Crlf

	ret
introduction ENDP

;Procedure to get userInput from the user
;receives: addresses of userInput
;returns: userInput value
;preconditions:  none
;registers changed: eax, ebx, edx, ebp

getData PROC
	push	ebp						;Set up stack frame
	mov		ebp, esp
	mov		ebx, [ebp+8]			;Get address of userInput into ebx

getUserData:	
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt
	mov		[ebx], eax				;Store user input at address in ebx

; Validate the user input to be in [10, 200]
	cmp		eax, MAX
	jg		error
	cmp		eax, MIN
	jl		error
	jmp		theEnd

error:
; Display error message whem user enter number less than -100
	mov		edx, OFFSET errorMeg
	call	WriteString
	call	CrLf
	jmp		getUserData

theEnd:
	pop		ebp
	ret		4
getData ENDP

;Procedure to fill the array with the random numbers 
;receives: address of list, value of userInput
;returns: an array with random numbers
;preconditions:  address of list, value of userInput
;registers changed: ecx, eax, edi, ebp

fillArray PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12]			;@list in edi
	mov		ecx, [ebp+8]			;value of userInput in ecx
	
again:
; generate a random number in eax
	mov		eax, HI
	sub		eax, LO
	inc		eax
	call	RandomRange
	add		eax, LO

; move random number to array and loop again
	mov		[edi], eax
	add		edi, 4
	loop	again

	pop		ebp
	ret		8
fillArray ENDP


;Procedure to display the list.
;receives: address of list, value of userInput, address of result message 
;returns: print elements of array on the screen
;preconditions: there are values in array
;registers changed: ebp, edi, ecx, eax, edx

displayList PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+16]			;@list in edi
	mov		ecx, [ebp+12]			;value of userInput in ecx
	
; display result message on the screen	
	call	Crlf
	mov		edx, [ebp+8]			;reuslt message in edx
	call	WriteString
	call	Crlf
	mov		line, 0

; display array on the list
again:
	mov		eax, [edi]
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	inc		line
	cmp		line, 10
	jl		notNewLine
	call	Crlf
	mov		line, 0

notNewLine:
	add		edi, 4	
	loop	again

	call	Crlf
	pop		ebp
	ret		12

displayList ENDP

;Procedure to sort the list in descending order
;receives: address of list, value of userInput
;returns: sorted array
;preconditions:  there are values in array
;registers changed: ebp, esp, ecx, edi, ebx, edx, eax, esi

sortList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]			;value of userInput in ecx
	mov		edi, [ebp+12]			;@list in edi	
	dec		ecx						;ecx=request-1 
	mov		ebx, 0

; use selection sort to sort the array
outerloop:
	mov		eax, ebx				;eax=i, i=k
	mov		edx, eax				;j=k
	inc		edx						;edx=j, j=k+1
	push	ecx
	mov		ecx, [ebp+8]			;ecx=request
	
innerloop:
	mov		esi, [edi+edx*4]		;array[j]
	cmp		esi, [edi+eax*4]		;compare array[j] and array[i]
	jle		continueInnerloop
	mov		eax, edx				;i=j

continueInnerloop:
	inc		edx
	loop	innerloop

;after inner loop, call the exchange procedure
	lea		esi, [edi+ebx*4]					;esi performs memory addressing calculations 
	push	esi									;array[k]
	lea		esi, [edi+eax*4]					;esi performs memory addressing calculations 
	push	esi									;array[i]
	call	exchange
	
	pop		ecx
	inc		ebx
	loop	outerloop

	pop		ebp
	ret		8

sortList ENDP

;Procedure to exchange two elements in array
;receives: address of two elements in array
;returns: swapped array
;preconditions:  there are values in array
;registers changed: ebp, esp, eax, ecx, ebx
exchange PROC
	push	ebp
	mov		ebp, esp
	pushad

; swap two elements in array	
	mov		eax, [ebp+12]			;eax = array[k]
	mov		ebx, [ebp+8]			;ebx = array[i]	
	mov		ecx, [eax]
	mov		edx, [ebx]
	mov		[eax], edx
	mov		[ebx], ecx
	
	popad
	pop		ebp
	ret		8

exchange ENDP

;Procedure to display the median of the array
;receives: address of list, value of userInput, address of result message
;returns: the median number
;preconditions:  sorted array
;registers changed: edx

displayMedian PROC
	push	ebp
	mov		ebp, esp

; display result message on the screen	
	call	Crlf
	mov		edx, [ebp+8]			;reuslt message in edx
	call	WriteString

	mov		edi, [ebp+16]			;@list in edi
	mov		eax, [ebp+12]			;value of userInput in ecx
	mov		ebx, 2
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	je		evenNumber
	
; if the number of array is odd ,display the middle number
	mov     edx, 4
	mul		edx						;eax*4
	add		edi, eax
	mov		eax, [edi]
	call	WriteDec
	call	Crlf
	jmp		theEnd

; if the number is even, display the average of middle two elements
evenNumber:
	mov     edx, 4
	mul		edx						;eax*4
	add		edi, eax
	mov		eax, [edi]
	add		eax, [edi-4]
	mov		edx, 0
	div		ebx
	call	WriteDec
	call	Crlf	

theEnd:	
	pop		ebp
	ret		12

displayMedian ENDP

END main
