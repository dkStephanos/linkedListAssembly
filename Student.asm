COMMENT#
******************************************************************************    
*File name:					Student.asm
*Project name:	 			Proj6
******************************************************************************
*Creator’s name:	Koi Stephanos
*Course-Section:	CSCI 2160-001	
*Creation Date:		April 29, 2015
*Due Date:			May   1,  2015   12:00 PM
*Purpose:
*		Provide the methods neccesary to navigate and display information
*		stored witin the employee structure.
*
*****************************************************************************#

	.486
	.model flat
	.stack 100h

	stringLength		PROTO stdcall,lpString:dword		;determines byte length of string
	stringCopy			PROTO stdcall, lpSource:dword,lpDest:dword ;copies string
	intasc32Comma  		PROTO stdcall,lpStringToHold:dword,dval:dword;inserts commas
	getMonth  			PROTO stdcall,monthNum:word, lpMonthStruct:dword ;gets location of date
	ExitProcess 		PROTO Near32 stdcall,dwExitCode:dword  ;capitalization not necessary
	ascint32			PROTO Near32 stdcall,lpStringToConvert:dword;string to int
	intasc32			proto Near32 stdcall,lpStringToHold:dword, dval:dword;int to string
	putstring 			PROTO Near32 stdcall,lpStringToPrint:dword	;displays string
	putch				PROTO Near32 stdcall, dChar:dword
	getch				PROTO Near32 stdcall;  gets a character from the keyboard
	getche				PROTO Near32 stdcall;	gets a char from keyboard and echoes
	getstring			PROTO Near32 stdcall,lpStringToGet:dword, dlength:dword;inputs string
	memoryallocBailey	PROTO Near32 stdcall, dSize:dword	;allocates specified amount of new memory

	include Macros201410.asm 
	
Student struct
	stuID	dword	?
	lastname	dword	?
	firstname	dword	?
	age		word 	?
	hrsAttempted dword	?
	qualityPts 	dword	?
Student ends
	
	.code

COMMENT #
************************************************************************************
	Method Name: Student_1
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@return The address of the newly created structure.

***********************************************************************************#

Student_1	PROC	stdcall
	
	INVOKE memoryallocBailey, sizeof Student		;creates student object, eax = address
	RET
	
Student_1	endp


COMMENT #
************************************************************************************
	Method Name: Student_2
	Method Purpose: To create a new instance of the student class with the given
					id, last name and first name.
	Date created: April 29, 2015
	Date last modified: May 1, 2015

	@param id - The id of the student that is to be created.
	@param lpLast - The address of the first byte of the last name of the student.
	@param lpFirst - The address of the first byte of the first name of the student.
	@return The address of the newly created structure.

***********************************************************************************#

Student_2	PROC	stdcall uses ebx edi esi, id : dword, lpLast : dword, lpFirst : dword
	local strLength : dword
	assume ebx : ptr Student

createStudent:	
	INVOKE memoryallocBailey, sizeof Student		;creates student object, eax = address
	mov ebx, eax									;ebx = address of newly created student
	
setID:
	mov eax, id										;eax = id
	mov [ebx].stuID, eax							;student's ID = @param id

setLastName:
	mov esi, lpLast									;esi points to last name field
	INVOKE stringLength, esi						;eax = length of last name
	mov strLength, eax								;strLength = length of last name
	inc strLength									;account for null character
	INVOKE memoryallocBailey, strLength				;allocates enough space for our string
	mov edi, eax									;edi = address where we will store new string
	INVOKE stringCopy, esi, edi 					;copies string to our target location
	mov [ebx].lastname, edi							;moves address of created last name into struct
	
setFirstName:
	mov esi, lpFirst								;esi points to first name field
	INVOKE stringLength, esi						;eax = length of first name
	mov strLength, eax								;strLength = length of first name
	inc strLength									;account for null character
	INVOKE memoryallocBailey, strLength				;allocates enough space for our string
	mov edi, eax									;edi = address where we will store new string
	INVOKE stringCopy, esi, edi 					;copies string to our target location
	mov [ebx].firstname, edi						;moves address of created first name into struct
	

	
returnAddress:
	mov eax, ebx
	assume ebx : ptr
	RET
	
Student_2	endp

COMMENT #
************************************************************************************
	Method Name: Student_3
	Method Purpose: To create a new instance of the student class that has the same
					values as the passed student.
	Date created: April 29, 2015
	Date last modified: May 1, 2015

	@param lpOriginal - The address of the student to be copied.
	@return The address of the newly created structure.

***********************************************************************************#

Student_3	PROC	stdcall uses ebx ecx edi esi, lpOriginal : dword
	local strLength : dword
	assume ebx : ptr Student, ecx : ptr Student

createStudent:	
	INVOKE memoryallocBailey, sizeof Student		;creates student object, eax = address
	mov ebx, eax									;ebx = address of newly created student
	mov ecx, lpOriginal								;ecx points to student to be copied
	
setID:
	mov eax, [ecx].stuID							;eax = id
	mov [ebx].stuID, eax							;student's ID = @param id

setLastName:
	mov edi, [ecx].lastname							;edi points to last name field
	INVOKE stringLength, edi						;eax = length of last name
	mov strLength, eax								;strLength = length of last name
	inc strLength									;accounts for null character
	INVOKE memoryallocBailey, strLength				;allocates enough space for our string
	mov edi, eax									;edi = address where we will store new string
	mov esi, [ecx].lastname							;esi points to the string we want to copy
	INVOKE stringCopy, esi, edi 					;copies string to our target location
	mov [ebx].lastname, edi							;moves address of created last name into struct
	
setFirstName:
	mov edi, [ecx].firstname						;edi points to first name field
	INVOKE stringLength, edi						;eax = length of first name
	mov strLength, eax								;strLength = length of first name
	inc strLength									;accounts for null character
	INVOKE memoryallocBailey, strLength				;allocates enough space for our string
	mov edi, eax									;edi = address where we will store new string
	mov esi, [ecx].firstname						;esi points to the string we want to copy
	INVOKE stringCopy, esi, edi 					;copies string to our target location
	mov [ebx].firstname, edi						;moves address of created first name into struct

setAge:
	mov ax, [ecx].age								;ax = student's age
	mov [ebx].age, ax								;moves age into new student

setHrsAttempted:
	mov eax, [ecx].hrsAttempted						;eax = student's hours attempted
	mov [ebx].hrsAttempted, eax						;moves hrsAttempted into new student

setQualityPts:
	mov eax, [ecx].qualityPts						;eax = student's quality points
	mov [ebx].qualityPts, eax						;moves qualityPts into new student
	
returnAddress:
	mov eax, ebx
	assume ebx : ptr, ecx : ptr
	RET
	
Student_3	endp

COMMENT #
************************************************************************************
	Method Name: Student_setID
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@param lpStudent - The address of the student who's id we are setting.
	@param id - The id that we are setting it to.
	@return void

***********************************************************************************#

Student_setID	PROC	stdcall uses eax ebx, lpStudent : dword, id : dword
	assume ebx : ptr Student
	
	mov ebx, lpStudent								;ebx points to our student
	mov eax, id										;eax = the id we are copying
	mov [ebx].stuID, eax							;sets student's stuID to id, we're done
	
	assume ebx: ptr
	RET
	
Student_setID	endp

COMMENT #
************************************************************************************
	Method Name: Student_setLastname
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@param lpStudent - The address of the student who's last name we are setting.
	@param lpLastName - The address of the last name we are copying.
	@return void

***********************************************************************************#

Student_setLastname	PROC	stdcall uses ebx edi esi, lpStudent : dword, lpLastName : dword
	local strLength : dword
	assume ebx : ptr Student
	
	mov ebx, lpStudent								;ebx points to our student
	mov esi, lpLastName								;esi points to last name field
	INVOKE stringLength, esi						;eax = length of last name
	mov strLength, eax								;strLength = length of last name
	inc strLength									;accounts for null character
	INVOKE memoryallocBailey, strLength				;allocates space for the last name
	mov edi, eax									;edi = address where new string goes
	INVOKE stringCopy, esi, edi						;copies old string to new string space
	mov [ebx].lastname, edi							;moves address of new last name string into struct
	
	assume ebx: ptr
	RET
	
Student_setLastname	endp

COMMENT #
************************************************************************************
	Method Name: Student_getID
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@param lpStudent - The address of the student who's id we are setting.
	@return The id of the student we are given.

***********************************************************************************#

Student_getID	PROC	stdcall uses ebx, lpStudent : dword
	assume ebx : ptr Student
	
	mov ebx, lpStudent								;ebx points to our student
	mov eax, [ebx].stuID							;eax = students id, so we are ready to return
	
	assume ebx: ptr
	RET
	
Student_getID	endp

COMMENT #
************************************************************************************
	Method Name: Student_getLastname
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@param lpStudent - The address of the student who's last name we are setting.
	@return The address of a created string that holds the student's last name.

***********************************************************************************#

Student_getLastname PROC	stdcall uses ebx edi, lpStudent : dword
	local strLength : dword
	assume ebx : ptr Student
	
	mov ebx, lpStudent								;ebx points to our student
	mov edi, [ebx].lastname							;edi points to student's last name
	INVOKE stringLength, edi						;eax = length of first name
	mov strLength, eax								;strLength = length of first name
	inc strLength									;accounts for null character
	INVOKE memoryallocBailey, strLength				;allocates space for the last name
	INVOKE stringCopy, edi, eax						;copies old string to new string space, we're done
	
	assume ebx: ptr
	RET
	
Student_getLastname	endp

COMMENT #
************************************************************************************
	Method Name: Student_calcGPA
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@param lpStudent - The address of the student who's last name we are setting.
	@return The GPA of the student rounded to the nearest whole number.

***********************************************************************************#

Student_calcGPA	PROC	stdcall uses ebx ecx edi esi, lpStudent : dword
	assume ebx : ptr Student
	local gpa : dword, remainder : dword

getData:
	mov ebx, lpStudent								;ebx points to our student
	mov esi, [ebx].hrsAttempted						;esi = student's hours attempted
	mov eax, [ebx].qualityPts						;eax = student's quality points
	cdq												;edx:eax = student's quality points
	
calcGPA:
	IDIV esi										;edx = remainder, eax = quotient
	mov remainder, edx								;remainder = value that will determine rounding
	mov gpa, eax									;gpa = the unrounded gpa
	mov eax, [ebx].hrsAttempted						;eax = student's hours attempted
	cdq												;edx:eax = student's hours attempted
	mov ecx, 2										;ecx = 2 so we can test for the decimal value of gpa
	IDIV ecx										;eax = half of the student's hours attempted
	.IF remainder < eax								;if our remainder is less than half our dividend (hrsAttempted)
		NOP											;that means our decimal value would be less than .5
	.ELSE											;otherwise our decimal value would have been >= .5
		inc gpa										;so we inc gpa, which essentially rounds it up
	.ENDIF
	mov eax, gpa									;we should now have gpa, mov to eax to return
	
	assume ebx: ptr
	RET
	
Student_calcGPA	endp

COMMENT #
************************************************************************************
	Method Name: Student_equals
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@param lpStudent1 - The address of the student who we are comparing.
	@param lpStudent2 - The address of the student we are comparing to.
	@return byte containing 1 if true and 0 if false.

***********************************************************************************#

Student_equals	PROC	stdcall uses ebx ecx edi esi, lpStudent1 : dword, lpStudent2 : dword
	local match : dword, strLength : dword, id : dword, last : dword, first : dword, age : word, hours : dword, points : dword
	assume ebx : ptr Student, edi : ptr Student
	
	mov match, 1									;assume equal
	
collectInfo:
	mov ebx, lpStudent1								;ebx points to student one
	mov edi, lpStudent2								;edi points to student two
	mov esi, [ebx].stuID							;esi = stu1's id
	mov id, esi										;id = stu1's id
	mov esi, [ebx].lastname							;esi = address of stu1's last name
	mov last, esi									;last = address of stu1's last name
	mov esi, [ebx].firstname						;esi = address of stu1's first name
	mov first, esi									;first = address of stu1's first name
	mov si, [ebx].age								;si = stu1's age
	mov age, si										;age = stu1's age
	mov esi, [ebx].hrsAttempted						;esi = stu1's hours attempted
	mov hours, esi									;hours = stu1's hours attempted
	mov esi, [ebx].qualityPts						;esi = stu1's qualityPts
	mov points, esi									;points = stu1's qualityPts
	
compareValues:
	mov esi, [edi].stuID							;esi = stu2's ID
	.IF esi != id									;if the ID's are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing
	mov si, [edi].age								;si = stu2's age
	.IF si != age									;if the ages are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing
	mov esi, [edi].hrsAttempted						;esi = stu2's hours attempted
	.IF esi != hours								;if the hours are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing
	mov esi, [edi].qualityPts						;esi = stu2's quality points
	.IF esi != points								;if the points are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing

compareFirstName:
	mov esi, first									;esi point to stu1's first name
	INVOKE stringLength, first						;eax = length of stu1's first name
	mov strLength, eax								;strLength = length of stu1's first name
	mov esi, [edi].firstname						;esi points to stu2's first name
	INVOKE stringLength, esi						;eax = length of stu1's first name
	.IF eax != strLength							;if the lengths aren't equal, the names aren't
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;but, if lengths equal, must compare byte by byte
	mov ecx, strLength								;sets loop for length of string we are comparing
	mov edi, first									;edi now points to stu1's first name

firstNameLoop:
	mov eax, 0										;clears the eax register for comparison
	mov al, byte ptr [edi]							;al = next letter from stu1's name
	.IF al != byte ptr [esi]						;if al doesn't equal the next letter from stu2's name
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;else, we need to keep checking all the letters
	inc edi											;edi points to the next letter in stu1's first name
	inc esi											;esi points to the next letter in stu2's first name
	loop firstNameLoop								;continue comparing until letters differ or all letters compared 
	
compareLastName:
	mov esi, last									;esi points to stu1's last name
	mov edi, lpStudent2								;edi points back to student 2
	INVOKE stringLength, last						;eax = length of stu1's last name
	mov strLength, eax								;strLength = length of stu1's last name
	mov esi, [edi].lastname							;esi points to stu2's last name
	INVOKE stringLength, esi						;eax = length of stu1's last name
	.IF eax != strLength							;if the lengths aren't equal, the names aren't
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;but, if lengths equal, must compare byte by byte
	mov ecx, strLength								;sets loop for length of string we are comparing
	mov edi, last									;edi now points to stu1's last name

lastNameLoop:	
	mov eax, 0										;clears the eax register for comparison
	mov al, byte ptr [edi]							;al = next letter from stu1's name
	.IF al != byte ptr [esi]						;if al doesn't equal the next letter from stu2's name
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;else, we need to keep checking all the letters
	inc edi											;edi points to the next letter in stu1's last name
	inc esi											;esi points to the next letter in stu2's last name
	loop lastNameLoop								;continue comparing until letters differ or all letters compared 
	
done:
	mov eax, match									;returns whether or not we found a match
	assume ebx: ptr, edi : ptr
	RET
	
Student_equals	endp

COMMENT #
************************************************************************************
	Method Name: Student_equalsIgnoreCase
	Method Purpose: To create a new, empty instance of the student class.
	Date created: April 29, 2015
	Date last modified: May 1, 2015
	
	@param lpStudent1 - The address of the student who we are comparing.
	@param lpStudent2 - The address of the student we are comparing to.
	@return byte containing 1 if true and 0 if false.

***********************************************************************************#

Student_equalsIgnoreCase	PROC	stdcall uses ebx ecx edi esi, lpStudent1 : dword, lpStudent2 : dword
	local match : dword, strLength : dword, id : dword, last : dword, first : dword, age : word, hours : dword, points : dword
	assume ebx : ptr Student, edi : ptr Student
	
	mov match, 1									;assume equal
	
collectInfo:
	mov ebx, lpStudent1								;ebx points to student one
	mov edi, lpStudent2								;edi points to student two
	mov esi, [ebx].stuID							;esi = stu1's id
	mov id, esi										;id = stu1's id
	mov esi, [ebx].lastname							;esi = address of stu1's last name
	mov last, esi									;last = address of stu1's last name
	mov esi, [ebx].firstname						;esi = address of stu1's first name
	mov first, esi									;first = address of stu1's first name
	mov si, [ebx].age								;si = stu1's age
	mov age, si										;age = stu1's age
	mov esi, [ebx].hrsAttempted						;esi = stu1's hours attempted
	mov hours, esi									;hours = stu1's hours attempted
	mov esi, [ebx].qualityPts						;esi = stu1's qualityPts
	mov points, esi									;points = stu1's qualityPts
	
compareValues:
	mov esi, [edi].stuID							;esi = stu2's ID
	.IF esi != id									;if the ID's are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing
	mov si, [edi].age								;si = stu2's age
	.IF si != age									;if the ages are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing
	mov esi, [edi].hrsAttempted						;esi = stu2's hours attempted
	.IF esi != hours								;if the hours are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing
	mov esi, [edi].qualityPts						;esi = stu2's quality points
	.IF esi != points								;if the points are not the same
		mov match, 0								;we have not found a match
		jmp done									;and we can stop comparing
	.ENDIF											;else we keep comparing

compareFirstName:
	mov esi, first									;esi point to stu1's first name
	INVOKE stringLength, first						;eax = length of stu1's first name
	mov strLength, eax								;strLength = length of stu1's first name
	mov esi, [edi].firstname						;esi points to stu2's first name
	INVOKE stringLength, esi						;eax = length of stu1's first name
	.IF eax != strLength							;if the lengths aren't equal, the names aren't
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;but, if lengths equal, must compare byte by byte
	mov ecx, strLength								;sets loop for length of string we are comparing
	mov edi, first									;edi now points to stu1's first name

firstNameLoop:
	mov eax, 0										;clears the eax register for comparison
	mov al, byte ptr [edi]							;al = next letter from stu1's name
	AND al, 11011111b								;converts stu1's name's letter to upper case
	mov bl, byte ptr [esi]							;bl = next letter from stu2's name
	AND bl, 11011111b								;converts stu2's name's letter to upper case
	.IF al != bl									;if al doesn't equal the next letter from stu2's name
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;else, we need to keep checking all the letters
	inc edi											;edi points to the next letter in stu1's first name
	inc esi											;esi points to the next letter in stu2's first name
	loop firstNameLoop								;continue comparing until letters differ or all letters compared 
	
compareLastName:
	mov esi, last									;esi points to stu1's last name
	mov edi, lpStudent2								;edi points back to student 2
	INVOKE stringLength, last						;eax = length of stu1's last name
	mov strLength, eax								;strLength = length of stu1's last name
	mov esi, [edi].lastname							;esi points to stu2's last name
	INVOKE stringLength, esi						;eax = length of stu1's last name
	.IF eax != strLength							;if the lengths aren't equal, the names aren't
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;but, if lengths equal, must compare byte by byte
	mov ecx, strLength								;sets loop for length of string we are comparing
	mov edi, last									;edi now points to stu1's last name

lastNameLoop:	
	mov eax, 0										;clears the eax register for comparison
	mov al, byte ptr [edi]							;al = next letter from stu1's name
	AND al, 11011111b								;converts stu1's name's letter to upper case
	mov bl, byte ptr [esi]							;bl = next letter from stu2's name
	AND bl, 11011111b								;converts stu2's name's letter to upper case
	.IF al != bl									;if al doesn't equal the next letter from stu2's name
		mov match, 0								;we have not found a match
		jmp done									;and we are done
	.ENDIF											;else, we need to keep checking all the letters
	inc edi											;edi points to the next letter in stu1's last name
	inc esi											;esi points to the next letter in stu2's last name
	loop lastNameLoop								;continue comparing until letters differ or all letters compared 
	
done:
	mov eax, match									;returns whether or not we found a match
	assume ebx: ptr, edi : ptr
	RET
	
Student_equalsIgnoreCase	endp


END