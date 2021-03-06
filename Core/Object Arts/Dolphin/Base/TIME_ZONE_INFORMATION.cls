"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TIME_ZONE_INFORMATION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TIME_ZONE_INFORMATION guid: (GUID fromString: '{ceb846ce-f4db-48fe-9fec-02e637cbc4b4}')!
TIME_ZONE_INFORMATION comment: '<TIME_ZONE_INFORMATION> is an <ExternalStructure> class to wrap the struct ''Win32.TIME_ZONE_INFORMATION'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(ceb846ce-f4db-48fe-9fec-02e637cbc4b4)]
struct tagTIME_ZONE_INFORMATION {
	[readonly] long Bias;
	[readonly, string] unsigned short StandardName[32];
	[readonly] SYSTEMTIME StandardDate;
	[readonly] long StandardBias;
	[readonly, string] unsigned short DaylightName[32];
	[readonly] SYSTEMTIME DaylightDate;
	[readonly] long DaylightBias;
} TIME_ZONE_INFORMATION;
'!
!TIME_ZONE_INFORMATION categoriesForClass!Win32-Structs! !
!TIME_ZONE_INFORMATION methodsFor!

bias
	"Answer the <Integer> value of the receiver's 'bias' field."

	^bytes sdwordAtOffset: 0!

daylightBias
	"Answer the <Integer> value of the receiver's 'daylightBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #daylightBias)!

daylightDate
	"Answer the <SYSTEMTIME> value of the receiver's 'daylightDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #daylightDate)!

daylightName
	"Answer the <Utf16String> value of the receiver's 'daylightName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #daylightName)!

printableFields
	| printable |
	printable := super printableFields.
	printable remove: #StandardDate; remove: #DaylightDate.
	^printable!

standardBias
	"Answer the <Integer> value of the receiver's 'standardBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #standardBias)!

standardDate
	"Answer the <SYSTEMTIME> value of the receiver's 'standardDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #standardDate)!

standardName
	"Answer the <Utf16String> value of the receiver's 'standardName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #standardName)! !
!TIME_ZONE_INFORMATION categoriesFor: #bias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightName!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #printableFields!development!printing!private! !
!TIME_ZONE_INFORMATION categoriesFor: #standardBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #standardDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #standardName!**compiled accessors**!public! !

!TIME_ZONE_INFORMATION class methodsFor!

defineFields
	"Define the fields of the TIME_ZONE_INFORMATION structure.

	TIME_ZONE_INFORMATION compileDefinition

		typedef [uuid(ceb846ce-f4db-48fe-9fec-02e637cbc4b4)]
		struct tagTIME_ZONE_INFORMATION {
			[readonly] long Bias;
			[readonly, string] unsigned short StandardName[32];
			[readonly] SYSTEMTIME StandardDate;
			[readonly] long StandardBias;
			[readonly, string] unsigned short DaylightName[32];
			[readonly] SYSTEMTIME DaylightDate;
			[readonly] long DaylightBias;
		} TIME_ZONE_INFORMATION;
"

	self
		defineField: #bias type: SDWORDField new beReadOnly offset: 0;
		defineField: #standardName type: (StringField type: Utf16String length: 32) beReadOnly offset: 4;
		defineField: #standardDate type: (StructureField type: SYSTEMTIME) beReadOnly offset: 68;
		defineField: #standardBias type: SDWORDField new beReadOnly offset: 84;
		defineField: #daylightName type: (StringField type: Utf16String length: 32) beReadOnly offset: 88;
		defineField: #daylightDate type: (StructureField type: SYSTEMTIME) beReadOnly offset: 152;
		defineField: #daylightBias type: SDWORDField new beReadOnly offset: 168.
	self byteSize: 172! !
!TIME_ZONE_INFORMATION class categoriesFor: #defineFields!initializing!public! !

