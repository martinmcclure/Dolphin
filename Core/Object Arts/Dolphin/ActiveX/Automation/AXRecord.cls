"Filed out from Dolphin Smalltalk 7"!

OLEFinalizableStructure subclass: #AXRecord
	instanceVariableNames: 'recordInfo owner'
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants AXAutomationErrors'
	classInstanceVariableNames: ''!
AXRecord guid: (GUID fromString: '{4c783c74-4472-47ad-901f-ceb9de79dd8b}')!
AXRecord comment: ''!
!AXRecord categoriesForClass!Unclassified! !
!AXRecord methodsFor!

basicFree
	"Private - Free external resources owned by the receiver.
	This is a default implementation which relieves subclasses from
	the responsibility of providing both class (freeElement:) and instance 
	side (#basicFree) methods."

	self recordInfo RecordClear: self!

byteSize
	"Answer the <integer> size in bytes of the structure wrapped by the receiver."

	^self recordInfo byteSize!

displayOn: aStream
	| name |
	name := self recordInfo name.
	aStream 
		nextPutAll: (name first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: name!

doesNotUnderstand: aMessage
	"Sent to the receiver by the VM when a message sent to the receiver was 
	not implemented by the receiver or its superclasses. In this case then the 
	selector of aMessage is looked up in the receiver's class' template, and 
	if found the appropriate field is retrieved/set."

	| selector args argc |
	args := aMessage arguments.
	(argc := args size) > 1 ifTrue: [^self basicDoesNotUnderstand: aMessage].
	selector := aMessage selector.
	argc == 0
		ifTrue: [^self getField: selector ifAbsent: [self basicDoesNotUnderstand: aMessage]]
		ifFalse: [self setField: (selector allButLast) value: args first 
				ifAbsent: [self basicDoesNotUnderstand: aMessage]]!

getField: fieldNameString
	"Answer the value of the named field of the receiver,
	or if there is no such field then raise a NotFoundError."

	^self getField: fieldNameString ifAbsent: [self errorNotFound: fieldNameString]!

getField: fieldNameString ifAbsent: exceptionHandler
	"Answer the value of the named field of the receiver,
	or if there is no such field then the result of evaluating the 
	<niladicValuable>, exceptionHandler."

	^self recordInfo getField: fieldNameString from: self ifAbsent: exceptionHandler!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure."

	^self recordInfo getFieldNames!

initialize
	"Private - Initialize the receiver (common to internal [value] and
	external [reference] buffers.
	These objects are finalizable since they reference owned external
	resources."

	"Ask the <IRecordInfo> to create the actual data"

	bytes := self recordInfo RecordCreate.
	super initialize!

initialize: anInteger
	"Private - Create an external buffer in the receiver of the specified size.
	Some subclasses, particularly for Win32 structures, may want to override
	to set their first member to their size."

	self initialize!

initializePointer
	"Private - Perform any initialization required for the receiver
	which is specific to the reference form. Answer the receiver.
	To perform value specific initialization, override #initialize."

	owner isNil ifTrue: [self beFinalizable]!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources."

	^self notNull and: [owner isNil]!

recordInfo
	"Answer the receiver's <IRecordInfo> instance variable."

	^recordInfo!

setField: aString value: anObject 
	"Set the value of the named field of the receiver,
	or if there is no such field then raise a NotFoundError."

	self 
		setField: aString
		value: anObject
		ifAbsent: [self errorNotFound: aString]!

setField: fieldNameString value: newValue ifAbsent: exceptionHandler
	"Set the value of the named field of the receiver, to the
	variant value of the <variantCompatible> object, newValue,
	or if there is no such field then evaluate the <niladicValuable>, 
	exceptionHandler."

	self recordInfo 
		setField: fieldNameString 
		value: newValue 
		into: self
		ifAbsent: exceptionHandler!

setRecordInfo: anIRecordInfo owner: dataOwner
	"Private - Set the receiver's <IRecordInfo> and a back reference to the owner
	of the data which both prevents the data from being GC'd while the receiver
	is referencing it, and which is used to indicate to the receiver that it should
	not free the data itself."

	recordInfo := anIRecordInfo.
	owner := dataOwner! !
!AXRecord categoriesFor: #basicFree!private!realizing/unrealizing! !
!AXRecord categoriesFor: #byteSize!accessing!public! !
!AXRecord categoriesFor: #displayOn:!public! !
!AXRecord categoriesFor: #doesNotUnderstand:!exceptions!public! !
!AXRecord categoriesFor: #getField:!accessing!public! !
!AXRecord categoriesFor: #getField:ifAbsent:!accessing!public! !
!AXRecord categoriesFor: #getValidFields!public! !
!AXRecord categoriesFor: #initialize!initializing!private! !
!AXRecord categoriesFor: #initialize:!initializing!private! !
!AXRecord categoriesFor: #initializePointer!initializing!private! !
!AXRecord categoriesFor: #needsFree!private!realizing/unrealizing! !
!AXRecord categoriesFor: #recordInfo!accessing!public! !
!AXRecord categoriesFor: #setField:value:!accessing!public! !
!AXRecord categoriesFor: #setField:value:ifAbsent:!accessing!public! !
!AXRecord categoriesFor: #setRecordInfo:owner:!accessing!private! !

!AXRecord class methodsFor!

clear: addressOrBytes
	"We can't free an arbitrary structure given its address, because we need to pass it
	back to its originating <IRecordInfo>, therefore these structures can't be stored in
	as values in a <StructureArray>."

	^self shouldNotImplement!

fromAddress: anAddress
	"An <IRecordInfo> describing the receiver's layout must be described.
	Use fromAddress:recordInfo:"

	^self shouldNotImplement!

fromAddress: anAddress recordInfo: recInfo owner: dataOwner
	"Answer a new instance that points to the ExternalAddress 
	respresented by anAddress (which responds to the protocol
	#isNull and #asExternalAddress)."

	| answer |
	answer := super fromAddress: anAddress.
	^answer isNil ifFalse: [answer setRecordInfo: recInfo owner: dataOwner]!

newBuffer
	"Answer a new instance containing its own buffer.
	AXRecords are reference only."

	^self newPointer!

newWithRecordInfo: recInfo
	"Answer a new instance of the receiver that wraps a structure
	as described by the <IRecordInfo>, recInfo."

	^self basicNew
		setRecordInfo: recInfo owner: nil;
		initialize;
		yourself! !
!AXRecord class categoriesFor: #clear:!public!realizing/unrealizing! !
!AXRecord class categoriesFor: #fromAddress:!instance creation!public! !
!AXRecord class categoriesFor: #fromAddress:recordInfo:owner:!instance creation!public! !
!AXRecord class categoriesFor: #newBuffer!instance creation!public! !
!AXRecord class categoriesFor: #newWithRecordInfo:!instance creation!public! !

