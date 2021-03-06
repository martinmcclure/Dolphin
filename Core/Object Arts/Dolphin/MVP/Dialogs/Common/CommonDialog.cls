"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #CommonDialog
	instanceVariableNames: 'winStruct hook'
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants Win32Constants'
	classInstanceVariableNames: 'hookHandlers'!
CommonDialog guid: (GUID fromString: '{87b4c6a8-026e-11d3-9fd7-00a0cc3e4a32}')!
CommonDialog isAbstract: true!
CommonDialog comment: 'CommonDialog is an abstract <valueDialogPresenter> superclass for all Windows common dialogs.

Instance Variables:
	winStruct		<Win32Structure> used to configure the system dialog.
	unused		<UndefinedObject> reserved for future use.

Class Instance Variables:
	hookHandlers	<IdentityDictionary> mapping <integer> message codes to the <Symbol>ic selectors of the message handler methods.


'!
!CommonDialog categoriesForClass!MVP-Presenters! !
!CommonDialog methodsFor!

attachHandle: anExternalHandle 
	"Private - Create a DialogView to represent the receiver's view."

	| dialog |
	dialog := DialogView fromHandle: anExternalHandle.
	self view: dialog!

basicShowModal
	"Private - Create and show a new instance of this common dialog."

	^self subclassResponsibility!

checkError
	| err |
	err := ComDlgLibrary default commDlgExtendedError.
	^err = 0 ifFalse: [self error: ('Common dialog error: <1d>' expandMacrosWith: err)]!

createHook
	^self class hookHandlers
		ifNotNil: 
			[:handlers |
			ExternalCallback block: 
					[:hdlg :uiMsg :wParam :lParam |
					view isNil ifTrue: [self attachHandle: hdlg].
					(handlers lookup: uiMsg)
						ifNil: [0]
						ifNotNil: 
							[:selector |
							(self
								perform: selector
								with: uiMsg
								with: wParam
								with: lParam) asUIntPtr]]
				argumentTypes: 'handle dword uintptr uintptr']!

extractResult: apiResult
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	^self subclassResponsibility!

initialize
	"Private - Initialize the receiver"

	winStruct := self winStructClass new.
	super initialize.

!

ownerView: aView
	"Private - Set the receivers ownerView to aView."

	super ownerView: aView.
	self winStruct ownerView: aView.!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32
	API associated with this common dialog, immediately prior to the call
	to that API."

	!

setViewIcon: anIcon
	"Set the icon of a view opened on the receiver.
	We don't want to foist our icon onto the common dialogs, so override to do nothing."!

showModal
	"Create and show the receiver's modal dialog. Answer the 'result' (as defined by the
	subclass) or nil if no selection was made."

	"Implemenation Note: The common dialogs steal the message loop and send WM_ENTERIDLE
	messages only erratically. We therefore start up the idle timer to allow us to run
	background processes now and again."

	| apiResult owner wasEnabled hitType |
	hook := self createHook.
	hook notNil ifTrue: [self winStruct hook: hook].
	self prepareStruct.
	owner := self ownerView ifNil: [View active].
	wasEnabled := owner isEnabled.
	apiResult := 
			[SessionManager inputState startIdleTimer: owner.
			hook notNil ifTrue: [view := nil].
			self basicShowModal] 
					ensure: [SessionManager inputState stopIdleTimer: owner].
	hitType := wasEnabled 
				ifTrue: [HTCLIENT]
				ifFalse: 
					[owner isEnabled: false.
					HTERROR].
	"Reset the view's cursor in case control does not return to message loop"
	UserLibrary default 
		sendMessage: owner asParameter
		msg: WM_SETCURSOR
		wParam: 0
		lParam: hitType.
	self extractResult: apiResult.
	^self answer!

updateIcon
	"Private - Transfer any icon across to the view. The common dialogs do not
	require icons so do nothing"!

winStruct
	"Private - Answer the receiver's associated windows parameter structure."

	^winStruct

!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^self subclassResponsibility!

wmInitDialog: message wParam: wParam lParam: lParam 
	"Private - A WM_INITDIALOG message was sent to the hook procedure. This is sent after the common
	dialog itself has handled the message."

	self caption ifNotNil: [:text | self view caption: text].
	^1! !
!CommonDialog categoriesFor: #attachHandle:!private!realizing/unrealizing! !
!CommonDialog categoriesFor: #basicShowModal!private!realizing/unrealizing! !
!CommonDialog categoriesFor: #checkError!helpers!private! !
!CommonDialog categoriesFor: #createHook!helpers!private! !
!CommonDialog categoriesFor: #extractResult:!helpers!private! !
!CommonDialog categoriesFor: #initialize!accessing!initializing!private! !
!CommonDialog categoriesFor: #ownerView:!accessing!private! !
!CommonDialog categoriesFor: #prepareStruct!helpers!private! !
!CommonDialog categoriesFor: #setViewIcon:!operations!public! !
!CommonDialog categoriesFor: #showModal!public!realizing/unrealizing! !
!CommonDialog categoriesFor: #updateIcon!private!updating! !
!CommonDialog categoriesFor: #winStruct!accessing!private! !
!CommonDialog categoriesFor: #winStructClass!constants!private! !
!CommonDialog categoriesFor: #wmInitDialog:wParam:lParam:!event handling-win32!private! !

!CommonDialog class methodsFor!

defaultView
	"Answer the resource name of the default view for the receiver."

	self shouldNotImplement!

hookHandlers
	^hookHandlers!

initializeDefaultHooks
	hookHandlers := IdentityDictionary new.
	hookHandlers at: WM_INITDIALOG put: #wmInitDialog:wParam:lParam:!

showModal
	"Creates a default instance of the receiver and displays it modal 
	to the current active window. 
	Answers the result of the dialog if confirmed or nil otherwise"

	^self new showModal!

showModal: aDialogResourceNameString
	"Private - Should not implement. CommonDialogs can only use the view provided
	by the operating system."

	^self shouldNotImplement!

showModal: aDialogResourceNameString on: aModel
	"Private - Should not implement. CommonDialogs can only use the view provided
	by the operating system."

	^self shouldNotImplement
!

showModalOn: aModel
	"Creates an instance of the receiver connected to aModel. 
	The view is displayed modal to the current active window. 
	Answers the result of dialog if confirmed or nil otherwise"

	^(self on: aModel) showModal! !
!CommonDialog class categoriesFor: #defaultView!constants!public! !
!CommonDialog class categoriesFor: #hookHandlers!accessing!private! !
!CommonDialog class categoriesFor: #initializeDefaultHooks!initializing!private! !
!CommonDialog class categoriesFor: #showModal!instance creation!public! !
!CommonDialog class categoriesFor: #showModal:!instance creation!private! !
!CommonDialog class categoriesFor: #showModal:on:!instance creation!private! !
!CommonDialog class categoriesFor: #showModalOn:!instance creation!public! !

