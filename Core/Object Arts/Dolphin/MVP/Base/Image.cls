"Filed out from Dolphin Smalltalk 7"!

GraphicsTool subclass: #Image
	instanceVariableNames: 'fileLocator identifier instanceHandle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Image guid: (GUID fromString: '{87b4c635-026e-11d3-9fd7-00a0cc3e4a32}')!
Image isAbstract: true!
Image comment: 'Image is the class of <GraphicsTools>s that represent pictures which can be drawn onto the display (or other device).

Instance Variables:
	fileLocator		<fileLocator> used to complete the relative path held as the ''identifier'' when loading the image.
	identifier		<String> identifying the file from which the image was or should be loaded, or the resource identifier.
	instanceHandle	<ExternalLibrary> (usually <ExternalResourceLibrary) represent the module from which the image was loaded.

'!
!Image categoriesForClass!Graphics-Tools! !
!Image methodsFor!

= anObject 
	"Answer whether the receiver and anObject are equivalent.
	Two Images loaded by identifier are equal if they are of the same species, and have the same id and 
	instance handles."

	^self == anObject or: 
			[self species == anObject species and: 
					[self identifier isNil 
						ifTrue: [handle = anObject basicHandle]
						ifFalse: 
							[self identifier = anObject identifier 
								and: [self instanceHandle = anObject instanceHandle]]]]!

addToImageList: aWinImageList mask: aColorOrNil
	"Private - Add a pictorial representation of the receiver to aWinImageList"

	^self subclassResponsibility!

asSharedCopy
	"For compatibility with bitmaps."

	^self!

copy
	^(super copy)
		ownedHandle: self copyHandle;
		yourself!

copyHandle
	"Private - Answer an external handle to the image which is a copy of that represented by the receiver."

	^UserLibrary default 
		copyImage: self handle
		uType: self imageType
		cxDesired: 0
		cyDesired: 0
		fuFlags: 0!

createHandle
	"Private - Answer an external handle to the image represented by the receiver.
	Implementation Note: If the image's instance handle (resource module) is not
	nil, then we first attempt to load from that resource module. If that fails or there
	is no instance handle, but the id is not an integer then we attempt to load from a file.
	If we still haven't loaded the image, then we attempt to load it from the default resource 
	library. If even that fails then the answer will be nil."

	| spec |
	instanceHandle notNil 
		ifTrue: [(self loadFromInstance: instanceHandle) ifNotNil: [:hImage | ^hImage]].
	spec := self fileSpec.
	spec isInteger 
		ifFalse: [(self loadFromFile: spec extent: 0 @ 0) ifNotNil: [:hImage | ^hImage]].
	^self loadFromInstance: SessionManager current defaultResourceLibrary!

drawDisabledOn: aCanvas at: aPoint extent: sizePoint
	"Draw a disabled/grayed representation of the receiver on aCanvas at aPoint with extent sizePoint."

	^self subclassResponsibility

!

drawOn: aCanvas
	"Draw the receiver to aCanvas at position aPoint (no stretching).
	Answer whether the operation succeeded."

	^self drawOn: aCanvas at: Point zero!

drawOn: aCanvas at: aPoint
	"Draw the receiver to aCanvas at position aPoint (no stretching).
	Answer whether the operation succeeded."

	^self drawOn: aCanvas at: aPoint extent: self extent!

drawOn: aCanvas at: aPoint extent: sizePoint
	"Draw the receiver on aCanvas at aPoint with size sizePoint."

	^self subclassResponsibility

!

extent
	"Answers the dimensions of the receiver in pixels"

	^self subclassResponsibility!

fileLocator
	"Answer the file locator for the receiver."

	^fileLocator!

fileLocator: aClassLocator
	"Set the file locator of the receiver. This is used to determine how the image data will
	be located if it is to loaded from a file."

	fileLocator := aClassLocator!

fileSpec
	"Private - Answers the specifier to use when loading the receiver from a file"

	| id |
	^((id := self identifier) isInteger or: [self fileLocator isNil])
		ifTrue: [id]
		ifFalse: [self fileLocator localFileSpecFor: id]
!

freeDC
	"Private - Free the receiver's cached memory DC, if any."

	!

fullIdentifier
	"Private - Answer the full identifier of the receiver. This is a tuple containing
	the class of  Image, the ExternalResourceLibrary (instance handle) 
	and the standard identifier."

	^Array 
		with: self class
		with: self instanceHandle
		with: self identifier!

hash
	"Answer the hash of the identifier. Although #= is implemented to compare
	both identifer and instanceHandles we don't need to take account of the latter
	here since it is only necessary that equal objects have the same hash value not
	vice versa."

	^self identifier hash!

hotspot
	"Answer a Point specifying the receiver's hot spot (only really relevant for cursors)."

	^0@0
!

identifier
	"Answer the identifier of the receiver."

	^identifier

		!

identifier: id
	"Set the identifier of the receiver. This can be a string or an integer."

	identifier := id.
		!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^self subclassResponsibility!

instanceHandle
	"Answers the instance handle for the receiver"

	^instanceHandle!

instanceHandle: aHandle
	"Sets the instance handle for the receiver. This is used to indicate
	the DLL or executable from which the icon will be loaded when it is realized.
	If the instance handle is nil then it will be assumed that the icon should
	be loaded from a file."

	instanceHandle := aHandle.		!

isShared
	"Private - Answer true if the receiver is in the shared cache.
	Shared images must be copied if they will be modified in any way."

	^false!

loadFromFile: pathString extent: aPoint
	"Private - Attempts to load an image of the receivers type from a disk file.
	Answers the image's handle, or nil if the image could not be loaded."

	^UserLibrary default 
		loadImage: 0
		lpszName: pathString asParameter
		uType: self imageType
		cxDesired: aPoint x
		cyDesired: aPoint y
		fuLoad: ##(LR_LOADFROMFILE | LR_COLOR)!

loadFromInstance: hModule
	"Private - Attempts to load the receiver as a resource from an instance.
	Answers nil if the load failed, or the image handle if successful."

	^nil!

pixelData
	"Answer a DWORDArray of the (A)RGB pixel data contained in the receiver. This simple but NOT FAST."

	| pixData n canvas |
	pixData := DWORDArray new: self extent x * self extent y.
	n := 1.
	canvas := self canvas.
	0 to: self extent x-1
		do: 
			[:x | 
			0 to: self extent y -1 
				do: 
					[:y | 
					pixData at: n put: (canvas getPixel: x @ y).
					n := n + 1]].
	canvas free.
	^pixData!

printOn: aStream
	"Append the ASCII representation of the receiver to aStream."

	self identifier 
		ifNil: [self basicPrintOn: aStream]
		ifNotNil: 
			[:id | 
			instanceHandle isNil 
				ifTrue: 
					[aStream
						print: self class;
						space;
						nextPutAll: #fromFile:;
						space;
						print: id]
				ifFalse: 
					[aStream
						print: self class;
						space;
						nextPutAll: #fromId:;
						space;
						print: id]]! !
!Image categoriesFor: #=!comparing!public! !
!Image categoriesFor: #addToImageList:mask:!private!testing! !
!Image categoriesFor: #asSharedCopy!converting!public! !
!Image categoriesFor: #copy!copying!public! !
!Image categoriesFor: #copyHandle!private!realizing/unrealizing! !
!Image categoriesFor: #createHandle!private!realizing/unrealizing! !
!Image categoriesFor: #drawDisabledOn:at:extent:!drawing-bitmaps!public! !
!Image categoriesFor: #drawOn:!drawing-bitmaps!public! !
!Image categoriesFor: #drawOn:at:!drawing-bitmaps!public! !
!Image categoriesFor: #drawOn:at:extent:!drawing-bitmaps!public! !
!Image categoriesFor: #extent!accessing!public! !
!Image categoriesFor: #fileLocator!accessing!public! !
!Image categoriesFor: #fileLocator:!accessing!public! !
!Image categoriesFor: #fileSpec!accessing!private! !
!Image categoriesFor: #freeDC!private!realizing/unrealizing! !
!Image categoriesFor: #fullIdentifier!accessing!private! !
!Image categoriesFor: #hash!comparing!public! !
!Image categoriesFor: #hotspot!accessing!public! !
!Image categoriesFor: #identifier!accessing!public! !
!Image categoriesFor: #identifier:!accessing!public! !
!Image categoriesFor: #imageType!constants!private!testing! !
!Image categoriesFor: #instanceHandle!accessing!public! !
!Image categoriesFor: #instanceHandle:!accessing!public! !
!Image categoriesFor: #isShared!private!testing! !
!Image categoriesFor: #loadFromFile:extent:!private!realizing/unrealizing! !
!Image categoriesFor: #loadFromInstance:!private!realizing/unrealizing! !
!Image categoriesFor: #pixelData!public! !
!Image categoriesFor: #printOn:!printing!public! !

Image methodProtocol: #image attributes: #(#readOnly) selectors: #(#drawOn: #drawOn:at: #drawOn:at:extent: #extent)!

!Image class methodsFor!

fromFile: aFilename
	"Answer an instance loaded from the file aFilename.
	Note that aFilename will be converted to an installation relative path. If you want 
	to access an image at an absolute path, you should set it up using #fromFile:usingLocator:
	in conjuction with an AbsoluteFileLocator. e.g:

		ImagePresenter show: 'Basic image' on: 
			(Bitmap
				fromFile: (File composePath: SessionManager current windowsDirectory 
							subPath: 'Soap Bubbles.bmp')
				usingLocator: FileLocator absolute)
	"

	^self  fromFile: aFilename usingLocator: FileLocator default
!

fromFile: aFilename usingLocator: aFileLocator 
	"Answer an instance loaded from the file aFilename by using aFileLocator."

	| relativeFilename |
	relativeFilename := (aFileLocator isNil or: [File isRelativePath: aFilename]) 
				ifTrue: [aFilename]
				ifFalse: [aFileLocator relativePathTo: aFilename].
	^(self fromId: relativeFilename in: nil)
		fileLocator: aFileLocator;
		yourself!

fromId: anIntegerOrStringId
	"Answer a new instance with a resource Id of anIntegerOrStringId."

	^self fromId: anIntegerOrStringId in: SessionManager current defaultResourceLibrary
!

fromId: anIntegerOrStringId in: anInstanceHandle
	"Answer a new instance with a resourceID of anIntegerOrStringId
	from the application instance anInstanceHandle"

	^super new
		fileLocator: FileLocator default;
		identifier: anIntegerOrStringId;
		instanceHandle: anInstanceHandle;
		yourself
!

fromSystemId: anIntegerId
	"Answer a new instance of the Windows pre-defined icon specified by anIntegerID."

	^self fromId: anIntegerId in: 0.
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

imageManager
	"Answer an image manager to use for storing images"

	^ImageManager new!

stbConvertFrom: anSTBClassFormat 
	"Version 3 adds locator instance variable."

	^
	[:data | 
	| newInstance |
	newInstance := self basicNew.
	anSTBClassFormat version < 3 
		ifTrue: 
			[1 to: data size
				do: 
					[:i | 
					| offset |
					offset := i <= 2 ifTrue: [0] ifFalse: [1].
					newInstance instVarAt: i + offset put: (data at: i)].
			newInstance fileLocator: FileLocator default].
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^3! !
!Image class categoriesFor: #fromFile:!instance creation!public! !
!Image class categoriesFor: #fromFile:usingLocator:!instance creation!public! !
!Image class categoriesFor: #fromId:!instance creation!public! !
!Image class categoriesFor: #fromId:in:!instance creation!public! !
!Image class categoriesFor: #fromSystemId:!instance creation!public! !
!Image class categoriesFor: #icon!constants!public! !
!Image class categoriesFor: #imageManager!accessing!public! !
!Image class categoriesFor: #stbConvertFrom:!binary filing!public! !
!Image class categoriesFor: #stbVersion!binary filing!public! !

