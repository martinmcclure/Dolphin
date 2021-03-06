"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpColorPalette
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpColorPalette guid: (GUID fromString: '{585419f2-d5ab-4e85-bf56-56d115cbe7b2}')!
GpColorPalette comment: '<GpColorPalette> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorPalette'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(585419F2-D5AB-4E85-BF56-56D115CBE7B2)]
struct tagGpColorPalette {
	unsigned int flags;
	unsigned int count;
	unsigned long Entries[1];
} GpColorPalette;
'!
!GpColorPalette categoriesForClass!Unclassified! !
!GpColorPalette methodsFor!

Count
	"Answer the receiver's Count field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

Count: anObject
	"Set the receiver's Count field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

Entries
	"Answer the receiver's Entries field as a Smalltalk object."

	"Implementation Note: We must define this manually because there is no field type for a
	variable length DWORDArray."

	^DWORDArray fromAddress: bytes yourAddress + 8 length: self Count!

Entries: anObject 
	"Set the receiver's Entries field to the value of anObject."

	"Implementation Note: We must define this manually because there is no field type for a
	variable length DWORDArray."

	| size |
	size := anObject byteSize.
	anObject 
		replaceBytesOf: bytes
		from: 9
		to: 8 + size
		startingAt: 1!

Flags
	"Answer the receiver's Flags field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

Flags: anObject
	"Set the receiver's Flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!GpColorPalette categoriesFor: #Count!**compiled accessors**!public! !
!GpColorPalette categoriesFor: #Count:!**compiled accessors**!public! !
!GpColorPalette categoriesFor: #Entries!accessing!public! !
!GpColorPalette categoriesFor: #Entries:!accessing!public! !
!GpColorPalette categoriesFor: #Flags!**compiled accessors**!public! !
!GpColorPalette categoriesFor: #Flags:!**compiled accessors**!public! !

!GpColorPalette class methodsFor!

defineFields
	"Define the fields of the GpColorPalette structure.
		GpColorPalette compileDefinition
	
		typedef [uuid(585419F2-D5AB-4E85-BF56-56D115CBE7B2)]
		struct tagGpColorPalette {
			[helpstring('Palette flags')] unsigned int Flags;
			[helpstring('Number of color entries')] unsigned int Count;
			[helpstring('Palette color entries')] unsigned long Entries[1];
		} GpColorPalette;
"

	self
		defineField: #Flags
			type: DWORDField new
			offset: 0;
		defineField: #Count
			type: DWORDField new
			offset: 4;
		defineField: #Entries
			type: (ArrayField type: DWORDArray length: 1)
			offset: 8.
	self byteSize: 12! !
!GpColorPalette class categoriesFor: #defineFields!initializing!public! !

