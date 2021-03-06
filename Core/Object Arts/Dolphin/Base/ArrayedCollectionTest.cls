"Filed out from Dolphin Smalltalk 7"!

SequenceableCollectionTest subclass: #ArrayedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayedCollectionTest guid: (GUID fromString: '{48d15c8e-983b-48d0-8c62-51b644ba6bdb}')!
ArrayedCollectionTest isAbstract: true!
ArrayedCollectionTest comment: ''!
!ArrayedCollectionTest categoriesForClass!Unclassified! !
!ArrayedCollectionTest methodsFor!

testReplaceIdentityWith
	| a rep |
	a := self newCollection: #($1 $2 $3 $3 $5).
	rep := self assimilate: $0.
	a replaceIdentity: (self assimilate: $1) with: rep.
	self assert: a = (self newCollection: #($0 $2 $3 $3 $5)).
	a replaceIdentity: (self assimilate: $3) with: rep.
	self assert: a = (self newCollection: #($0 $2 $0 $3 $5)).
	a replaceIdentity: (self assimilate: $5) with: rep.
	self assert: a = (self newCollection: #($0 $2 $0 $3 $0)).
	a replaceIdentity: (self assimilate: $6) with: rep.
	self assert: a = (self newCollection: #($0 $2 $0 $3 $0 $0))! !
!ArrayedCollectionTest categoriesFor: #testReplaceIdentityWith!public!unit tests! !

