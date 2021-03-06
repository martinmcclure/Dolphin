"Filed out from Dolphin Smalltalk 7"!

ExternalField subclass: #EmbeddedField
	instanceVariableNames: 'fieldClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedField guid: (GUID fromString: '{87b4c4da-026e-11d3-9fd7-00a0cc3e4a32}')!
EmbeddedField comment: 'EmbeddedField is the abstract class of <ExternalField>s that describe fields of <ExternalStructure>s that are directly embedded in the structure itself, as opposed to being pointers to external memory where the data resides.

Instance Variables:
	fieldClass		<Class> of Smalltalk object that can be used to represent the data stored in the field.'!
!EmbeddedField categoriesForClass!External-Data-Types! !
!EmbeddedField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self fieldClass alignment!

byteSize
	"Private - Answer the byte size of the embedded ExternalStructure the
	receiver represents"

	^self fieldClass byteSize!

fieldClass
	"Private - Answer the class of <ExternalStructure> used to represent the 
	type of this field."

	^fieldClass!

fieldClass: aClass
	"Private - Set the class of object to be used to represent the ExternalField in
	Smalltalk. Answer the receiver."

	fieldClass := aClass!

fieldClassName
	"Private - Answer the name of the class of object to be used to represent 
	the embedded field described by the receiver."

	^self fieldClass name!

printAccessorExpression: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will read the value of this field from an instance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	"Note that if returning an ExternalStructure subclass, then the resulting object will be a
	reference (an alias) to the original structure embedded in the contents of the receiving
	ExternalStructure, and therefore modifications to it will also modify the complete
	ExternalStructure. If, however, the structureClass is some other object which responds to
	#fromAddress:, the answer may be a copy of the embedded structure (e.g. subclasses of
	External) - so care is needed when updating the result."

	aWriteStream
		nextPutAll: self fieldClassName;
		nextPutAll: ' fromAddress: (';
		nextPutAll: 'bytes';
		nextPutAll: ' yourAddress'.
	self offset = 0 
		ifFalse: 
			[aWriteStream
				space;
				display: #+;
				space.
			self printOffsetExpression: aSymbol on: aWriteStream].
	aWriteStream nextPut: $)!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; 
		print: self offset;
		nextPutAll: ': ';
		nextPutAll: self fieldClassName;
		nextPut: $)
! !
!EmbeddedField categoriesFor: #alignment!constants!public! !
!EmbeddedField categoriesFor: #byteSize!accessing!private! !
!EmbeddedField categoriesFor: #fieldClass!accessing!private! !
!EmbeddedField categoriesFor: #fieldClass:!accessing!private! !
!EmbeddedField categoriesFor: #fieldClassName!accessing!private! !
!EmbeddedField categoriesFor: #printAccessorExpression:on:!automatic generation!development!private! !
!EmbeddedField categoriesFor: #printOn:!printing!public! !

!EmbeddedField class methodsFor!

new
	"Private - Answer an instance of the receiver which describes an embedded attribute.
	This is an error because embedded attributes must include a type, and possibly
	a length."

	^self shouldNotImplement! !
!EmbeddedField class categoriesFor: #new!instance creation!private! !

