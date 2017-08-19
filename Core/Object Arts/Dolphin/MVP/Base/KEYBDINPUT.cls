"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #KEYBDINPUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'InputConstants'
	classInstanceVariableNames: ''!
KEYBDINPUT guid: (GUID fromString: '{c98d2650-ff4a-463a-ba10-8202472c5477}')!
KEYBDINPUT comment: ''!
!KEYBDINPUT categoriesForClass!External-Data-Structured-Win32! !
!KEYBDINPUT methodsFor!

dwExtraInfo
	"Answer the <DWORD> value of the receiver's 'dwExtraInfo' field."

	^DWORD fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #dwExtraInfo))!

dwExtraInfo: aDWORD
	"Set the receiver's 'dwExtraInfo' field to the value of the argument, aDWORD"

	bytes uintPtrAtOffset: ##(self offsetOf: #dwExtraInfo) put: aDWORD yourAddress!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anInteger!

time
	"Answer the <Integer> value of the receiver's 'time' field."

	^bytes dwordAtOffset: ##(self offsetOf: #time)!

time: anInteger
	"Set the receiver's 'time' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #time) put: anInteger!

vKeyDown: anInteger

	self wVk: anInteger.
!

vKeyUp: anInteger

	self 
		wVk: anInteger;
		dwFlags: KEYEVENTF_KEYUP;
		yourself.
!

wScan
	"Answer the <Integer> value of the receiver's 'wScan' field."

	^bytes wordAtOffset: ##(self offsetOf: #wScan)!

wScan: anInteger
	"Set the receiver's 'wScan' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wScan) put: anInteger!

wVk
	"Answer the <Integer> value of the receiver's 'wVk' field."

	^bytes wordAtOffset: 0!

wVk: anInteger
	"Set the receiver's 'wVk' field to the value of the argument, anInteger"

	bytes wordAtOffset: 0 put: anInteger! !
!KEYBDINPUT categoriesFor: #dwExtraInfo!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #dwExtraInfo:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #dwFlags!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #dwFlags:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #time!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #time:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #vKeyDown:!**compiled accessors**!convenience!public! !
!KEYBDINPUT categoriesFor: #vKeyUp:!**compiled accessors**!convenience!public! !
!KEYBDINPUT categoriesFor: #wScan!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #wScan:!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #wVk!**compiled accessors**!public! !
!KEYBDINPUT categoriesFor: #wVk:!**compiled accessors**!public! !

!KEYBDINPUT class methodsFor!

defineFields
"
	self compileDefinition.

	typedef struct tagKEYBDINPUT {
		WORD      wVk;
		WORD      wScan;
		DWORD     dwFlags;
		DWORD     time;
		ULONG_PTR dwExtraInfo;
	} KEYBDINPUT, *PKEYBDINPUT;
"
	self 
		defineField: #wVk 		type: WORDField new;
		defineField: #wScan 		type: WORDField new;
		defineField: #dwFlags 	type: DWORDField new;
		defineField: #time 		type: DWORDField new;
		defineField: #dwExtraInfo	type: (PointerField type: DWORD);
		yourself.
! !
!KEYBDINPUT class categoriesFor: #defineFields!public! !

