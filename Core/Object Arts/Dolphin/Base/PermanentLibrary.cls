"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #PermanentLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PermanentLibrary guid: (GUID fromString: '{87b4c583-026e-11d3-9fd7-00a0cc3e4a32}')!
PermanentLibrary comment: 'PermanentLibrary is the class of <ExternalLibrary>s which are expected to remain permanently open in order for the system to continue functioning. The set of permanent libraries includes all of the basic Win32 system DLLs, the C runtime library, and the Virtual Machine itself. In addition these are not opened lazily to avoid the overhead when accessing the default instance.'!
!PermanentLibrary categoriesForClass!External-Libraries! !
!PermanentLibrary methodsFor!

close
	"Release the reference the receiver has to the External Library it represents. This may
	not cause the library to be unloaded, so it may still function.
	It is really not a good idea to do this for the default instances of permanent libraries 
	because it will break the VM and everything else."

	^self ~~ self class default and: [super close]! !
!PermanentLibrary categoriesFor: #close!public!realizing/unrealizing! !

!PermanentLibrary class methodsFor!

clear
	"Private - Clear down cached external function addresses from previous runs." 

	self clearMethodDictionary: self methodDictionary.!

closeDefault
	"Private - Close the default instance of the receiver (if there is one).
	In the case of the receiver, we ignore this request because the default 
	is not lazily opened."!

default
	"Answer the default instance of the receiver. Override because the PermanentLibraries
	must always be open, and because speed of access to it is important to overall system
	performance."

	^default!

default: anExternalLibrary
	"Set the default instance of the receiver.
	The 'default' instance of permanent libraries cannot be changed."!

onStartup
	"Private - Perform system startup processing for all subclasses.
	Implementation Note: The permanent libraries must be cleared down
	before they are re-opened, otherwise invalid function addresses
	may get called."

	KernelLibrary clear.			"This has to be opened first"
	self allSubclassesDo: [:s |
		s == KernelLibrary ifFalse: [s clear]]!

onStartup2
	"Private - Perform system startup processing for all subclasses.
	Implementation Note: The permanent libraries must be cleared down
	before they are re-opened, otherwise invalid function addresses
	may get called."

	self allSubclassesDo: [:c | c openDefault]! !
!PermanentLibrary class categoriesFor: #clear!initializing!private! !
!PermanentLibrary class categoriesFor: #closeDefault!private!realizing/unrealizing! !
!PermanentLibrary class categoriesFor: #default!accessing!public! !
!PermanentLibrary class categoriesFor: #default:!accessing!public! !
!PermanentLibrary class categoriesFor: #onStartup!event handling!private! !
!PermanentLibrary class categoriesFor: #onStartup2!event handling!private! !

