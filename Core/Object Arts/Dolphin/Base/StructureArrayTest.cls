"Filed out from Dolphin Smalltalk 7"!

GenericExternalArrayTest subclass: #StructureArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArrayTest guid: (GUID fromString: '{1ab5e35e-9c82-4aa7-9c28-f51cb3baa646}')!
StructureArrayTest comment: ''!
!StructureArrayTest categoriesForClass!Unclassified! !
!StructureArrayTest methodsFor!

arrayClass
	^StructureArray!

elementClass
	^SDWORD!

newArrayOfIntegers: anArray 
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])
		elementClass: self elementClass! !
!StructureArrayTest categoriesFor: #arrayClass!constants!private! !
!StructureArrayTest categoriesFor: #elementClass!helpers!private! !
!StructureArrayTest categoriesFor: #newArrayOfIntegers:!helpers!private! !

