;************************************************************************************
;Program:		Proj6.asm
;Programmer:	D. Gene Bailey
;Class:			CSCI 2160-001
;Lab: 			Project 6
;Due Date:		Saturday, April 25th, 2015
;Modified Date: Tuesday, April 28,2015
;Purpose:  Be able to emulate the creation of instances of the Student class ascint32
;  it would be translated to assembly
;************************************************************************************
	.486
	.model flat
	.stack 100h
	stringLength	proto	stdcall,lpString:dword
	stringCopy		proto	stdcall, lpSource:dword,lpDest:dword
	toUpperCase		proto	stdcall,lpStringSource:dword	
	Student_1Bailey			PROTO	stdcall
	Student_1			PROTO	stdcall	
	Student_2Bailey			PROTO	stdcall,stuid:dword,lpLast:dword,lpFirst:dword
	Student_2			PROTO	stdcall,stuid:dword,lpLast:dword,lpFirst:dword
	Student_3Bailey			PROTO	stdcall,lpOriginalStudentObject:dword
	Student_3			PROTO	stdcall,lpOriginalStudentObject:dword
	Student_setID		PROTO 	stdcall,lpStudentObject:dword,dID:sdword
	Student_setIDBailey		PROTO 	stdcall,lpStudentObject:dword,dID:sdword
	Student_setLastnameBailey	PROTO stdcall,lpStudentObject:dword,lastname:dword
	Student_setLastname	PROTO stdcall,lpStudentObject:dword,lastname:dword
	Student_setFirstname 	PROTO stdcall,lpStudentObject:dword,lpFirstname:dword
	Student_setAge			PROTO 	stdcall,lpStudentObject:dword,sAge:sword
	Student_setHrsAttempted	PROTO 	stdcall,lpStudentObject:dword,hrs:sdword
	Student_setQualityPts	PROTO	stdcall,lpStudentObject:dword,pts:sdword
	Student_getID		PROTO stdcall,lpStudentObject:dword
	Student_getIDBailey		PROTO stdcall,lpStudentObject:dword
	Student_getAge			PROTO stdcall,lpStudentObject:dword
	Student_getHrsAttempted	PROTO stdcall,lpStudentObject:dword
	Student_getQualityPts	PROTO stdcall,lpStudentObject:dword
	Student_getLastnameBailey		PROTO stdcall,lpStudentObject:dword
	Student_getLastname		PROTO stdcall,lpStudentObject:dword
	Student_getFirstname	PROTO stdcall,lpStudentObject:dword
	Student_calcGPABailey	Proto stdcall,lpStudentObject:dword
	Student_calcGPA	Proto stdcall,lpStudentObject:dword
	Student_equalsBailey	PROTO stdcall,lpStudentObj1:dword,lpStudentObj2:dword
	Student_equals			PROTO stdcall,lpStudentObj1:dword,lpStudentObj2:dword
	Student_equalsIgnoreCaseBailey PROTO stdcall,lpStudentObj1:dword,
															lpStudentObj2:dword
	Student_equalsIgnoreCase PROTO stdcall,lpStudentObj1:dword,
															lpStudentObj2:dword														
	;Student_equalsIgnoreCase PROTO stdcall,lpStudentObj1:dword,lpStudentObj2:dword
	include Macros201410.asm
	
Student struct
	stuID	dword	?
	lastname	dword	?
	firstname	dword	?
	age		word 	?
	hrsAttempted dword	?
	qualityPts 	dword	?
Student ends

	.data
s1	dword 	?
s2	dword	?
s3 	dword 	?
s4	dword 	?
s5	dword	? 		;will be a copy of s4
strPrompt  		byte 10,13,"Enter student Information",0
lastname		byte	11 dup(?)
firstname 		byte 	11 dup(?)
age				word 	?
hrsAttempted	dword	?
qualityPts 		dword 	?
strPromptLast	byte 	10,13,"Enter last name (max 10 chrs): ",0
strPromptFirst	byte 	10,13,"Enter first name (max 10 chrs): ",0
strAge			byte	10,13,"Enter age: ",0
strID			byte	10,13,"Enter ID (numeric): ",0
strIDis			byte	10,13,10,13,"Student ID: ",0
strLastIs		byte	10,13," Last Name: ",0
strFirstIs		byte	10,13,"First Name: ",0
strQualityPts	byte	10,13,"Enter quality pts: ",0
strQualityPtsAre byte	10,13,"Quality pts: ",0
strHrsAttemptedAre byte	10,13,"Hours attempted: ",0
strGPAis		byte	10,13,"The GPA is = ",0
strAgeIs		byte	10,13,"Age: ",0
strIsEqual		byte	10,13,09,"They are identical in every aspect",0
strNotEqual		byte	10,13,9,"They are NOT equal in at least one attribute",0
strS4Unchanged 	byte 10,13,"S4 is an exact copy of s3 - its properties are below",0
strChangedProp	byte	10,13,10,13,"S4 with properties changed",0
strCreatedS5	byte	10,13,10,13,"S5 should be an exact copy of S4. Its"
				byte	" properties are below",0
strChangedName	byte	10,13,10,13,"Changed the first name of object ref by s5."
				byte	" New properties are below",0
strTestEquality34	byte	10,13,10,13,"Testing s3 and s4 for equal - should not be",0
strTestEquality45	byte	10,13,10,13,"Testing s4 and s5 for equal -They should be",0
strTestEquality45N	byte	10,13,10,13,"Testing s4 and s5 for equal -They should NOT be",0
strTestEquality45NI	byte	10,13,10,13,"Testing s4 & s5 for equalIgnoreCase - they should be",0
strStars		byte	10,13,"********************************************",0
stu3ID			dword	?
str3Last		byte 11 dup(?)
str3First 		byte 11 dup(?)
stu2LastName	byte	10,13,"Jones",0
stu2FirstName	byte	10,13,"Andy",0
strFirstName5	byte	"Henry",0
strLastName5	byte	"jackson",0
strLowerCase	byte	"wilson",0
strUpperCase	byte	20 dup (?)
stu1ID			dword 	1111
crlf			byte 10,13,0
strOut			byte 12 dup(?)

	.code
.listall
_start:
	mov	eax,09			;dummy statement for debugging
;*************************************************************
;create stu1 with NO information in it
;*************************************************************
	;INVOKE Student_1Bailey			;create an instance
	INVOKE Student_1			;create an instance
	mov 	s1,eax				; of the student class referenced by s1
;***********************************************************************************
;create an instance referenced by s2 with (1111,"Last","First"), then set the hrs
;attempted to 62  and the quality pts to 292
;************************************************************************************
	mov	ebx,1111				;student id is 1111
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_2Bailey,EBX,ADDR stu2LastName,ADDR stu2FirstName
	INVOKE Student_2,EBX,ADDR stu2LastName,ADDR stu2FirstName
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov	s2,eax					;s2 --> object 
	INVOKE Student_setHrsAttempted,s2,62
	INVOKE Student_setQualityPts,s2,292
	
;************************************************************************************
;prompt user for id, last and first names, then create an instance of the object
; referenced by s3 and then the hours attempted to 100 and the quality pts to 350
;  and the age to 19
;************************************************************************************
	puts	strID							;display msg to enter ID
	gets	strID,10						;get the id for the student
	INVOKE ascint32,ADDR strID				;convert to a binary value
	mov 	stu3ID,eax						;  and storeitin stu3ID
	puts	strPromptLast					;prompt user for last name
	gets	str3Last,10						;get the last name a max of 10 chars
	puts 	strPromptFirst 					;prompt user for first name
	gets 	str3First,10					;   for a max of 10 chars
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_2Bailey,stu3ID,ADDR str3Last, ADDR str3First ;create an obj. with this info
	INVOKE Student_2,stu3ID,ADDR str3Last, ADDR str3First 
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov 	s3,eax							;s3 --> this student
	INVOKE Student_setHrsAttempted,s3,100
	INVOKE Student_setQualityPts,s3,350
	INVOKE Student_setAge,s3,19
;************************************************************************************
;Use the copy constructor to create a copy of the object referenced by s3 and call the
;reference variable for the new object  s4
;************************************************************************************

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_3Bailey,s3			;create a copy of the object referenced by s3
	INVOKE Student_3,s3
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov	s4,eax							;s4--> new copy of student object
	

;************************************************************************************
;Display the contents of the objects referenced by s3 and s4 to show they are the same
;************************************************************************************
;First, show that referenced by s3

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_getIDBailey,s3		;get the id for the student referenced by s3
	INVOKE Student_getID,s3
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	mov ebx,eax 						;ebx = ID  problem with using EAX and INVOKE
	INVOKE intasc32,ADDR strOut,ebx 	;convert binary ID to a printable ID
	INVOKE putstring, ADDR strIDis		;display "Id is:"
	INVOKE putstring, ADDR strOut		;display the ID
							
	INVOKE  putstring, ADDR strLastIs 	;display "last name is:"

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_getLastnameBailey,s3 ;get the name for student ref. by s3
	INVOKE Student_getLastname,s3
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	
	mov  ebx,eax						;ebx -> lastname string
	INVOKE putstring,ebx				;display the name
	
	INVOKE putstring, ADDR strFirstIs  	;display "first name is:"
	INVOKE Student_getFirstname,s3		;get firstname assoc. with s3
	mov ebx,eax							;ebx-> firstname
	INVOKE putstring, ebx				;display that firstname
	
	INVOKE Student_getAge,s3   			;age for s3
	cwde								;convert the "short" to an "int"
	mov	ebx,eax							;ebx = age
	INVOKE intasc32,ADDR strOut, ebx 	;convert age to a printable string
	INVOKE putstring,ADDR strAgeIs  	;display "age: "
	INVOKE putstring, ADDR strOut		;display the age
	
	INVOKE Student_getHrsAttempted,s3   ;quality pts for s3
	mov	ebx,eax							;ebx = hrsAttempted
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strHrsAttemptedAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts
	
	INVOKE Student_getQualityPts,s3   	;quality pts for s3
	mov	ebx,eax							;ebx = quality pts
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strQualityPtsAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts
	
	;INVOKE Student_calcGPABailey,s3		;get the gpa
	INVOKE Student_calcGPA,s3	
	mov 	ebx,eax						;ebx = gpa
	INVOKE intasc32,ADDR strOut,ebx		;convert gpa to printable chars
	INVOKE putstring, ADDR strGPAis		;display "GPA is"
	INVOKE putstring, ADDR strOut		;display the GPA as a whole number
	newline								;double -
	newline								; space
	
;show that referenced by s4--
	INVOKE putstring,ADDR strS4Unchanged;display the heading "s4 exact copy of s3
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_getIDBailey,s4		;get the id for the student referenced by s4
	INVOKE Student_getID,s4
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	mov ebx,eax 						;ebx = ID
	INVOKE intasc32,ADDR strOut,ebx 	;convert binary ID to a printable ID
	INVOKE putstring, ADDR strIDis		;display "Id is:"
	INVOKE putstring, ADDR strOut		;display the ID
	
	INVOKE  putstring, ADDR strLastIs 	;display "last name is:"
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_getLastnameBailey,s4 ;get the name for student ref. by s3
	INVOKE Student_getLastname,s4 
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	mov  ebx,eax						;ebx -> lastname string
	INVOKE putstring,ebx				;display the name
	
	INVOKE putstring, ADDR strFirstIs  	;display "first name is:"
	INVOKE Student_getFirstname,s4		;get firstname assoc. with s3
	mov ebx,eax							;ebx-> firstname
	INVOKE putstring, ebx				;display that firstname
	
	INVOKE Student_getAge,s4   			;age for s3
	cwde								;convert age from a returned "short" to an "int"
	mov	ebx,eax							;ebx = age
	INVOKE intasc32,ADDR strOut, ebx 	;convert age to a printable string
	INVOKE putstring,ADDR strAgeIs  	;display "age: "
	INVOKE putstring, ADDR strOut		;display the age pts
	
	INVOKE Student_getHrsAttempted,s4   ;get hours attempted
	mov	ebx,eax							;ebx = hrsAttempted
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strHrsAttemptedAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts
	
	INVOKE Student_getQualityPts,s4   	;quality pts for s3
	mov	ebx,eax							;ebx = quality pts
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strQualityPtsAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_calcGPABailey,s4		;get the gpa
	INVOKE Student_calcGPA,s4		;get the gpa
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	mov 	ebx,eax						;ebx = gpa
	INVOKE intasc32,ADDR strOut,ebx		;convert gpa to printable chars
	INVOKE putstring, ADDR strGPAis		;display "GPA is"
	INVOKE putstring, ADDR strOut		;  whatever the gpa is to a whole number
;************************************************************************************
;	Check for equality between s3 and s4  they should be equal
;************************************************************************************
	INVOKE putstring, ADDR strTestEquality34
	
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_equalsBailey,s3,s4	;are these equal to each other
	INVOKE Student_equals,s3,s4	;are these equal to each other
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	.IF eax ==0							;no they are not
		INVOKE putstring, ADDR strNotEqual		;display they are not equal
	.ELSE
		INVOKE putstring,ADDR strIsEqual	;display they are equal
	.ENDIF

	INVOKE putstring, ADDR strStars
;************************************************************************************
;Change the quality pts of s4's student to 325 (gpa should be 325/100 = 3). Also set
; the ID for s4 to 8765  and the age to 20 then, display everything
;************************************************************************************
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_setIDBailey,s4,8765	;set the new id to 8765
	INVOKE Student_setID,s4,8765
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	INVOKE Student_setQualityPts,s4,325	;set qpts to 325 for student ref by s4	
	INVOKE Student_setAge,s4,20			;set this age to 20

;show the new changes to s4's object

	INVOKE putstring, ADDR strChangedProp	;display "s4 with changes to properties"

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_getIDBailey,s4		;get the student's id
	INVOKE Student_getID,s4
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mov ebx,eax 						;ebx = ID
	INVOKE intasc32,ADDR strOut,ebx 	;convert binary ID to a printable ID
	INVOKE putstring, ADDR strIDis		;display "Id is:"
	INVOKE putstring, ADDR strOut		;display the ID
	
	INVOKE  putstring, ADDR strLastIs 	;display "last name is:"
	
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_getLastnameBailey,s4 ;get the name for student ref. by s3
	INVOKE Student_getLastname,s4 
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mov  ebx,eax						;ebx -> lastname string
	INVOKE putstring,ebx				;display the name
	INVOKE putstring, ADDR strFirstIs  	;display "first name is:"
	INVOKE Student_getFirstname,s4		;get firstname assoc. with s3
	mov ebx,eax							;ebx-> firstname
	INVOKE putstring, ebx				;display that firstname
	
	INVOKE Student_getAge,s4   			;age for s3
	cwde								;convert the returned "short" to an "int"
	mov	ebx,eax							;ebx = age
	INVOKE intasc32,ADDR strOut, ebx 	;convert age to a printable string
	INVOKE putstring,ADDR strAgeIs  	;display "age: "
	INVOKE putstring, ADDR strOut		;display the age pts
	
	INVOKE Student_getHrsAttempted,s4   ;quality pts for s3
	mov	ebx,eax							;ebx = hrsAttempted
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strHrsAttemptedAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts
	
	INVOKE Student_getQualityPts,s4   	;quality pts for s3
	mov	ebx,eax							;ebx = quality pts
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strQualityPtsAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_calcGPABailey,s4		;get the gpa
	INVOKE Student_calcGPA,s4
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov 	ebx,eax						;ebx = gpa
	INVOKE intasc32,ADDR strOut,ebx		;convert gpa to printable chars
	INVOKE putstring, ADDR strGPAis		;display "GPA is"
	INVOKE putstring, ADDR strOut		;  whatever the gpa is rounded to whole num
	
	puts crlf							;leave an extra blank line before the prompt
;************************************************************************************
;Check for equality between s3 and s4 - they should NOT be equal
;************************************************************************************	
	INVOKE putstring, ADDR strTestEquality34
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	INVOKE Student_equalsIgnoreCaseBailey,s3,s4	;are these equal to each other
	;INVOKE Student_equalsIgnoreCase,s3,s4	;are these equal to each other
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	.IF eax ==0							;no they are not
		INVOKE putstring, ADDR strNotEqual		;display they are not equal
	.ELSE
		INVOKE putstring,ADDR strIsEqual	;display they are equal
	.ENDIF
;************************************************************************************	
	;create a copy of the object referenced by s4 and reference the copy by s5
;************************************************************************************
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_3Bailey,s4			;create a copy of the object referenced by s3
	INVOKE Student_3,s4
	mov	s5,eax							;s5--> newly created Student object
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		
;************************************************************************************
;Display the content of s5 to show it is a copy of s4
;************************************************************************************

;show that referenced by s5--
	INVOKE putstring,ADDR strCreatedS5	;display created a copy and show its contents
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_getIDBailey,s5		;get the id for the student referenced by s4
	INVOKE Student_getID,s5
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov ebx,eax 						;ebx = ID
	INVOKE intasc32,ADDR strOut,ebx 	;convert binary ID to a printable ID
	INVOKE putstring, ADDR strIDis		;display "Id is:"
	INVOKE putstring, ADDR strOut		;display the ID
	
	INVOKE  putstring, ADDR strLastIs 	;display "last name is:"
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_getLastnameBailey,s5 ;get the name for student ref. by s3
	INVOKE Student_getLastname,s5 
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov  ebx,eax						;ebx -> lastname string
	INVOKE putstring,ebx				;display the name
	
	INVOKE putstring, ADDR strFirstIs  	;display "first name is:"
	INVOKE Student_getFirstname,s5		;get firstname assoc. with s3
	mov ebx,eax							;ebx-> firstname
	INVOKE putstring, ebx				;display that firstname
	
	INVOKE Student_getAge,s5   			;age for s3
	cwde								;convert age from a returned "short" to an "int"
	mov	ebx,eax							;ebx = age
	INVOKE intasc32,ADDR strOut, ebx 	;convert age to a printable string
	INVOKE putstring,ADDR strAgeIs  	;display "age: "
	INVOKE putstring, ADDR strOut		;display the age pts
	
	INVOKE Student_getHrsAttempted,s5   ;get hours attempted
	mov	ebx,eax							;ebx = hrsAttempted
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strHrsAttemptedAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts
	
	INVOKE Student_getQualityPts,s5   	;quality pts for s3
	mov	ebx,eax							;ebx = quality pts
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strQualityPtsAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_calcGPABailey,s5		;get the gpa
	INVOKE Student_calcGPA,s5		;get the gpa
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov 	ebx,eax						;ebx = gpa
	INVOKE intasc32,ADDR strOut,ebx		;convert gpa to printable chars
	INVOKE putstring, ADDR strGPAis		;display "GPA is"
	INVOKE putstring, ADDR strOut		;  whatever the gpa is to a whole number
	
;************************************************************************************
;Check for equality between s4 and s5 - they should be equal
;************************************************************************************	
	INVOKE putstring, ADDR strTestEquality45
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	INVOKE Student_equalsBailey,s4,s5	;are these equal to each other
	;INVOKE Student_equals,s4,s5	;are these equal to each other
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	.IF eax ==0							;no they are not
		INVOKE putstring, ADDR strNotEqual		;display they are not equal
	.ELSE
		INVOKE putstring,ADDR strIsEqual	;display they are equal
	.ENDIF
	
;************************************************************************************
;Uppercase the lastname  for object referenced by s5
;************************************************************************************	
	INVOKE putstring, ADDR strStars
	newline
	INVOKE Student_getLastname,s5			;get the last name
	mov  ebx,eax							;put address into ebx to save it
	INVOKE toUpperCase,ebx					;convert it to upper case
	mov	ebx,eax								;ebx-> uppercase version
	newline
;************************************************************************************	
	;INVOKE Student_setLastnameBailey,s5,ebx		;change the lastname in S5 to uppercase
	INVOKE Student_setLastname,s5,ebx		;change the lastname in S5 to uppercase
;************************************************************************************		
	
;************************************************************************************
;Display attributes of object ref by S5  after changing the last name
;************************************************************************************	
	INVOKE putstring,ADDR strChangedName;display created a copy and show its contents
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_getIDBailey,s5		;get the id for the student referenced by s4
	INVOKE Student_getID,s5
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	mov ebx,eax 						;ebx = ID
	INVOKE intasc32,ADDR strOut,ebx 	;convert binary ID to a printable ID
	INVOKE putstring, ADDR strIDis		;display "Id is:"
	INVOKE putstring, ADDR strOut		;display the ID
	
	INVOKE  putstring, ADDR strLastIs 	;display "last name is:"
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_getLastnameBailey,s5 ;get the name for student ref. by s5
	INVOKE Student_getLastname,s5 
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov  ebx,eax						;ebx -> lastname string
	INVOKE putstring,ebx				;display the name
	
	INVOKE putstring, ADDR strFirstIs  	;display "first name is:"
	INVOKE Student_getFirstname,s5		;get firstname assoc. with s3
	mov ebx,eax							;ebx-> firstname
	INVOKE putstring, ebx				;display that firstname
	
	INVOKE Student_getAge,s5   			;age for s3
	cwde								;convert age from a returned "short" to an "int"
	mov	ebx,eax							;ebx = age
	INVOKE intasc32,ADDR strOut, ebx 	;convert age to a printable string
	INVOKE putstring,ADDR strAgeIs  	;display "age: "
	INVOKE putstring, ADDR strOut		;display the age pts
	
	INVOKE Student_getHrsAttempted,s5   ;get hours attempted
	mov	ebx,eax							;ebx = hrsAttempted
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strHrsAttemptedAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts
	
	INVOKE Student_getQualityPts,s5   	;quality pts for s3
	mov	ebx,eax							;ebx = quality pts
	INVOKE intasc32,ADDR strOut, ebx 	;convert quality pts to a printable string
	INVOKE putstring,ADDR strQualityPtsAre  ;display "Quality pts are: "
	INVOKE putstring, ADDR strOut		;display the quality pts

	;INVOKE Student_calcGPABailey,s5		;get the gpa
	INVOKE Student_calcGPA,s5		;get the gpa
	mov 	ebx,eax						;ebx = gpa
	INVOKE intasc32,ADDR strOut,ebx		;convert gpa to printable chars
	INVOKE putstring, ADDR strGPAis		;display "GPA is"
	INVOKE putstring, ADDR strOut		;  whatever the gpa is to a whole number
	
;************************************************************************************
;Check for equality between s4 and s5 - they should NOT be equal using "equals"
;************************************************************************************	
	INVOKE putstring, ADDR strTestEquality45N	
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;INVOKE Student_equalsBailey,s4,s5	;are these equal to each other
	INVOKE Student_equals,s4,s5	;are these equal to each other
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	.IF eax ==0							;no they are not
		INVOKE putstring, ADDR strNotEqual		;display they are not equal
	.ELSE
		INVOKE putstring,ADDR strIsEqual	;display they are equal
	.ENDIF

;************************************************************************************
;Check for equality between s4 and s5 - they should be equal using "equalsIgnoreCase"
;************************************************************************************	

INVOKE putstring, ADDR strTestEquality45NI
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	;INVOKE Student_equalsIgnoreCaseBailey,s4,s5	;are these equal to each other
	INVOKE Student_equalsIgnoreCase,s4,s5	;are these equal to each other
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	.IF eax ==0							;no they are not
		INVOKE putstring, ADDR strNotEqual		;display they are not equal
	.ELSE
		INVOKE putstring,ADDR strIsEqual	;display they are equal
	.ENDIF	
	newline
	INVOKE ExitProcess,0				;normal termination of the program
	PUBLIC _start
	
	END