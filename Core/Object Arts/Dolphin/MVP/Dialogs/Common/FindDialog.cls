"Filed out from Dolphin Smalltalk 7"!

CommonDialog subclass: #FindDialog
	instanceVariableNames: 'findWhatBuf findDetails'
	classVariableNames: 'HookHandlers'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FindDialog guid: (GUID fromString: '{87b4c6b2-026e-11d3-9fd7-00a0cc3e4a32}')!
FindDialog comment: 'FindDialog is a <valueDialogPresenter> implementing the Windows FindText common dialog. The dialog must be associated with an owner view capable of responding to the <textFinder> protocol. It will then remain on-screen until dismissed and will forward <FindEvent>s to the owner via its #onFind: event handler.

Instance Variables:
	findWhat		<readableString> or nil, specifying the text to search for.

'!
!FindDialog categoriesForClass!MVP-Presenters! !
!FindDialog methodsFor!

basicShowModal
	"Private - Create and show a new FindText dialog."

	^ComDlgLibrary default findText: self winStruct asParameter
!

extractResult: anExternalHandle 
	"Private - Extract and apply the result from the parameter structure passed to the Win32 API
	associated with this common dialog, immediately after the call to that API."

	| dialog |
	anExternalHandle isNil ifTrue: [^nil].
	dialog := self view.
	self assert: [dialog handle = anExternalHandle].
	dialog subclassWindow.
	SessionManager inputState windowAt: anExternalHandle put: dialog!

fdFlags
	| fdFlags |
	fdFlags := FR_ENABLEHOOK.
	findDetails isForwards ifTrue: [fdFlags := fdFlags maskSet: FR_DOWN].
	findDetails isCaseSensitive ifTrue: [fdFlags := fdFlags maskSet: FR_MATCHCASE].
	findDetails isWholeWord ifTrue: [fdFlags := fdFlags maskSet: FR_WHOLEWORD].
	^fdFlags!

findWhat
	"Private - Answer the receivers findWhat String."

	^findWhatBuf!

findWhat: aString 
	"Private - Set the receivers findWhat String to include aString."

	| size |
	findDetails pattern: aString.
	size := self findWhat size min: aString size.
	self findWhat 
		replaceFrom: 1
		to: size
		with: aString
		startingAt: 1!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	findWhatBuf := String newFixed: 256.
	findDetails := FindDetails new!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32 API associated with
	this common dialog, immediately prior to the call to that API."

	(self winStruct)
		lpstrFindWhat: self findWhat;
		maskIn: self fdFlags;
		wFindWhatLen: self findWhat size!

setFindDetails: aFindDetails 
	findDetails := aFindDetails.
	self findWhat: aFindDetails pattern!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^FINDREPLACE! !
!FindDialog categoriesFor: #basicShowModal!private!realizing/unrealizing! !
!FindDialog categoriesFor: #extractResult:!helpers!private! !
!FindDialog categoriesFor: #fdFlags!accessing!private! !
!FindDialog categoriesFor: #findWhat!accessing!private! !
!FindDialog categoriesFor: #findWhat:!accessing!private! !
!FindDialog categoriesFor: #initialize!initializing!private! !
!FindDialog categoriesFor: #prepareStruct!helpers!private! !
!FindDialog categoriesFor: #setFindDetails:!accessing!private! !
!FindDialog categoriesFor: #winStructClass!constants!private! !

!FindDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks!

ownerView: aView
	"Create and show a new instance of the receiver with
	with a aView as the owner."

	^self new
		initialize;
		ownerView: aView;
		showModal;
		yourself!

ownerView: aView findWhat: findString
	"Create and show a new instance of the receiver with
	with a aView as the owner. Pre-populate the dialog with the
	argument findString."

	^self new
		initialize;
		ownerView: aView;
		findWhat: findString;
		showModal;
		yourself!

showModeless: aView on: aFindDetails 
	| dialog |
	dialog := (self new)
				setFindDetails: aFindDetails;
				ownerView: aView.
	"N.B. Doesn't really show as a modal dialog"
	dialog showModal! !
!FindDialog class categoriesFor: #initialize!initializing!private! !
!FindDialog class categoriesFor: #ownerView:!instance creation!public! !
!FindDialog class categoriesFor: #ownerView:findWhat:!instance creation!public! !
!FindDialog class categoriesFor: #showModeless:on:!public! !

