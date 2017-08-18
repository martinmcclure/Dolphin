"Filed out from Dolphin Smalltalk 7"!

SelectableTreeItemsTest subclass: #TreePresenterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TreePresenterTest guid: (GUID fromString: '{152b5f25-c97c-404f-8e88-b8a27c9e8ffc}')!
TreePresenterTest comment: ''!
!TreePresenterTest categoriesForClass!Unclassified! !
!TreePresenterTest methodsFor!

classToTest
	^TreePresenter!

testChangedEventOrder
	"https://github.com/dolphinsmalltalk/Dolphin/issues/453"

	| textEdit events list handle rect |
	list := #('first' 'last').
	presenter model: (TreeModel new
		add: list first asChildOf: nil;
		add: list last asChildOf: nil;
		yourself).
	presenter selection: list first.
	events := OrderedCollection new.
	[
		textEdit := TextEdit show.
		textEdit topShell view screenRectangle: (100@100 extent: 200@80).
		presenter topShell view screenRectangle: (150@200 extent: 300@200).
		textEdit view position: presenter view position x @ (presenter view position y - textEdit view extent y).
		textEdit when: #valueChanged send: #value to: [events add: 'a'].
		presenter when: #selectionChanged send: #value to: [events add: 'b'].
		handle := presenter view handleFromObject: list last ifAbsent: [self error: 'Not found!!'].
		rect := presenter view itemRect: handle.
		textEdit view setFocus.
		textEdit value: 'aaa'; isTextModified: true.
		self leftClickAt: rect center.
		self waitForInputIdle.
		rect halt.
	] ensure: [
		textEdit topShell close
	].
! !
!TreePresenterTest categoriesFor: #classToTest!helpers!private! !
!TreePresenterTest categoriesFor: #testChangedEventOrder!public! !

