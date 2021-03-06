"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromIconInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromIconInitializerTest guid: (GUID fromString: '{bf0526be-e212-4666-8678-2c66a571d808}')!
GdiplusBitmapFromIconInitializerTest comment: ''!
!GdiplusBitmapFromIconInitializerTest categoriesForClass!Unclassified! !
!GdiplusBitmapFromIconInitializerTest methodsFor!

gdipCreateBitmapFromHICON: hicon bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusBitmapFromIconInitializer new library: self!

testCreateHandle
	| icon |
	icon := GdiplusBitmap icon.
	model icon: icon.
	model createHandle.
	self assert: constructorArgs size = 2.
	self assert: constructorArgs first == icon basicHandle.
	self assertLastArgIsHandle!

testCreateHandleRealizesIcon
	| icon |
	icon := Icon fromId: 43 in: ShellLibrary default.
	model icon: icon.
	self assert: icon basicHandle isNil.
	model createHandle.
	self assert: icon basicHandle notNil! !
!GdiplusBitmapFromIconInitializerTest categoriesFor: #gdipCreateBitmapFromHICON:bitmap:!accessing!public! !
!GdiplusBitmapFromIconInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapFromIconInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusBitmapFromIconInitializerTest categoriesFor: #testCreateHandleRealizesIcon!public!unit tests! !

