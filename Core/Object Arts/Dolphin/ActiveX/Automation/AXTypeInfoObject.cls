"Filed out from Dolphin Smalltalk 7"!

Object subclass: #AXTypeInfoObject
	instanceVariableNames: 'tlbInterface generationFlags'
	classVariableNames: 'ClassCommentStyleMap GuidClash HighLevelWrapperStyleMap SuperclassClash TracingStyleMap'
	poolDictionaries: 'AXAutomationConstants AXTypeGenerationFlags'
	classInstanceVariableNames: ''!
AXTypeInfoObject guid: (GUID fromString: '{27440177-dfab-46d4-bf61-a8fada69a263}')!
AXTypeInfoObject isAbstract: true!
AXTypeInfoObject comment: '
	
Instance Variables:
	tlbInterface			<ITypeLib>|<ITypeInfo> COM interface onto type library information relevant to this type element.
	generationFlags		<integer> (or nil) flags from the AXTypeGenerationFlags pool controlling code generation.

Class Variables:
	GuidClash			<WarningSignal> raised when a duplicate GUID belonging to an apparently mismatched class is detected.
	SuperclassClash		<WarningSignal>

'!
!AXTypeInfoObject categoriesForClass!Kernel-Objects! !
!AXTypeInfoObject methodsFor!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses)."

	^self tlbInterface!

attributes
	"Answer a <TYPEATTR> detailing the receiver's attributes - may raise an <HRESULTError>."

	^self subclassResponsibility!

basicName
	"Private - Answer a <readableString> name for the receiver, retrieved directly
	from the documentation in the type library."

	^self subclassResponsibility!

documentation
	"Answer an <AXTypeLibDocumentation> object containing the documentation for this type."

	^self subclassResponsibility!

environment
	"Answer the namespace into which global's representing the receiver's types are/have been generated."

	^self class environment!

free
	"Release the receiver's type library pointer."

	tlbInterface isNil ifTrue: [^self].
	tlbInterface free.
	tlbInterface := nil!

globalBinding
	"Private - Answer the global binding (or the proposed global binding) for the receiver."

	^self subclassResponsibility!

globalName
	"Answer the name of the generated object which represents the receiver in Smalltalk.
	Implementation Note: If we haven't already got the globalName, then note that we
	don't store it down, but recalculate it each time. This is deliberate: Until we've
	actually generated the global object, we want to allow for changes in the values
	which feed into the name generation algorithm (e.g. the typelib prefix is
	changed)."

	^self globalBinding key!

guid
	"Answer the a <GUID> which uniquely identifies the receiver."

	^self attributes guid!

helpfile
	"Answer the path to the receiver's help file."

	^self documentation helpfile!

helpstring
	"Answer the documentation string for the receiver, if any."

	^self documentation helpstring!

isHidden
	"Answer whether the receiver is describing a type which should
	not be displayed in type library browsers."

	^self attributes isHidden!

isInstalled
	"Answer whether the receiver has been generated into a global (normally a class) in this image"

	^self subclassResponsibility!

isNull
	"Answer whether the receiver is a null external data item
	(that is, a null pointer, or a nilled out structure)."

	^tlbInterface isNull!

isRestricted
	"Answer whether the receiver is describing a restricted type (i.e. one not
	intended to be used from macro/scripting languages).
	Applicable to all typekinds."

	^self attributes isRestricted!

name
	"Answer a <readableString> name for the receiver, retrieved from the
	documentation, but potentially with some mangling applied to generate
	a more sensible name (e.g. one more reminiscent of the original IDL)."

	^self basicName!

realize
	"Private - Load the receiver's COM interface from its owning type library."

	^self subclassResponsibility!

suggestedGlobalName
	"Private - Answer a <readableString> name suggested as the (unprefixed) for a global
	generated to represent the receiver's type."

	^self name!

tlbInterface
	tlbInterface isNull ifTrue: [self realize].
	^tlbInterface! !
!AXTypeInfoObject categoriesFor: #asParameter!converting!public! !
!AXTypeInfoObject categoriesFor: #attributes!accessing!public! !
!AXTypeInfoObject categoriesFor: #basicName!accessing!private! !
!AXTypeInfoObject categoriesFor: #documentation!accessing!public! !
!AXTypeInfoObject categoriesFor: #environment!constants!public! !
!AXTypeInfoObject categoriesFor: #free!public!realizing/unrealizing! !
!AXTypeInfoObject categoriesFor: #globalBinding!accessing!private! !
!AXTypeInfoObject categoriesFor: #globalName!accessing!public! !
!AXTypeInfoObject categoriesFor: #guid!accessing!public! !
!AXTypeInfoObject categoriesFor: #helpfile!accessing!public! !
!AXTypeInfoObject categoriesFor: #helpstring!accessing!public! !
!AXTypeInfoObject categoriesFor: #isHidden!public!testing! !
!AXTypeInfoObject categoriesFor: #isInstalled!public!testing! !
!AXTypeInfoObject categoriesFor: #isNull!public!testing! !
!AXTypeInfoObject categoriesFor: #isRestricted!public!testing! !
!AXTypeInfoObject categoriesFor: #name!accessing!public! !
!AXTypeInfoObject categoriesFor: #realize!private!realizing/unrealizing! !
!AXTypeInfoObject categoriesFor: #suggestedGlobalName!accessing!private! !
!AXTypeInfoObject categoriesFor: #tlbInterface!accessing!private! !

