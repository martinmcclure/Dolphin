"Filed out from Dolphin Smalltalk 7"!

MethodCategory subclass: #VirtualMethodCategory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VirtualMethodCategory guid: (GUID fromString: '{87b4c504-026e-11d3-9fd7-00a0cc3e4a32}')!
VirtualMethodCategory isAbstract: true!
VirtualMethodCategory comment: 'VirtualMethodCategory is the class of method categories whose membership is calculated on demand rather than looked up in the method catalogue of the method''s class. As virtual categories usually have no static record in the image, they typically carry no space overhead. This is a significant benefit for the privacy categories ''private'' and ''public'' (membership of which is determined by a bit flag in the method header), as every method in the system is in one or the other. The downside is that querying the membership of the category takes more time, although this is not likely to be noticeable in normal operation.

VirtualMethodCategory itself is abstract, but provides much of the implementation for simple virtual categories, which typically need implement only #includesMethod:

Virtual method categories are sometimes referred to as pseudo-categories.

Instance Variables:
	None

Class Variables:
	None'!
!VirtualMethodCategory categoriesForClass!Development! !
!VirtualMethodCategory methodsFor!

addMethodSilently: aCompiledMethod 
	"Private - Add the <CompiledMethod> argument to the set of methods that are members
	of this category. Pseudo-categories have a calculated membership and typically can't be
	added to in this manner, so the default is to do nothing."

	!

behaviorsDo: aMonadicValuable 
	self class environment allBehaviorsDo: aMonadicValuable!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	This is the only method that must be implemented in subclasses."

	^self subclassResponsibility!

isSlowToEnumerate
	"Answer whether this method category is slow to enumerate. This may be the case for certain
	calculated categories."

	^false!

isVirtual
	"Answer whether the receiver is a virtual category, i.e. one that has 
	calculated contents. All pseudo-categories are virtual, but not vice versa."

	^true!

methodsInBehavior: aBehavior do: aMonadicValuable 
	aBehavior methodDictionary 
		do: [:each | (self includesMethod: each) ifTrue: [aMonadicValuable value: each]]!

removeMethodSilently: aCompiledMethod 
	"Private - Remove the <CompiledMethod> argument from the set of 
	methods that are members of the receiver, and make no fuss about it.
	In general the membership of pseudo-categories is generated and in 
	order to remove a method it is necessary to modify it so that it no longer
	fits the membership criteria of the category, therefore the default is to
	do nothing here."

	! !
!VirtualMethodCategory categoriesFor: #addMethodSilently:!adding!private! !
!VirtualMethodCategory categoriesFor: #behaviorsDo:!enumerating!public! !
!VirtualMethodCategory categoriesFor: #includesMethod:!public!testing! !
!VirtualMethodCategory categoriesFor: #isSlowToEnumerate!public!testing! !
!VirtualMethodCategory categoriesFor: #isVirtual!public!testing! !
!VirtualMethodCategory categoriesFor: #methodsInBehavior:do:!enumerating!public! !
!VirtualMethodCategory categoriesFor: #removeMethodSilently:!private!removing! !

