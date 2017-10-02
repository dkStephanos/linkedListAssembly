;************************************************************************************
; name:   Macros201410.asm
; date:  2/12/2011
; purpose: To use macros for function calls
;************************************************************************************
	ExitProcess	PROTO Near32 stdcall, dVal:dword  ;dVal normally 0
	ascint32	PROTO NEAR32 stdcall, lpInputString:dword
	intasc32	PROTO NEAR32 stdcall, lpOutputString:dword,dNum:dword
	getstring	PROTO NEAR32 stdcall, lpInputString:dword, dStringLength:dword
	putstring	PROTO NEAR32 stdcall, lpInputString:dword
	putch		PROTO Near32 stdcall, bChar:dword
	getche		PROTO Near32 stdcall		;gets a char and echos it
	getch		PROTO Near32 stdcall		;no echo of char
	GetLocalTime PROTO Near32 stdcall,lpSystemTime:PTR SYSTEMTIME
	intasc32Comma PROTO Near32 stdcall, lpStringToConvert:dword, dVal:dword ; puts in commas
	memoryallocBailey PROTO Near32 stdcall, dNumBytes:dword
;************************************************************************************
; name: newline
; date: 10/20/2014
; purpose:  To advance the cursor to the beginning of a newline
;************************************************************************************
newline	macro
	INVOKE putch,10
	INVOKE putch,13
	endm
	
;************************************************************************************
; name:  tab
; date: 10/20/2014
; purpose:  To move the cursor one tab mark on the screen
;************************************************************************************
tab		macro
	INVOKE putch,9
	endm

;************************************************************************************
; name:  exit
; date: 10/20/2014
; purpose:  To end, normally, a program
;************************************************************************************
exit	macro
	INVOKE ExitProcess,0
	PUBLIC _start
	endm
;************************************************************************************
; name:  gets	strToHold, dNum
; date: 10/20/2014
; purpose:  To get string of a maximum of dNum characters from the keyboard. A null
;  character will be appended to the string of characters
;************************************************************************************
gets	macro	strToHold, dWordVal
		INVOKE  getstring, ADDR [strToHold], dWordVal
		endm
;************************************************************************************
; name:  puts
; date: 2/11/2011
; purpose:  To display a null-terminated string of characters on the screen
; parameters: the first byte of the string to print
;************************************************************************************

puts	macro	strToPrint
		INVOKE putstring, ADDR [strToPrint]
		endm
		
;************************************************************************************
; name:  StringToNum    strNum, dwordToHold
; date: 10/20/2014
; purpose:  To convert a null-terminated numeric string to an integer
; parameters: 
;		the string to be converted
;		a dword to hold the value - canNOT be the eax register
;************************************************************************************
stringToNum	macro	strToConvert, dWordToHoldNum
		push eax		;preserve eax
		INVOKE ascint32, ADDR [strToConvert]
		mov		dWordToHoldNum,eax
		pop		eax
		endm

;************************************************************************************
; name:  numToString    strNum, dwordToHold
; date: 10/20/2014
; purpose:  To convert an integer to a null-terminated numeric string
; parameters: 
;		the string to hold the number
;		a dword that holds the value
;************************************************************************************
numToString	macro	strToHold, dNumToConvert
			INVOKE intasc32, ADDR [strToHold], dNumToConvert
		endm
numToStringComma macro strToHold,dNumToConvert
	Invoke intasc32Comma, addr [strToHold],dNumToConvert
	   endm
;************************************************************************************
; name:  getc  chrField
; date: 10/20/2014
; purpose:  To get a single character input from the keyboard. It echoes the character
;			on the screen
;************************************************************************************
getc	macro	chrField
		push	eax
		INVOKE  getche
		mov		chrField,al
		pop		eax
		endm

;************************************************************************************
; name:  putc  chrField
; date: 2/11/2011
; purpose:  To display a single character on the screen
;************************************************************************************
putc	macro	chrField
		push	eax
		mov		al,chrField
		INVOKE	putch,al
		pop		eax
		endm
;*****************************
; MACRO:  putspaces   
;*****************************	
putspaces MACRO numspaces
	LOCAL L1, L2
	push ecx				;pushes ecx reg onto stack for use
	mov ecx, numspaces		;move the integer param numspaces into ecx for count
L1:
	putc 32					;put space
	DEC ecx					;decrement the count
	cmp ecx, 0				;see if the count = 0
	jne L1					;if !=, jmp to loop to ouput another space
	jmp L2					;if =, then exit MACRO
L2:	
	pop ecx					;release ecx register from the stack
	ENDM