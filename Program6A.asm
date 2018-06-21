TITLE Designing low-level I/O procedures     (Program6A.asm)

; Author: Sheng Bian
; Course / Project ID: CS271 / Program 6A            Date: March 17, 2018
; Description: This program gets 10 unsigned decimal integers from users. Each number needs 
; to be small enough to fit inside a 32 bit register. Then, the program will display a list
; of the integers, their sum, and their average value.

INCLUDE Irvine32.inc

; (insert constant definitions here)
MAXSIZE = 1000
MAX = 10 
ZERO = '0'

getString MACRO	 address
	pushad
	displayString prompt
	mov		edx, address      
	mov		ecx, MAXSIZE
	call	ReadString                    
	mov		userInput, eax	          
	popad

ENDM

displayString		MACRO		buffer
	push	edx						;save edx register
	mov		edx, OFFSET buffer
	call	WriteString
	pop		edx						;restore edx
ENDM

.data
intro_1				BYTE		"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
intro_2				BYTE		"Written by: Sheng Bian", 0
intro_3				BYTE		"Please provide 10 unsigned decimal integers.", 0
intro_4				BYTE		"Each number needs to be small enough to fit inside a 32 bit register.", 0
intro_5				BYTE		"After you have finished inputting the raw numbers I will display a list", 0
intro_6				BYTE		"of the integers, their sum, and their average value.", 0	
prompt				BYTE		"Please enter an unsigned number: ", 0	
errorMeg_1			BYTE		"ERROR: You did not enter an unsigned number or your number was too big.", 0
errorMeg_2			BYTE		"Please try again: ", 0
resultMeg_1			BYTE		"You entered the following numbers:", 0
resultMeg_2			BYTE		"The sum of these numbers is: ", 0
resultMeg_3			BYTE		"The average is: ", 0
goodbye				BYTE		"Thanks for playing!", 0
space				BYTE		",   ", 0
list				DWORD		MAX DUP(0)
numArray			DWORD		MAX DUP(0)
userInput           DWORD		? 
result		        DB			30 DUP(0)       

.code
main PROC
; introduce the program
	displayString	intro_1		
	call		Crlf
	displayString	intro_2
	call		Crlf
	call		Crlf
	displayString	intro_3
	call		Crlf
	displayString	intro_4
	call		Crlf
	displayString	intro_5
	call		Crlf
	displayString	intro_6
	call		Crlf
	call		Crlf

;call readVal procedure to get string from user and translate to number    
	push		OFFSET numArray        
    push		OFFSET list
    push		OFFSET userInput
    call		readVal

;call writeVal procedure and display the number user has entered
	displayString resultMeg_1
    call crlf
	push		OFFSET result
    push		OFFSET numArray
    call		writeVal

;calculate the sum of all the numbers and display the sum
	mov			edi, OFFSET numArray     
	mov			ecx, MAX 

calculateSum:
	mov			eax,[edi]      
	add			ebx,eax        
    add			edi,4          
    loop        calculateSum
	
	displayString resultMeg_2
	mov			eax,ebx
	call		WriteDec                 
	call		crlf

;calculate the average of numbers and display the average
	displayString resultMeg_3
	mov			edx, 0             
	mov			ebx,10              
	div			ebx
	call		WriteDec               
	call		crlf
	call		crlf
    displayString goodbye
    call		crlf    
     
exit
main        ENDP


;Procedure to get user's string of digits. Then it converts 
;the digit string to numeric, while validating input
;receives: string of digits
;returns: numeric number
;preconditions:  user input
;registers changed: ebp, ecx, esp, edi, eax, esi
readVal PROC
	push		ebp                ;Set up stack frame
	mov			ebp,esp
	mov			ecx,10								
	mov			edi,[ebp + 16]		;@numArray in edi

again: 					
	getString [ebp + 12]		
	push		ecx
	mov			esi,[ebp + 12]		;@list in esi	
	mov			ecx,[ebp + 8]		;@userInput in ecx	
	mov			ecx,[ecx]
	cmp			ecx, 9				;this step is to validate data, make sure no more than 9 digits
	jg			errorMessage
	cld							
	xor			eax,eax			     ;Clear the registers 
	xor			ebx,ebx	
						
counter:
	lodsb							;load string byte
	cmp			eax,57				;this step is to validate data, make sure there is no non-numeric digits in string 
	jg			errorMessage		
	cmp			eax,48			
	jl			errorMessage		;triger error message
	sub			eax,48			
	push	    eax                 
	mov			eax,ebx
	mov			ebx,MAX             
	mul			ebx
	mov			ebx,eax
	pop			eax                 
	add			ebx,eax             
	mov			eax,ebx
	xor			eax,eax             ;Clear register
	loop	    counter				;inner loop to convert to number
    mov			eax,ebx 
	stosd							
	add			esi,4	             ;move to next element			
	pop			ecx					
	loop		again                ;outer loop to go through string digits
	jmp			theEnd
		
errorMessage:                           
    pop			ecx
	displayString errorMeg_1
	call		Crlf
	displayString errorMeg_2
    jmp			again

theEnd:
	call		crlf
	pop ebp	
	ret 12		     															
readVal        ENDP

;Procedure to convert numberic value to a string of digits.
;receives: numberic value
;returns: string of digits
;preconditions:  user input
;registers changed: ebp, ecx, esp, edi, eax, esi
writeVal PROC
     push      ebp                  ;Set up stack frame
     mov       ebp,esp
     mov       edi, [ebp + 8]		;@result in edi
     mov       ecx, MAX              ; 10 elements in array

display:
     push		ecx
     mov		eax,[edi]
     mov	    ecx, MAX
     xor        bx,bx               ;Clear register 

check:
    xor			edx,edx        
    div			ecx            
    push		dx             
    inc			bx            
    test		eax,eax        ;check if result of the division is 0
    jz			next
    jmp			check			;loop through to convert all the digits
          
next:
    mov			cx, bx            
    lea			esi, result		;store the result
         
again2:                           
    pop			ax                 
    add			ax, ZERO		;for string, we need to add '0' to terminate it
    mov			[esi],ax             
    displayString OFFSET result
    loop again2
               
    pop			ecx				
    displayString space			;insert space to format output
    xor			ebx,ebx			;Clear the registers
    xor			edx,edx
    add			edi,4			;move to next element
	loop		display
	call		Crlf
 
	pop	ebp
    ret 8
writeVal       ENDP

End     main