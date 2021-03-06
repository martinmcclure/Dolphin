"Filed out from Dolphin Smalltalk 7"!

TEXTRANGE subclass: #FINDTEXTEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FINDTEXTEX guid: (GUID fromString: '{be0e52c5-c59b-4277-ac2a-cb775eac3904}')!
FINDTEXTEX comment: '<FINDTEXTEX> is an <ExternalStructure> class to wrap the struct ''Win.FINDTEXTEX'' from type information in the ''Windows API (ANSI)'' library.

This structure is used in conjunction with the RichEdit control''s EM_FINDTEXTEX message, but is defined in the base as it is also used by Scintilla.

IDL definition follows:

typedef 
struct tagFINDTEXTEX {
	CHARRANGE chrg;
	long lpstrText;
	CHARRANGE chrgText;
} FINDTEXTEX;
'!
!FINDTEXTEX categoriesForClass!Win-Structs! !
!FINDTEXTEX methodsFor!

chrgText
	"Answer the receiver's chrgText field as a Smalltalk object."

	^CHARRANGE fromAddress: bytes yourAddress + ##(self offsetOf: #chrgText)! !
!FINDTEXTEX categoriesFor: #chrgText!**compiled accessors**!public! !

!FINDTEXTEX class methodsFor!

defineFields
	"Define the fields of the FINDTEXTEX structure.
		FINDTEXTEX compileDefinition

		typedef 
		struct tagFINDTEXTEX {
			CHARRANGE chrg;
			LPSTR lpstrText;
			CHARRANGE chrgText;
		} FINDTEXTEX;"

	super defineFields.
	self defineField: #chrgText type: (StructureField type: CHARRANGE) beReadOnly! !
!FINDTEXTEX class categoriesFor: #defineFields!initializing!public! !

