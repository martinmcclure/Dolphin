"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #CCITEM
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!
CCITEM guid: (GUID fromString: '{87b4c5ce-026e-11d3-9fd7-00a0cc3e4a32}')!
CCITEM isAbstract: true!
CCITEM comment: 'CCITEM is an <ExternalStructure> class which implements shared behaviour and state for the common controls item structures, LVITEM, TCITEM and TVITEM. There is no actual Win32 common control structure of this name.'!
!CCITEM categoriesForClass!External-Data-Structured-Win32! !
!CCITEM methodsFor!

cchTextMax
	^self subclassResponsibility!

cchTextMax: anObject 
	"Set the receiver's cchTextMax field to the value of anObject."

	self subclassResponsibility!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^self subclassResponsibility!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	self subclassResponsibility!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self subclassResponsibility!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^self subclassResponsibility!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	self subclassResponsibility!

image: anInteger
	"Set contents' iImage member to anInteger"

	self iImage: anInteger.
	self maskIn: self imageValidMask!

imageCallback
	"Sets the receiver into image callback mode"

	self image: I_IMAGECALLBACK!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the iImage
	field has valid contents."

	"It turns out that this mask value is the same for all the controls."

	^16r2!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^self subclassResponsibility!

lParam: anObject 
	"Set the receiver's lParam field to the value of anObject."

	self subclassResponsibility!

mask
	"Answer the receiver's mask field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

mask: anObject 
	"Set the receiver's mask field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self mask: (self mask bitOr: anInteger)!

newTextBuffer: anInteger
	"Allocate a new text buffer for the receiver of the specified size."

	text := self textClass new: anInteger.
	self
		pszText: text;
		cchTextMax: anInteger;
		maskIn: self textValidMask!

param: anInteger
	"Set contents's lParam member to anInteger marking the modifications in the mask."

	self lParam: anInteger.
	self maskIn: self paramValidMask!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	"This mask value is the same for most of the controls."

	^16r4!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^self subclassResponsibility!

pszText: anObject 
	"Set the receiver's pszText field to the value of anObject."

	self subclassResponsibility!

state: anInteger
	"Set contents' state member from anInteger"

	self dwState: anInteger; 
		maskIn: self stateValidMask;
		stateMask: anInteger!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^self subclassResponsibility!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	self subclassResponsibility!

stateMaskIn: anInteger
	"Private - OR in to contents' state member the bit flags represented by anInteger"

	self state: (self dwState bitOr: anInteger)!

stateMaskOut: anInteger
	"Private - Mask out of contents' state member the bit flags represented by anInteger"

	self state: (self dwState maskClear: anInteger)!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	"This mask value is the same for most of the controls."

	^8!

text
	"Answer the text of the receiver"

	^text!

text: aString
	"Sets contents' pszMember to aString. We also hang on to it in our text instance var to
	ensure that its lifetime is sufficiently long for us to safely use it."

	text := self textClass fromString: aString displayString.
	self
		pszText: text;
		cchTextMax: text size;
		maskIn: self textValidMask!

textCallback
	"Sets the receiver into text callback mode"

	bytes dwordAtOffset: self textPointerOffset put: LPSTR_TEXTCALLBACK.
	self maskIn: self textValidMask!

textClass
	^self class textClass!

textInBuffer: aString
	"Writes aString into a system buffer pointed to by pszText
	and of size cchTextMax."

	(self textClass fromString: aString displayString)
		copyToBuffer: (bytes sdwordAtOffset: self textPointerOffset)
		ofSize: self cchTextMax!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^self subclassResponsibility!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	"This mask value is the same for most of the controls."

	^16r1! !
!CCITEM categoriesFor: #cchTextMax!accessing!public! !
!CCITEM categoriesFor: #cchTextMax:!accessing!public! !
!CCITEM categoriesFor: #dwState!accessing!public! !
!CCITEM categoriesFor: #dwState:!accessing!public! !
!CCITEM categoriesFor: #handle!accessing!public! !
!CCITEM categoriesFor: #iImage!accessing!public! !
!CCITEM categoriesFor: #iImage:!accessing!public! !
!CCITEM categoriesFor: #image:!accessing!public! !
!CCITEM categoriesFor: #imageCallback!accessing!public! !
!CCITEM categoriesFor: #imageValidMask!constants!private! !
!CCITEM categoriesFor: #lParam!accessing!public! !
!CCITEM categoriesFor: #lParam:!accessing!public! !
!CCITEM categoriesFor: #mask!**compiled accessors**!public! !
!CCITEM categoriesFor: #mask:!**compiled accessors**!public! !
!CCITEM categoriesFor: #maskIn:!accessing!public! !
!CCITEM categoriesFor: #newTextBuffer:!helpers!public! !
!CCITEM categoriesFor: #param:!accessing!public! !
!CCITEM categoriesFor: #paramValidMask!constants!private! !
!CCITEM categoriesFor: #pszText!accessing!public! !
!CCITEM categoriesFor: #pszText:!accessing!public! !
!CCITEM categoriesFor: #state:!accessing!public! !
!CCITEM categoriesFor: #stateMask!accessing!public! !
!CCITEM categoriesFor: #stateMask:!accessing!public! !
!CCITEM categoriesFor: #stateMaskIn:!accessing!private! !
!CCITEM categoriesFor: #stateMaskOut:!accessing!private! !
!CCITEM categoriesFor: #stateValidMask!constants!private! !
!CCITEM categoriesFor: #text!accessing!public! !
!CCITEM categoriesFor: #text:!accessing!public! !
!CCITEM categoriesFor: #textCallback!accessing!public! !
!CCITEM categoriesFor: #textClass!constants!private! !
!CCITEM categoriesFor: #textInBuffer:!constants!public! !
!CCITEM categoriesFor: #textPointerOffset!constants!private! !
!CCITEM categoriesFor: #textValidMask!constants!private! !

!CCITEM class methodsFor!

defineFields
	"
		CCITEM compileDefinition
	"

	self 
		defineField: #mask type: DWORDField new offset: 0!

textClass
	^Utf16String! !
!CCITEM class categoriesFor: #defineFields!initializing!public! !
!CCITEM class categoriesFor: #textClass!constants!private! !

