"Filed out from Dolphin Smalltalk 7"!

CardContainer subclass: #SlidingCardTray
	instanceVariableNames: 'theme slider pinSize pinInteractor _sctReserved1 _sctReserved2'
	classVariableNames: 'PinImageList'
	poolDictionaries: 'TabViewConstants ThemeConstants'
	classInstanceVariableNames: ''!
SlidingCardTray guid: (GUID fromString: '{c8908738-f06b-4eac-89ba-67add22cec3b}')!
SlidingCardTray comment: 'A SlidingCardTray is a specialised <CardContainer> for use in conjunction with a <SlideyInneyOuteyView> to implement a tabbed view which slides out the contained cards when the user hovers over the tabs, and slides them back in again when the user leaves the window for a short while. 

Instance Variables:
	theme		<ExternalHandle>. XP theme handle.
	slider		<SlideyInneyOuteyView>. Owner controlling the slide animation.
	pinSize		<Point>. Size of the pin displayed on the tray caption bar.
	pinInteractor	<ButtonInteractor> for the pin.
	'!
!SlidingCardTray categoriesForClass!MVP-Views! !
!SlidingCardTray methodsFor!

calcClientRectangleFromRectangle: aRectangle 
	| rect |
	self isPinned ifTrue: [^super calcClientRectangleFromRectangle: aRectangle].
	rect := tabs calcClientRectangleFromRectangle: aRectangle.
	self isVertical 
		ifTrue: [self isInverted ifTrue: [rect right: aRectangle right] ifFalse: [rect left: aRectangle left]]
		ifFalse: [self isInverted ifTrue: [rect bottom: aRectangle bottom] ifFalse: [rect top: aRectangle top]].
	^rect!

calculateExtent: aLayoutContext 
	"Private - Answer the calculated extent of the receiver that should be used by a
	layout manager during it's layout process."

	^self layoutManager preferredLayoutExtentOf: self context: aLayoutContext!

captionGeometryChanged
	pinInteractor buttonRectangle: self pinRectangle.
	self invalidateRect: self headerRectangle!

edgeExtent
	^2 @ 2!

freeTheme
	theme notNull ifFalse: [^self].
	ThemeLibrary default closeThemeData: theme.
	theme := nil!

headerBackgroundPart
	^EBP_HEADERBACKGROUND!

headerHeight
	^pinSize y + 2!

headerRectangle
	| rect |
	rect := self clientRectangle.
	^(self isVertical not and: [self isInverted not]) 
		ifTrue: [rect left @ (rect bottom - self headerHeight) corner: rect corner]
		ifFalse: [rect origin extent: rect width @ self headerHeight]!

hitTest: aMouseEvent 
	(self headerRectangle containsPoint: aMouseEvent position) 
		ifTrue: 
			[(pinInteractor hitTest: aMouseEvent) ifTrue: [^#pin].
			^#header].
	^nil!

implicitInsets: aLayoutContext 
	"Private - Answer a <Rectangle> whose edges specify the implicit distance (in pixels) by
	which the sub views have to be inset from the edges of the client area of the receiver."

	"Implementation Note: We must calculate this to allow space for the sliding tray decoration (i.e. the caption bar)."

	^(self isVertical not and: [self isInverted not]) 
		ifTrue: [0 @ 0 corner: 0 @ self headerHeight]
		ifFalse: [0 @ self headerHeight corner: 0 @ 0]!

isPinHot
	^pinInteractor ifNil: [false] ifNotNil: [:value | value isHot]!

isPinned
	^slider notNil and: [slider isPinned]!

isPinPressed
	^pinInteractor isPressed!

isResizable
	^slider notNil and: [slider isTrayResizable]!

isThemed
	^theme notNull!

onLeftButtonPressed: aMouseEvent 
	| hit |
	self class releaseCapture.
	hit := self hitTest: aMouseEvent.
	hit == #pin 
		ifTrue: 
			[self trackMouseOverPin: aMouseEvent.
			^0].
	hit == #header 
		ifTrue: 
			[self trigger: #headerClicked.
			^0].
	^nil!

onMouseMoved: aMouseEvent 
	"Private - Handler for a mouse move event."

	(self hitTest: aMouseEvent) == #pin ifTrue: [self trackMouseOverPin: aMouseEvent].
	^super onMouseMoved: aMouseEvent!

onPaintRequired: aPaintEvent 
	"Private - Paint the tray decoration."

	| canvas |
	canvas := aPaintEvent canvas.
	self isThemed ifTrue: [self paintThemedOn: canvas] ifFalse: [self paintClassicOn: canvas]!

onPositionChanged: aPositionEvent 
	"Private - Handler for window position change (move or resize).
	If resized we must invalidate the header so that the pin is redrawn correctly."

	aPositionEvent isResize ifTrue: [self onResize].
	^super onPositionChanged: aPositionEvent!

onResize
	| rect frameExtent |
	rect := 0 @ 0 extent: self extent.
	frameExtent := self edgeExtent.
	self isVertical 
		ifTrue: 
			[self
				invalidateRect: (RECT origin: rect topLeft extent: rect width @ frameExtent y);
				invalidateRect: (RECT 
							left: rect left
							top: rect bottom - frameExtent y
							right: rect right
							bottom: rect bottom)]
		ifFalse: 
			[self
				invalidateRect: (RECT origin: rect topLeft extent: frameExtent x @ rect height);
				invalidateRect: (RECT 
							left: rect right - frameExtent x
							top: rect top
							right: rect right
							bottom: rect bottom)].
	self captionGeometryChanged!

onViewCreated
	"Private - The receiver has just been fully created. This is a suitable place to perform initialization
	of the window from the receiver's instance variables. Note that this message is sent via
	a WM_PARENTNOTIFY Windows message to the Window's parent, and thus will not be 
	available for views that use the WS_EXNOPARENTNOTIFY extended style, or which are 
	created as immediate children of the desktop or any other Windows not subclassed by Dolphin."

	super onViewCreated.
	self openTheme!

onViewDestroyed
	"Private - Handler for view final view destruction."

	super onViewDestroyed.
	self freeTheme!

openTheme
	theme := super isThemed
				ifTrue: [ThemeLibrary default openThemeData: handle pszClassList: 'EXPLORERBAR' asUtf16String].
	pinSize := SystemMetrics current smallIconExtent asParameter.
	theme isNull
		ifFalse: 
			[ThemeLibrary default
				getThemePartSize: theme
				hdc: nil
				iPartId: EBP_HEADERPIN
				iStateId: EBHP_NORMAL
				prc: nil
				eSize: TS_TRUE
				psz: pinSize].
	pinSize := pinSize asObject!

paintClassicBackgroundOn: aCanvas 
	aCanvas fillRectangle: self headerRectangle color: (Color systemColor: COLOR_INACTIVECAPTION)!

paintClassicEdgesOn: aCanvas 
	self isPinned ifTrue: [^nil].
	"Note that we omit one line of the top-edge in order to give the same appearance as the tab control when pinned"
	UserLibrary default 
		drawEdge: aCanvas asParameter
		qrc: (0 @ -1 corner: self extent) asParameter
		edge: (self isResizable ifTrue: [EDGE_RAISED] ifFalse: [EDGE_ETCHED])
		grfFlags: BF_TOP | BF_RIGHT | BF_BOTTOM | BF_MIDDLE!

paintClassicOn: aCanvas 
	self paintClassicEdgesOn: aCanvas.
	self paintClassicBackgroundOn: aCanvas.
	self paintClassicPinOn: aCanvas!

paintClassicPinOn: aCanvas 
	self pinImageList 
		draw: self pinStateId
		on: aCanvas
		at: self pinRectangle topLeft!

paintEdgesOn: aCanvas 
	aCanvas excludeClipRectangle: (self calcClientRectangleFromRectangle: (0 @ 0 extent: self extent)).
	self isThemed 
		ifTrue: [self paintThemedEdgesOn: aCanvas]
		ifFalse: [self paintClassicEdgesOn: aCanvas]!

paintThemedBackgroundOn: aCanvas 
	ThemeLibrary default 
		drawThemeBackground: theme
		hdc: aCanvas asParameter
		iPartId: self headerBackgroundPart
		iStateId: 0
		pRect: self headerRectangle asParameter
		pClipRect: nil!

paintThemedEdgesOn: aCanvas 
	self isPinned ifTrue: [^nil].
	ThemeLibrary default 
		drawThemeBackground: tabs themeHandle
		hdc: aCanvas asParameter
		iPartId: TABP_PANE
		iStateId: 0
		pRect: aCanvas clipBox asParameter
		pClipRect: nil!

paintThemedOn: aCanvas 
	self paintThemedBackgroundOn: aCanvas.
	self paintThemedPinOn: aCanvas!

paintThemedPinOn: aCanvas 
	ThemeLibrary default 
		drawThemeBackground: theme
		hdc: aCanvas asParameter
		iPartId: EBP_HEADERPIN
		iStateId: self pinStateId
		pRect: self pinRectangle asParameter
		pClipRect: nil!

pinImageList
	| bitmap |
	(PinImageList isNil or: [PinImageList isRealized not]) 
		ifTrue: 
			[| imageList |
			imageList := WinImageList 
						newExtent: 16 @ 16
						depth: 8
						initialSize: 6
						growBy: 1
						masked: true.
			bitmap := Bitmap fromId: 'HeaderPin.bmp'.
			imageList addBitmap: bitmap mask: Color magenta.
			bitmap free.
			PinImageList := imageList].
	^PinImageList!

pinInset
	^2 @ 1!

pinRectangle
	| insetRect |
	insetRect := self headerRectangle insetBy: self pinInset.
	^(self isVertical and: [self isInverted]) 
		ifTrue: [insetRect origin extent: pinSize]
		ifFalse: [(insetRect right - pinSize x) @ insetRect top extent: pinSize]!

pinStateId
	^self isPinned 
		ifTrue: 
			[self isPinHot 
				ifTrue: [self isPinPressed ifTrue: [EBHP_SELECTEDPRESSED] ifFalse: [EBHP_SELECTEDHOT]]
				ifFalse: [EBHP_SELECTEDNORMAL]]
		ifFalse: 
			[self isPinHot 
				ifTrue: [self isPinPressed ifTrue: [EBHP_PRESSED] ifFalse: [EBHP_HOT]]
				ifFalse: [EBHP_NORMAL]]!

setSlider: aSlideyInneyOuteyThing 
	slider := aSlideyInneyOuteyThing.
	tabs := slider tabs.
	self openTheme.
	pinInteractor := (ButtonInteractor forPresenter: self)
				buttonRectangle: self pinRectangle;
				commandDescription: (CommandDescription command: #togglePin description: 'Pin or Unpin the tray');
				yourself!

sizingEdgeInfo
	| rect frameExtent hit |
	rect := self screenRectangle.
	frameExtent := SystemMetrics current sizingFrameExtent.
	hit := self isVertical 
				ifTrue: 
					[self isInverted 
						ifTrue: 
							[rect right: rect left + frameExtent x.
							HTLEFT]
						ifFalse: 
							[rect left: rect right - frameExtent x.
							HTRIGHT]]
				ifFalse: 
					[self isInverted 
						ifTrue: 
							[rect bottom: rect top + frameExtent y.
							HTTOP]
						ifFalse: 
							[rect top: rect bottom - frameExtent y.
							HTBOTTOM]].
	^hit -> rect!

tabOrientation: aSymbol 
	"Set the orientation of the receiver. This primarily controls where the tab strip is
	displayed. The <Symbol> argument can be one of #left, #right, #top (the default) or
	#bottom."

	tabs tabOrientation: aSymbol.
	self captionGeometryChanged!

togglePin
	slider ifNotNil: [slider isPinned: slider isPinned not]!

trackMouseOverPin: aMouseEvent 
	pinInteractor startCaptureOn: aMouseEvent!

wmNcCalcSize: message wParam: wParam lParam: lParam 
	"Private - Handler for a WM_NCCALCSIZE message. Allow for the resizing frame on 3-sides of
	the window (even though only one edge is moveable) when unpinned."

	| params rect rc |
	(self isPinned or: [wParam == 0]) ifTrue: [^nil].
	params := NCCALCSIZE_PARAMS fromAddress: lParam.
	rc := params rgrc at: 1.
	rect := self calcClientRectangleFromRectangle: rc asRectangle.
	rc copyBytes: rect asParameter.
	^0!

wmNcHitTest: message wParam: wParam lParam: lParam 
	"Private - Handler for a WM_NCHITTEST. Look for hits along the tray's resizable edge."

	| edge |
	(self isPinned or: [self isResizable not]) 
		ifTrue: 
			["Not resizable by dragging edge when pinned"
			^nil].
	edge := self sizingEdgeInfo.
	^(edge value containsPoint: lParam lowWord @ lParam highWord) ifTrue: [edge key] ifFalse: [HTCLIENT]!

wmNcPaint: message wParam: wParam lParam: lParam 
	"Private - Paint the non-client area of the window when unpinned."

	| canvas |
	self isPinned ifTrue: [^nil].
	canvas := Canvas forNonClientView: self.
	"canvas excludeClipRectangle: (self calcClientRectangleFromRectangle: canvas clipBox)."
	self paintEdgesOn: canvas.
	canvas free.
	^0!

wmPrint: message wParam: wParam lParam: lParam 
	"Private - Handle WM_PRINT."

	| result |
	self ensureLayoutValid.
	result := self 
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam.
	(lParam allMask: PRF_NONCLIENT) ifTrue: [self paintEdgesOn: (Canvas withNonOwnedDC: wParam)].
	^result! !
!SlidingCardTray categoriesFor: #calcClientRectangleFromRectangle:!event handling-win32!private! !
!SlidingCardTray categoriesFor: #calculateExtent:!geometry!private! !
!SlidingCardTray categoriesFor: #captionGeometryChanged!event handling!private! !
!SlidingCardTray categoriesFor: #edgeExtent!constants!private! !
!SlidingCardTray categoriesFor: #freeTheme!helpers!private! !
!SlidingCardTray categoriesFor: #headerBackgroundPart!constants!private! !
!SlidingCardTray categoriesFor: #headerHeight!constants!private! !
!SlidingCardTray categoriesFor: #headerRectangle!painting!private! !
!SlidingCardTray categoriesFor: #hitTest:!painting!private! !
!SlidingCardTray categoriesFor: #implicitInsets:!accessing!private! !
!SlidingCardTray categoriesFor: #isPinHot!private!testing! !
!SlidingCardTray categoriesFor: #isPinned!private!testing! !
!SlidingCardTray categoriesFor: #isPinPressed!private!testing! !
!SlidingCardTray categoriesFor: #isResizable!private!testing! !
!SlidingCardTray categoriesFor: #isThemed!private!testing! !
!SlidingCardTray categoriesFor: #onLeftButtonPressed:!event handling!private! !
!SlidingCardTray categoriesFor: #onMouseMoved:!event handling!private! !
!SlidingCardTray categoriesFor: #onPaintRequired:!event handling!private! !
!SlidingCardTray categoriesFor: #onPositionChanged:!event handling!private! !
!SlidingCardTray categoriesFor: #onResize!helpers!private! !
!SlidingCardTray categoriesFor: #onViewCreated!event handling!private! !
!SlidingCardTray categoriesFor: #onViewDestroyed!event handling!private! !
!SlidingCardTray categoriesFor: #openTheme!helpers!private! !
!SlidingCardTray categoriesFor: #paintClassicBackgroundOn:!painting!private! !
!SlidingCardTray categoriesFor: #paintClassicEdgesOn:!event handling!private! !
!SlidingCardTray categoriesFor: #paintClassicOn:!painting!private! !
!SlidingCardTray categoriesFor: #paintClassicPinOn:!painting!private! !
!SlidingCardTray categoriesFor: #paintEdgesOn:!painting!private! !
!SlidingCardTray categoriesFor: #paintThemedBackgroundOn:!painting!private! !
!SlidingCardTray categoriesFor: #paintThemedEdgesOn:!event handling!private! !
!SlidingCardTray categoriesFor: #paintThemedOn:!painting!private! !
!SlidingCardTray categoriesFor: #paintThemedPinOn:!painting!private! !
!SlidingCardTray categoriesFor: #pinImageList!accessing!private! !
!SlidingCardTray categoriesFor: #pinInset!constants!private! !
!SlidingCardTray categoriesFor: #pinRectangle!accessing!private! !
!SlidingCardTray categoriesFor: #pinStateId!accessing!private! !
!SlidingCardTray categoriesFor: #setSlider:!initializing!private! !
!SlidingCardTray categoriesFor: #sizingEdgeInfo!helpers!private! !
!SlidingCardTray categoriesFor: #tabOrientation:!accessing-styles!public! !
!SlidingCardTray categoriesFor: #togglePin!commands!public! !
!SlidingCardTray categoriesFor: #trackMouseOverPin:!helpers!private! !
!SlidingCardTray categoriesFor: #wmNcCalcSize:wParam:lParam:!event handling-win32!private! !
!SlidingCardTray categoriesFor: #wmNcHitTest:wParam:lParam:!event handling-win32!private! !
!SlidingCardTray categoriesFor: #wmNcPaint:wParam:lParam:!event handling-win32!private! !
!SlidingCardTray categoriesFor: #wmPrint:wParam:lParam:!event handling-win32!private! !

!SlidingCardTray class methodsFor!

initialize
	PinImageList := nil! !
!SlidingCardTray class categoriesFor: #initialize!public! !

