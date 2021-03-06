"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpPropertyItem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpPropertyItem guid: (GUID fromString: '{dad9cd42-c61c-4040-bcd2-2f2e8d725fca}')!
GpPropertyItem comment: '<GpPropertyItem> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpPropertyItem'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(DAD9CD42-C61C-4040-BCD2-2F2E8D725FCA)]
struct tagGpPropertyItem {
	unsigned long id;
	unsigned long length;
	unsigned short type;
	void* Value;
} GpPropertyItem;
'!
!GpPropertyItem categoriesForClass!Unclassified! !
!GpPropertyItem methodsFor!

id
	"Answer the receiver's id field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

id: anObject
	"Set the receiver's id field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

length
	"Answer the receiver's length field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

length: anObject
	"Set the receiver's length field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

name
	"Answer the receiver's id (property tag) as a string.  If unknown, answer the receiver's id as a hex string."

	^GdiplusConstants keys asOrderedCollection detect: 
			[:e | 
			((e beginsWith: 'PropertyTag') and: [(e beginsWith: 'PropertyTagType') not]) 
				and: [self id = (GdiplusConstants at: e)]]
		ifNone: [self id hex]!

Type
	"Answer the receiver's Type field as a Smalltalk object."

	^(bytes wordAtOffset: 8)!

Type: anObject 
	"Set the receiver's Type field to the value of anObject."

	bytes wordAtOffset: 8 put: anObject!

typeName
	"Answer the receiver's type (property tag type) as a string."

	^GdiplusConstants keys asOrderedCollection 
		detect: [:e | (e beginsWith: 'PropertyTagType') and: [self Type = (GdiplusConstants at: e)]]!

Value
	"Answer the receiver's Value field as a Smalltalk object."

	^(bytes dwordAtOffset: 12) asExternalAddress!

Value: anObject
	"Set the receiver's Value field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

valueArray
	"Answer the array pointed at by the receiver's Value. The receiver's type gives a hint at
	the type of array, and length gives the number of items in the array."

	| address type |
	address := self Value.
	type := self Type.
	type == 1 ifTrue: [^ByteArray fromAddress: address length: self length].
	type == 2 ifTrue: [^(String fromAddress: address length: self length - 1) trimNulls].
	type == 3 ifTrue: [^WORDArray fromAddress: address length: self length / 2].
	type == 4 ifTrue: [^DWORDArray fromAddress: address length: self length / 4].
	"Next line won't work with an arary returned, i.e., if length > 8."
	type == 5 ifTrue: [^(address dwordAtOffset: 0) / (address dwordAtOffset: 4)].
	"7 is 'Undefined' so just return the bytes."
	type == 7 ifTrue: [^ByteArray fromAddress: address length: self length].
	type == 9 ifTrue: [^SDWORDArray fromAddress: address length: self length / 4].
	"Next line won't work with an arary returned, i.e., if length > 8."
	type == 10 ifTrue: [^(address sdwordAtOffset: 0) / (address sdwordAtOffset: 4)].
	self error: 'unrecognised type'! !
!GpPropertyItem categoriesFor: #id!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #id:!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #length!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #length:!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #name!accessing!public! !
!GpPropertyItem categoriesFor: #Type!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #Type:!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #typeName!accessing!public! !
!GpPropertyItem categoriesFor: #Value!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #Value:!**compiled accessors**!public! !
!GpPropertyItem categoriesFor: #valueArray!accessing!public! !

!GpPropertyItem class methodsFor!

defineFields
	"Define the fields of the GpPropertyItem structure.
		GpPropertyItem compileDefinition
	
		typedef [uuid(DAD9CD42-C61C-4040-BCD2-2F2E8D725FCA)]
		struct tagGpPropertyItem {
			[helpstring('ID of this property')] unsigned long id;
			[helpstring('Length of the property value, in bytes')] unsigned long length;
			[helpstring('Type of the value, as one of TAG_TYPE_XXX defined above')] unsigned short Type;
			[helpstring('property value')] void* Value;
		} GpPropertyItem;
"

	self
		defineField: #id type: DWORDField new offset: 0;
		defineField: #length type: DWORDField new offset: 4;
		defineField: #Type type: WORDField new offset: 8;
		defineField: #Value type: LPVOIDField new offset: 12.
	self byteSize: 16! !
!GpPropertyItem class categoriesFor: #defineFields!**auto generated**!initializing!public! !

