"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusTextureBrushInitializer
	instanceVariableNames: 'image wrapMode rectangle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusTextureBrushInitializer guid: (GUID fromString: '{1a1a5ea3-6151-11d7-b609-00e0987e8081}')!
GdiplusTextureBrushInitializer comment: ''!
!GdiplusTextureBrushInitializer categoriesForClass!Unclassified! !
!GdiplusTextureBrushInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := rectangle isNil 
				ifTrue: 
					[self library 
						gdipCreateTexture: image asParameter
						wrapMode: wrapMode
						texture: gpHandle]
				ifFalse: 
					[self library 
						gdipCreateTexture2I: image asParameter
						wrapMode: wrapMode
						x: rectangle left
						y: rectangle top
						width: rectangle width
						height: rectangle height
						texture: gpHandle].
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating TextureBrush'!

image: anImage wrapMode: aNumber rectangle: aRectangle
	image := anImage.
	wrapMode := aNumber.
	rectangle := aRectangle! !
!GdiplusTextureBrushInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusTextureBrushInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusTextureBrushInitializer categoriesFor: #image:wrapMode:rectangle:!accessing!public! !

!GdiplusTextureBrushInitializer class methodsFor!

image: anImage wrapMode: aNumber rectangle: aRectangle
	^self new 
		image: anImage
		wrapMode: aNumber
		rectangle: aRectangle! !
!GdiplusTextureBrushInitializer class categoriesFor: #image:wrapMode:rectangle:!instance creation!public! !

