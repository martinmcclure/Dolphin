"Filed out from Dolphin Smalltalk 7"!

VirtualTreeModel subclass: #ClassHierarchyModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassHierarchyModel guid: (GUID fromString: '{87b4c673-026e-11d3-9fd7-00a0cc3e4a32}')!
ClassHierarchyModel comment: 'ClassHierarchyModel implements a <treeModel> representing the hierarchy (or a subset of it) of <Class>es in the system.'!
!ClassHierarchyModel categoriesForClass!Development!MVP-Models! !
!ClassHierarchyModel methodsFor!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: This does not have to be accurate, but it should be fast
	(i.e. don't calculate it by counting the receiver's elements)."

	^500!

defaultGetChildrenBlock
	^[:aClass | aClass subclasses]!

defaultGetParentBlock
	^[:aClass | aClass superclass]!

observeEnvironment
	(self class environment)
		when: #classAdded:
			send: #onClassAdded:
			to: self;
		when: #classUpdated:
			send: #onClassUpdated:
			to: self;
		when: #classRemoved:
			send: #onClassRemoved:
			to: self!

onClassAdded: aClass
	self add: aClass asChildOf: aClass superclass!

onClassRemoved: aClass
	self remove: aClass
!

onClassUpdated: aClass
	"Note that we only trigger #item:movedToParent: events if the updated class
	is a <Class>, not if it is a <Metaclass>."

	aClass isMeta ifFalse: [self move: aClass asChildOf: aClass superclass].
	self refresh: aClass ifAbsent: []!

setRoots: aCollection 
	"Private - Initialize the receiver with the roots in aCollection"

	super setRoots: aCollection.
	self observeEnvironment! !
!ClassHierarchyModel categoriesFor: #approxSize!accessing!private! !
!ClassHierarchyModel categoriesFor: #defaultGetChildrenBlock!initializing!private! !
!ClassHierarchyModel categoriesFor: #defaultGetParentBlock!initializing!private! !
!ClassHierarchyModel categoriesFor: #observeEnvironment!initializing!private! !
!ClassHierarchyModel categoriesFor: #onClassAdded:!event handling!public! !
!ClassHierarchyModel categoriesFor: #onClassRemoved:!event handling!public! !
!ClassHierarchyModel categoriesFor: #onClassUpdated:!event handling!public! !
!ClassHierarchyModel categoriesFor: #setRoots:!initializing!private! !

!ClassHierarchyModel class methodsFor!

withAllClasses
	"Answer an instance of the receiver on the entire class hiearchy"

	^self withRoots: Smalltalk allRoots
! !
!ClassHierarchyModel class categoriesFor: #withAllClasses!instance creation!public! !

