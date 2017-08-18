"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #HARDWAREINPUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HARDWAREINPUT guid: (GUID fromString: '{24e60d41-e160-42d0-94bd-c9cf94a0098d}')!
HARDWAREINPUT comment: ''!
!HARDWAREINPUT categoriesForClass!External-Data-Structured-Win32! !
!HARDWAREINPUT methodsFor!

uMsg
	"Answer the <Integer> value of the receiver's 'uMsg' field."

	^bytes dwordAtOffset: 0!

uMsg: anInteger
	"Set the receiver's 'uMsg' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

wParamH
	"Answer the <Integer> value of the receiver's 'wParamH' field."

	^bytes wordAtOffset: ##(self offsetOf: #wParamH)!

wParamH: anInteger
	"Set the receiver's 'wParamH' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wParamH) put: anInteger!

wParamL
	"Answer the <Integer> value of the receiver's 'wParamL' field."

	^bytes wordAtOffset: ##(self offsetOf: #wParamL)!

wParamL: anInteger
	"Set the receiver's 'wParamL' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wParamL) put: anInteger! !
!HARDWAREINPUT categoriesFor: #uMsg!**compiled accessors**!public! !
!HARDWAREINPUT categoriesFor: #uMsg:!**compiled accessors**!public! !
!HARDWAREINPUT categoriesFor: #wParamH!**compiled accessors**!public! !
!HARDWAREINPUT categoriesFor: #wParamH:!**compiled accessors**!public! !
!HARDWAREINPUT categoriesFor: #wParamL!**compiled accessors**!public! !
!HARDWAREINPUT categoriesFor: #wParamL:!**compiled accessors**!public! !

!HARDWAREINPUT class methodsFor!

defineFields
"
	self compileDefinition

	typedef struct tagHARDWAREINPUT {
		DWORD uMsg;
		WORD  wParamL;
		WORD  wParamH;
	} HARDWAREINPUT, *PHARDWAREINPUT;
"
	self
		defineField: #uMsg		type: DWORDField new;
		defineField: #wParamL	type: WORDField new;
		defineField: #wParamH	type: WORDField new;
		yourself.
! !
!HARDWAREINPUT class categoriesFor: #defineFields!public! !

