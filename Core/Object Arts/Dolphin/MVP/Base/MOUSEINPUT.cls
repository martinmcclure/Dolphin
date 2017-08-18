"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MOUSEINPUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'InputConstants'
	classInstanceVariableNames: ''!
MOUSEINPUT guid: (GUID fromString: '{6d5f4bae-88b7-4ca0-871b-9c2d3f7f969e}')!
MOUSEINPUT comment: ''!
!MOUSEINPUT categoriesForClass!External-Data-Structured-Win32! !
!MOUSEINPUT methodsFor!

dwExtraInfo
	"Answer the <BYTE> value of the receiver's 'dwExtraInfo' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #dwExtraInfo))!

dwExtraInfo: aBYTE
	"Set the receiver's 'dwExtraInfo' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: ##(self offsetOf: #dwExtraInfo) put: aBYTE yourAddress!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anInteger!

dx
	"Answer the <Integer> value of the receiver's 'dx' field."

	^bytes sdwordAtOffset: 0!

dx: anInteger
	"Set the receiver's 'dx' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

dy
	"Answer the <Integer> value of the receiver's 'dy' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #dy)!

dy: anInteger
	"Set the receiver's 'dy' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #dy) put: anInteger!

leftButtonDownAt: aPoint

	self 
		dx: aPoint x;
		dy: aPoint y;
		dwFlags:  MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_VIRTUALDESK;
		yourself.
!

leftButtonUpAt: aPoint

	self
		dx: aPoint x;
		dy: aPoint y;
		dwFlags:  MOUSEEVENTF_LEFTUP | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_VIRTUALDESK;
		yourself.
!

mouseData
	"Answer the <Integer> value of the receiver's 'mouseData' field."

	^bytes dwordAtOffset: ##(self offsetOf: #mouseData)!

mouseData: anInteger
	"Set the receiver's 'mouseData' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #mouseData) put: anInteger!

time
	"Answer the <Integer> value of the receiver's 'time' field."

	^bytes dwordAtOffset: ##(self offsetOf: #time)!

time: anInteger
	"Set the receiver's 'time' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #time) put: anInteger! !
!MOUSEINPUT categoriesFor: #dwExtraInfo!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dwExtraInfo:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dwFlags!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dwFlags:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dx!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dx:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dy!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #dy:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #leftButtonDownAt:!public! !
!MOUSEINPUT categoriesFor: #leftButtonUpAt:!public! !
!MOUSEINPUT categoriesFor: #mouseData!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #mouseData:!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #time!**compiled accessors**!public! !
!MOUSEINPUT categoriesFor: #time:!**compiled accessors**!public! !

!MOUSEINPUT class methodsFor!

defineFields
"
	MOUSEINPUT compileDefinition.

	typedef struct tagMOUSEINPUT {
		LONG      dx;
		LONG      dy;
		DWORD     mouseData;
		DWORD     dwFlags;
		DWORD     time;
		ULONG_PTR dwExtraInfo;
	} MOUSEINPUT, *PMOUSEINPUT;
"
	self 
		defineField: #dx 		type: SDWORDField new;
		defineField: #dy 		type: SDWORDField new;
		defineField: #mouseData 	type: DWORDField new;
		defineField: #dwFlags	type: DWORDField new;
		defineField: #time		type: DWORDField new;
		defineField: #dwExtraInfo	type: (PointerField type: DWORD);
		yourself.! !
!MOUSEINPUT class categoriesFor: #defineFields!public! !

