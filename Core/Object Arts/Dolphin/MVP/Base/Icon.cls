"Filed out from Dolphin Smalltalk 7"!

Image subclass: #Icon
	instanceVariableNames: ''
	classVariableNames: 'Blank DefaultApplication Error Information Question Warning WinLogo'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Icon guid: (GUID fromString: '{87b4c63e-026e-11d3-9fd7-00a0cc3e4a32}')!
Icon comment: 'Icon is the class of <Image>s that represent Windows'' icons (essentially a pair of bitmaps, one of which is a mask used to draw the other bitmap transparently).

Class Variables:
	Question			<Icon>. Standard system questionmark icon.
	WinLogo			<Icon>. Standard windows logo icon.
	Blank				<Icon>. A blank icon.
	DefaultApplication	<Icon>. Standard windows "application" icon.
	Information			<Icon>. Standard system information icon, as used in informational message boxes.
	Error				<Icon>. Standard system error icon, as used in error message boxes.
	Warning			<Icon>. Standard system warning icon, as used in warning message boxes.

'!
!Icon categoriesForClass!Graphics-Tools! !
!Icon methodsFor!

addToImageList: aWinImageList mask: aColorOrNil 
	"Private - Add a pictorial representation of the receiver to the <WinImageList>
	argument, using the <Color> argument as the mask colour (although in this
	case the specified mask colour is ignored as the Icon has its own mask)."

	^self valueWithHandle: [:hIcon | aWinImageList addIcon: hIcon] forExtent: aWinImageList extent!

asAlphaBitmap: aPoint 
	"Answer a 32-bpp bitmap (i.e. with Alpha channel) that contains the receiver's
	image rendered at the specified size."

	| bmp |
	bmp := DIBSection 
				width: aPoint x
				height: aPoint y
				depth: 32.
	"Use the services of an ImageList to get the correct sized icon automagically, and to
	provide an alpha channel even if the original icon had no more than a simple mask."
	(self class imageManager imageListWithExtent: aPoint) 
		draw: self imageIndex
		on: bmp canvas
		at: Point zero
		flags: CommCtrlConstants.ILD_PRESERVEALPHA.
	bmp freeDC.
	^bmp!

asCursor
	^Cursor fromOwnedHandle: self detachHandle!

asIcon
	^self!

asMenuBitmap
	"Answer a 32-bpp bitmap (i.e. with alpha channel) containing the receiver's image at system
	menu image extent. Note that the result will be a shared bitmap which is always the same
	instance for the same icon."

	^self class imageManager menuBitmapForIcon: self!

basicFree
	"Private - Free the receiver's Icon resource handle.
	Ignore any error return."

	UserLibrary default destroyIcon: handle!

createHandle
	"Private - Answer an external handle to the image represented by the receiver.
	If the icon is not found, then use the handle of a default icon. 
	We could allow a walkback to occur but this could interfere with the system 
	browsers so we silently display a dummy icon in place of the dud."

	| aHandle |
	^(aHandle := super createHandle) notNil
		ifTrue: [aHandle]
		ifFalse: [ "Use Question icon if not realizable"
			self class question handle]!

drawDisabledOn: aCanvas at: aPoint extent: sizePoint
	"Draw a disabled/grayed representation of the receiver on aCanvas at aPoint with extent sizePoint."

	^UserLibrary default 
		drawState: aCanvas asParameter
		hbr: nil
		lpOutputFunc: nil
		lData: self asParameter asInteger
		wData: 0
		x: aPoint x
		y: aPoint y
		cx: sizePoint x
		cy: sizePoint y
		fuFlags: ##(DST_ICON| DSS_DISABLED)!

drawOn: aCanvas at: aPoint
	"Copies the receiver to aCanvas at position aPoint."

	^self 
		drawOn: aCanvas
		at: aPoint
		frame: 1
		background: nil!

drawOn: aCanvas at: aPoint extent: sizePoint
	"Copies the receiver to aCanvas at position aPoint with size sizePoint."

	^self
		drawOn: aCanvas 
		at: aPoint 
		extent: sizePoint 
		frame: 1 
		background: nil!

drawOn: aCanvas at: aPoint extent: sizePoint frame: anInteger background: aBrush
	"Copies the receiver to aCanvas at position aPoint with size sizePoint
	with frame anInteger and background aBrush."

	^self 
		drawOn: aCanvas 
		at: aPoint 
		extent: sizePoint 
		frame: anInteger 
		background: aBrush 
		flags: DI_NORMAL!

drawOn: aCanvas at: aPoint extent: sizePoint frame: anInteger background: aBrush flags: flagsInteger
	"Copies the receiver to aCanvas at position aPoint with size sizePoint
	with frame anInteger and background aBrush. Answer whether the frame
	could be drawn. Note that the frame number is ignored if the receiver is not
	an animated icon/cursor."

	^UserLibrary default
		drawIconEx: aCanvas asParameter 
		xLeft: aPoint x 
		yTop: aPoint y 
		hIcon: self asParameter
		cxWidth: sizePoint x
		cyHeight: sizePoint y
		istepIfAniCur: anInteger
		hbrFlickerFreeDraw: aBrush asParameter
		diFlags: flagsInteger!

drawOn: aCanvas at: aPoint frame: anInteger background: aBrush
	"Copies the receiver to aCanvas at position aPoint with frame anInteger and 
	background aBrush."

	^self
		drawOn: aCanvas 
		at: aPoint 
		extent: Point zero
		frame: anInteger 
		background: aBrush 
		flags: ##(DI_DEFAULTSIZE|DI_NORMAL)!

extent
	"Answers the dimensions of the receiver in pixels.
	This is determined from the extent of the foreground bitmap, which
	is accessed via GetIconInfo(). Note that we explicitly free
	the ICONINFO in order to release the bmp's."

	| info extent |
	info := self getIconInfo.
	extent := info extent.
	info free.
	^extent!

getIconInfo
	"Private - Answer an ICONINFO structure populated with info. about the receiver.
	N.B. This is quite an expensive operation, as it involves the creation of foreground
	and mask bitmaps for the icon."

	| info |
	info := ICONINFO new.
	(UserLibrary default getIconInfo: self asParameter piconinfo: info)
		ifFalse: [UserLibrary default systemError].
	^info
	!

hotspot
	"Answer a Point specifying the receiver's hot spot (only really relevant for cursors)."

	| info |
	info := self getIconInfo.
	^info
		free; 	"Free up the bitmaps which we don't need"
		xHotspot @ info yHotspot!

imageIndex
	"Answer the image index of the receiver in our ImageManager of all icons."

	^self class imageManager indexOfImage: self.
!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_ICON!

includesFrame: frameNumber
	"Answer whether the receiver contains a frame of frameNumber.
	Sadly we need to attempt to draw the specified frame to determine whether it
	exists (unless we can find another way - suggestions please!!)
	Note that the answer will always be true, regardless of the frame number, if
	the receiver is not an animated cursor."

	| hDC includes screenDC |
	screenDC := UserLibrary default getDC: nil.
	hDC := GDILibrary default createCompatibleDC: screenDC.
	includes := self drawOn: hDC at: Point zero frame: frameNumber background: nil.
	GDILibrary default deleteDC: hDC.
	UserLibrary default releaseDC: nil hDC: screenDC.
	^includes!

load: anObject fromInstance: hModule extent: aPoint 
	"Private - Loads the icon from the module with the requested size. If size is not standard size, this function scales down a larger image instead of scaling up a smaller image
	Note that this function requires Windows Vista or later."

	| hico |
	hico := ExternalHandle new.
	^(CommCtrlLibrary default 
		loadIconWithScaleDown: hModule
		pszName: anObject asParameter
		cx: aPoint x
		cy: aPoint y
		phico: hico) >= 0 
		ifTrue: [hico]!

loadFromInstance: hModule
	"Private - Attempts to load the receiver as a resource from an instance. 
	I would have expected the User32 loadImage function to be capable of this but
	it does not appear to work for instance 0; the system. Hence this method 
	which tries the old way. Answers the loaded handle or nil if the load failed"

	^UserLibrary default loadIcon: hModule asParameter lpIconName: identifier asParameter!

valueWithHandle: operation forExtent: aPoint 
	"Private - Evaluate the <monadicValuable>, operation, with a handle for the receiver's icon at the best possible
	rendering for the specified extent. On Vista and later platforms the icon will be scaled down from the next largest
	icon if the requested size is not available."

	| hModule ident |
	self handle = self class question handle 
		ifTrue: 
			["If the icon failed to load, the standard question icon will have been substituted"
			hModule := 0.
			ident := self class question identifier]
		ifFalse: 
			[ident := self identifier.
			hModule := instanceHandle asParameter].
	hModule isNull 
		ifTrue: 
			["If loaded from a file or a standard system icon, then need to reload to ensure has correct extent"
			instanceHandle isNil 
				ifTrue: 
					[(self loadFromFile: self fileSpec extent: aPoint) ifNotNil: [:hIcon | ^operation value: hIcon]]
				ifFalse: 
					[(hModule == 0 
						and: [aPoint ~= SystemMetrics current largeIconExtent and: [SystemMetrics current hasIconScaleDown]]) 
							ifTrue: 
								[(self 
									load: ident
									fromInstance: hModule
									extent: aPoint) ifNotNil: [:hIcon | ^operation value: hIcon]]]].
	^operation value: self asParameter! !
!Icon categoriesFor: #addToImageList:mask:!double dispatch!private! !
!Icon categoriesFor: #asAlphaBitmap:!converting!public! !
!Icon categoriesFor: #asCursor!public! !
!Icon categoriesFor: #asIcon!public! !
!Icon categoriesFor: #asMenuBitmap!converting!public! !
!Icon categoriesFor: #basicFree!private!realizing/unrealizing! !
!Icon categoriesFor: #createHandle!private!realizing/unrealizing! !
!Icon categoriesFor: #drawDisabledOn:at:extent:!drawing-bitmaps!public! !
!Icon categoriesFor: #drawOn:at:!drawing-bitmaps!public! !
!Icon categoriesFor: #drawOn:at:extent:!drawing-bitmaps!public! !
!Icon categoriesFor: #drawOn:at:extent:frame:background:!drawing-bitmaps!public! !
!Icon categoriesFor: #drawOn:at:extent:frame:background:flags:!drawing-bitmaps!public! !
!Icon categoriesFor: #drawOn:at:frame:background:!drawing-bitmaps!public! !
!Icon categoriesFor: #extent!accessing!public! !
!Icon categoriesFor: #getIconInfo!helpers!private! !
!Icon categoriesFor: #hotspot!accessing!public! !
!Icon categoriesFor: #imageIndex!accessing!public! !
!Icon categoriesFor: #imageType!constants!private! !
!Icon categoriesFor: #includesFrame:!public!searching! !
!Icon categoriesFor: #load:fromInstance:extent:!private!realizing/unrealizing! !
!Icon categoriesFor: #loadFromInstance:!private!realizing/unrealizing! !
!Icon categoriesFor: #valueWithHandle:forExtent:!helpers!private!wine fix! !

!Icon class methodsFor!

asterisk
	"Answer a new instance of the Asterisk icon (used in informative messages)"

	^self information!

blank
	Blank isNil ifTrue: [Blank := self fromId: 'Blank.ico'].
	^Blank!

clear
	"Clean up the image manager for all icons. We start with no image representation
	for our icons, they are added lazily as they are accessed usng #imageIndex."

	self imageManager purge!

defaultApplication
	"Answer a new instance of the default application icon"

	DefaultApplication isNil ifTrue: [DefaultApplication := self fromSystemId: IDI_APPLICATION].
	^DefaultApplication
!

defaultExtent
	"Answer a Point that gives the dimensions of a standard size icon."

	^self largeExtent
!

error
	"Answer a new instance of the default system 'error' icon (used in serious warning messages)"

	Error isNil ifTrue: [Error := self fromSystemId: IDI_ERROR].
	^Error!

exclamation
	"Answer a new instance of the Exclamation mark icon (used in warning messages)"

	^self warning!

extraLargeExtent
	^256 @ 256!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Icon Files (*.ico)' '*.ico')!

hand
	"Answer a new instance of the Hand-shaped icon (used in serious warning messages)"

	^self error
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

imageManager
	"Answer the image manager to use for storing icons"

	^IconImageManager current!

information
	"Answer a new instance of the default system 'information' icon (used in informative messages)"

	Information isNil ifTrue: [Information := self fromSystemId: IDI_INFORMATION].
	^Information!

largeExtent
	"Answer a <Point> that gives the dimensions of a standard size icon."

	^SystemMetrics current largeIconExtent!

null
	^NullIcon current!

onPreStripImage
	"Private - The image is about to be stripped. Nil out the cached converter to (potentially)
	allow RichTextEdit to be stripped."

	self uninitialize!

onStartup2
	"Private - Perform system startup processing for all subclasses."

	self clear!

question
	"Answer a new instance of the Question mark icon (used in prompting messages)"

	Question isNil ifTrue: [Question := self fromSystemId: IDI_QUESTION].
	^Question!

smallExtent
	"Answer a <Point> that gives the dimensions of a small size icon."

	^SystemMetrics current smallIconExtent!

tileExtent
	"Answer a Point that gives the dimensions of a tile size icon."

	#todo. "Is there a system metric for this?"

	^48 @ 48!

uninitialize
	"Uninitialize the class variables of the receiver."

	Blank := Error := Warning := Information := Question := WinLogo := DefaultApplication := nil!

warning
	"Answer a new instance of the default system 'warning' icon (used in warning messages)"

	Warning isNil ifTrue: [Warning := self fromSystemId: IDI_WARNING].
	^Warning!

window
	"Answer a new instance of the default Windows icon"

	WinLogo isNil ifTrue: [WinLogo := self fromSystemId: IDI_WINLOGO].
	^WinLogo! !
!Icon class categoriesFor: #asterisk!instance creation!public! !
!Icon class categoriesFor: #blank!instance creation!public! !
!Icon class categoriesFor: #clear!initializing!public! !
!Icon class categoriesFor: #defaultApplication!instance creation!public! !
!Icon class categoriesFor: #defaultExtent!constants!public! !
!Icon class categoriesFor: #error!instance creation!public! !
!Icon class categoriesFor: #exclamation!instance creation!public! !
!Icon class categoriesFor: #extraLargeExtent!constants!public! !
!Icon class categoriesFor: #filesType!constants!private! !
!Icon class categoriesFor: #hand!instance creation!public! !
!Icon class categoriesFor: #icon!constants!public! !
!Icon class categoriesFor: #imageManager!accessing!public! !
!Icon class categoriesFor: #information!instance creation!public! !
!Icon class categoriesFor: #largeExtent!constants!public! !
!Icon class categoriesFor: #null!instance creation!public! !
!Icon class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Icon class categoriesFor: #onStartup2!event handling!private! !
!Icon class categoriesFor: #question!instance creation!public! !
!Icon class categoriesFor: #smallExtent!constants!public! !
!Icon class categoriesFor: #tileExtent!constants!public! !
!Icon class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Icon class categoriesFor: #warning!instance creation!public! !
!Icon class categoriesFor: #window!instance creation!public! !

