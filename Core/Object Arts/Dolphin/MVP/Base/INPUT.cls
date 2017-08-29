"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #INPUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'InputConstants'
	classInstanceVariableNames: ''!
INPUT guid: (GUID fromString: '{48dc2c77-6fd8-4fab-91d3-58dcdfad681a}')!
INPUT comment: ''!
!INPUT categoriesForClass!External-Data-Structured-Win32! !
!INPUT methodsFor!

hi
	"Answer the <HARDWAREINPUT> value of the receiver's 'hi' field."

	^HARDWAREINPUT fromAddress: bytes yourAddress + ##(self offsetOf: #hi)!

hi: aHARDWAREINPUT
	"Set the receiver's 'hi' field to the value of the argument, aHARDWAREINPUT"

	aHARDWAREINPUT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #hi) + 1)
		to: ##((self offsetOf: #hi) + HARDWAREINPUT basicByteSize)
		startingAt: 1!

ki
	"Answer the <KEYBDINPUT> value of the receiver's 'ki' field."

	^KEYBDINPUT fromAddress: bytes yourAddress + ##(self offsetOf: #ki)!

ki: aKEYBDINPUT
	"Set the receiver's 'ki' field to the value of the argument, aKEYBDINPUT"

	aKEYBDINPUT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ki) + 1)
		to: ##((self offsetOf: #ki) + KEYBDINPUT basicByteSize)
		startingAt: 1!

mi
	"Answer the <MOUSEINPUT> value of the receiver's 'mi' field."

	^MOUSEINPUT fromAddress: bytes yourAddress + ##(self offsetOf: #mi)!

mi: aMOUSEINPUT
	"Set the receiver's 'mi' field to the value of the argument, aMOUSEINPUT"

	aMOUSEINPUT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #mi) + 1)
		to: ##((self offsetOf: #mi) + MOUSEINPUT basicByteSize)
		startingAt: 1!

send

	| result |
	result := UserLibrary default
		sendInput: 1
		inputs: self 
		size: self byteSize.
	result == 1 ifTrue: [^self].
	KernelLibrary default systemError: Processor activeProcess lastError.
!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes dwordAtOffset: 0!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger! !
!INPUT categoriesFor: #hi!**compiled accessors**!public! !
!INPUT categoriesFor: #hi:!**compiled accessors**!public! !
!INPUT categoriesFor: #ki!**compiled accessors**!public! !
!INPUT categoriesFor: #ki:!**compiled accessors**!public! !
!INPUT categoriesFor: #mi!**compiled accessors**!public! !
!INPUT categoriesFor: #mi:!**compiled accessors**!public! !
!INPUT categoriesFor: #send!public! !
!INPUT categoriesFor: #type!**compiled accessors**!public! !
!INPUT categoriesFor: #type:!**compiled accessors**!public! !

!INPUT class methodsFor!

defineFields
"
	self compileDefinition

	typedef struct tagINPUT {
		DWORD type;
		union {
			MOUSEINPUT    		mi;
			KEYBDINPUT    		ki;
			HARDWAREINPUT	hi;
		};
	} INPUT, *PINPUT;"

	self
		defineField: #type	type: DWORDField new;
		defineField: #mi	type: (StructureField type: MOUSEINPUT)		offset: DWORDField byteSize;
		defineField: #ki		type: (StructureField type: KEYBDINPUT )		offset: DWORDField byteSize;
		defineField: #hi		type: (StructureField type: HARDWAREINPUT )	offset: DWORDField byteSize;
		yourself.!

leftButtonClickAt: aPoint

	| input |
	input := self newMouseInput.
	input mi moveTo: aPoint.
	input send.
	input := self newMouseInput.
	input mi leftButtonDown.
	input send.
	input := self newMouseInput.
	input mi leftButtonUp.
	input send.
!

newHardwareInput

	^self new
		type: INPUT_HARDWARE;
		yourself!

newKeyboardInput

	^self new
		type: INPUT_KEYBOARD;
		yourself!

newMouseInput

	^self new
		type: INPUT_MOUSE;
		yourself!

sendVKey: anInteger
"
To see this in operation, maximize the window then execute the following line:
	(Delay forSeconds: 1) wait. INPUT leftButtonClickAt: 15@15. INPUT sendVKey: $R codePoint.
"
	| input |
	input := self newKeyboardInput.
	input ki vKeyDown: anInteger.
	input send.
	input := self newKeyboardInput.
	input ki vKeyDown: anInteger.
	input send.
! !
!INPUT class categoriesFor: #defineFields!public! !
!INPUT class categoriesFor: #leftButtonClickAt:!public! !
!INPUT class categoriesFor: #newHardwareInput!public! !
!INPUT class categoriesFor: #newKeyboardInput!public! !
!INPUT class categoriesFor: #newMouseInput!public! !
!INPUT class categoriesFor: #sendVKey:!public! !
