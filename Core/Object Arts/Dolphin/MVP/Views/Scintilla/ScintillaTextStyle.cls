"Filed out from Dolphin Smalltalk 7"!

ScintillaAttribute subclass: #ScintillaTextStyle
	instanceVariableNames: 'forecolor backcolor flags faceName centiPointSize characterSet case name description weight _reserved1'
	classVariableNames: 'EolFilledMask HotspotMask InvisibleMask ItalicMask PredefinedStyleNames ReadOnlyMask UnderlinedMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaTextStyle guid: (GUID fromString: '{441d5422-db7d-4872-a16d-d6ca9d88e0b8}')!
ScintillaTextStyle addClassConstant: 'EolFilledMask' value: 192!
ScintillaTextStyle addClassConstant: 'HotspotMask' value: 3072!
ScintillaTextStyle addClassConstant: 'InvisibleMask' value: 12288!
ScintillaTextStyle addClassConstant: 'ItalicMask' value: 12!
ScintillaTextStyle addClassConstant: 'ReadOnlyMask' value: 768!
ScintillaTextStyle addClassConstant: 'UnderlinedMask' value: 48!
ScintillaTextStyle comment: 'ScintillaStyle instances represent the visual styles that can be applied to colour text in a particular <ScintillaView>.

There are a number of predefined styles:
	#normal - the default style used to draw all unstyled text, and from which user-defined styles inherit.
	#braceHighlight - style used to highlight matching braces (where the brace highlighting feature is implemented)
	#mismatchedBrace - style used to highlight mismatched braces (where the brace highlighting feature is implemented)
	#controlChar - style used to draw control characters such as Form Feed when these are present in the text.
	#lineNumber - style used to draw text in the line number margin, and to control the background colour of all margins except the fold margin.
	#indentGuide - style used to draw indentation guides
	#callTip - style used for call tips.
	
With the exception of #normal, these styles are present to allow control over the presentation of particular features, but they cannot themselves be set against regions of text. Note that some styling, such as that used for visible whitespace, is controlled independently of the normal text style definitions  by directly setting properties of the ScintillaView.

Up to 256 styles can be defined per view. These have symbolic names for use in Smalltalk code, and have id''s allocated automatically. The predefined styles listed above have ids which Scintilla recognises specifically, with ids between STYLE_DEFAULT (32) and STYLE_LASTPREDEFINED (39). In addition style id 0 is reserved for "normal", which (somewhat confusingly given the existance of STYLE_DEFAULT) is the style applied to text by default and from which all the other styles inherit any unspecified properties. See the Scintilla docs for further details of the predefined styles. All other styles are user-defined, can have any symbolic name, and are allocated an unused id in the range 1..255. 

The instance variables of all styles specify the differences from the default (or "normal") style, so any that are nil imply inheritance of that aspect from the special #normal style (which has style id 0). In turn the #normal style "inherits" any unspecified font and color settings from those aspects of the view itself. 

Note that Scintilla style information is now queryable from the control, but this was not the case when the Dolphin wrapper was originally designed so ScintillaTextStyle is not a <QueryableScintillaAttribute> like <ScintillaIndicatorStyle>.

Instance Variables:
	forecolor	<Color>. Text foreground colour.
	backcolor	<Color>. Background colour.
	flags		<integer> Various flags controlling font appearance, etc.
	faceName	<String>. Font face name.
	pointSize	<integer>. Font size in points.
	characterSet	<integer>. Font character set.
	case		<integer>. Font case type
	name		<Symbol>. Symbolic name of the visual style.
	description	<String>. Optional description of the style, useful for presentation in user preferences dialogs.

Class Variables:
	ItalicMask			<integer> bitmask used to specify an italic font in ''flags'' inst. var.
	PredefinedStyleNames	<IdentityDictionary> mapping <Symbol> to <integer> style code for all fixed/predefined styles.
	BoldMask			<integer> bitmask used to specify a bold font in ''flags'' inst. var.
	UnderlinedMask		<integer> bitmask used to specify an underlined font in ''flags'' inst. var.
	ChangeableMask		<integer> bitmask used to control whether the marked text is protected from editing.
	EolFilledMask		<integer> bitmask used to specify whether the backcolor is extended to the end-of-line.
	HotspotMask		<integer> bitmask used to specify whether the marked text should be treated as a hotspot.'!
!ScintillaTextStyle categoriesForClass!MVP-Views-Support! !
!ScintillaTextStyle methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument are considered equivalent. A pair of
	<ScintillaTextStyle>s are only considered equivalent if all attributes are equal."

	^anObject class == self species and: 
			[self name = anObject name and: 
					[self flags = anObject flags and: 
							[self forecolor = anObject forecolor and: 
									[self backcolor = anObject backcolor and: 
											[self fontName = anObject fontName and: 
													[self centiPointSize = anObject centiPointSize and: 
															[self weight = anObject weight
																and: [self characterSet = anObject characterSet and: [self case = anObject case]]]]]]]]]!

backcolor
	^backcolor!

backcolor: aColorOrNil 
	backcolor = aColorOrNil ifTrue: [^self].
	backcolor := aColorOrNil!

basicId
	^id ifNil: [name ifNotNil: [self setPredefinedId]]!

case
	^case!

case: anIntegerOrNil 
	case = anIntegerOrNil ifTrue: [^self].
	case := anIntegerOrNil!

caseName
	^self case ifNotNil: [:enum | self class caseNames at: enum+1]!

caseName: aSymbolOrNil 
	self case: (aSymbolOrNil ifNotNil: [(self class caseNames indexOf: aSymbolOrNil) - 1])!

centiPointSize
	^centiPointSize!

centiPointSize: aNumberOrNil 
	centiPointSize := aNumberOrNil!

characterSet
	^characterSet!

characterSet: anIntegerOrNil 
	characterSet = anIntegerOrNil ifTrue: [^self].
	characterSet := anIntegerOrNil!

clearFont
	"Clear all font settings so that these are inherited."

	faceName := centiPointSize := characterSet := nil.
	flags := flags maskClear: ItalicMask | UnderlinedMask.
	weight := nil!

description
	^description ifNil: [self name ifNotNil: [:string | string asPhrase]]!

description: aString 
	"Set the user-defined description of this text style to the specified <String>."

	description := (aString notNil and: [aString notEmpty]) ifTrue: [aString]!

displayOn: aStream 
	aStream nextPutAll: self name displayString asPhrase!

flags
	^flags!

font
	"Answer a font configured with the receiver's settings."

	| answer |
	answer := self fontName ifNil: [Font default] ifNotNil: [:face | Font name: face].
	self restyleFont: answer.
	^answer!

font: aFont 
	self clearFont.
	self mergeFont: aFont!

fontName
	^faceName!

fontName: aStringOrNil 
	faceName = aStringOrNil ifTrue: [^self].
	faceName := aStringOrNil!

forecolor
	^forecolor!

forecolor: aColorOrNil 
	forecolor := aColorOrNil!

getThreeStateFlag: anInteger
	^#(nil true false) at: ((flags bitAnd: anInteger) >> (anInteger lowBit - 1)) + 1!

initialize
	super initialize.
	flags := 0.
!

isBackcolorExtendedToEndOfLine
	"Answer whether the background colour of this style will be extended to the end of the line if the last 
	visible character on the line has this style. This corresponds to SCI_STYLESETEOLFILLED, see
	the Scintilla documentation for further details."

	^self getThreeStateFlag: EolFilledMask!

isBackcolorExtendedToEndOfLine: aBooleanOrNil 
	"Set whether the background colour of this style will be extended to the end of the line if the last 
	visible character on the line has this style. This corresponds to SCI_STYLESETEOLFILLED, see
	the Scintilla documentation for further details."

	self setThreeStateFlag: EolFilledMask value: aBooleanOrNil!

isBold
	"Answer true if the receiver's font is bold, false if regular weight, or nil if not specified."

	^self weight ifNotNil: [:w | w >= SC_WEIGHT_BOLD]!

isBold: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is bold. If the argument is nil, then this style has no effect on the default
	font."

	self 
		weight: (aBooleanOrNil ifNotNil: [:bold | bold ifTrue: [SC_WEIGHT_BOLD] ifFalse: [SC_WEIGHT_NORMAL]])!

isChangeable
	^self isReadOnly ifNotNil: [:readOnly | readOnly not]!

isHotspot
	"Answer true if the text marked with this style is a hotspot that can detect
	mouse clicks, e.g. for hypertext linking.."

	^self getThreeStateFlag: HotspotMask!

isHotspot: aBooleanOrNil 
	"Set whether the text marked with this style is a hotspot that can detect
	mouse clicks, e.g. for hypertext linking.."

	self setThreeStateFlag: HotspotMask value: aBooleanOrNil!

isInvisible
	"Answer whether text marked with this style is hidden."

	^self getThreeStateFlag: InvisibleMask!

isInvisible: aBooleanOrNil 
	"Set  whether text marked with this style is hidden."

	self setThreeStateFlag: InvisibleMask value: aBooleanOrNil!

isItalic
	"Answer true if the receiver's font is italic, false if regular, or nil if not specified."

	^self getThreeStateFlag: ItalicMask!

isItalic: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is italic. If the argument is nil, then this  style has no effect on the default
	font."

	self setThreeStateFlag: ItalicMask value: aBooleanOrNil!

isPredefined
	"Answer whether the receiver represents one of the styles pre-defined by Scintilla."

	| n |
	n := self name.
	^n isInteger not and: [PredefinedStyleNames includesKey: n]!

isReadOnly
	"Answer true if the text marked with this style is protected against editing."

	^(self getThreeStateFlag: ReadOnlyMask)!

isReadOnly: aBooleanOrNil 
	"Set whether the text marked with this style will be protected against editing."

	self setThreeStateFlag: ReadOnlyMask value: aBooleanOrNil!

isUnderlined
	"Answer true if the receiver's font is underlined, false if regular weight, or nil if not specified."

	^self getThreeStateFlag: UnderlinedMask!

isUnderlined: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is underlined. If the argument is nil, then this style has no effect on the default
	font."

	self setThreeStateFlag: UnderlinedMask value: aBooleanOrNil!

isVisible
	"Private - Answer whether text marked with this style is visible."

	^(self getThreeStateFlag: InvisibleMask) ifNotNil: [:invisible | invisible not]!

mergeFont: aFont 
	"Initialize any font settings that are currently unspecified from the <Font> argument."

	faceName ifNil: [faceName := aFont name].
	centiPointSize ifNil: [self pointSize: aFont pointSize].
	self isItalic ifNil: [self setThreeStateFlag: ItalicMask value: aFont isItalic].
	self isBold ifNil: [self isBold: aFont isBold].
	self isUnderlined ifNil: [self setThreeStateFlag: UnderlinedMask value: aFont isUnderlined].
	characterSet ifNil: [characterSet := aFont characterSet]!

name
	^name ifNil: ['style', self id displayString]!

name: anObject
	name = anObject ifTrue: [^self].
	anObject isInteger
		ifTrue: [name := id := anObject]
		ifFalse: 
			[(anObject isNil or: [anObject isEmpty])
				ifTrue: [name := id := nil]
				ifFalse: 
					[name := anObject asSymbol.
					self setPredefinedId]]!

pointSize
	^centiPointSize 
		ifNotNil: 
			[:cp | 
			"Try and provide an integer, if the pointSize is whole"
			| points fraction |
			points := cp / 100.0.
			fraction := points asApproximateFraction.
			fraction isInteger ifTrue: [fraction] ifFalse: [points]]!

pointSize: aNumberOrNil 
	centiPointSize := aNumberOrNil ifNotNil: [:i | (i * 100) rounded]!

restyleFont: aFont 
	self pointSize ifNotNil: [:points | aFont pointSize: points].
	self isItalic ifNotNil: [:isItalic | aFont isItalic: isItalic].
	self weight ifNotNil: [:w | aFont weight: w].
	self isUnderlined ifNotNil: [:isUnderlined | aFont isUnderlined: isUnderlined].
	self characterSet ifNotNil: [:set | aFont characterSet: set]!

setPredefinedId
	^id := PredefinedStyleNames lookup: name!

setThreeStateFlag: anInteger value: aBooleanOrNil
	| state |
	state := aBooleanOrNil isNil 
				ifTrue: [0]
				ifFalse: 
					[aBooleanOrNil 
						ifTrue: [(anInteger bitShift: -1) bitAnd: anInteger]
						ifFalse: [(anInteger bitShift: 1) bitAnd: anInteger]].
	flags := (flags maskClear: anInteger) maskSet: state!

storeableProperties
	| attribs |
	attribs := super storeableProperties.
	name ifNotNil: [attribs := (Array with: #name) , attribs].
	^attribs!

view
	^nil!

view: aScintillaView 
	!

weight
	^weight!

weight: anInteger 
	weight := anInteger! !
!ScintillaTextStyle categoriesFor: #=!comparing!public! !
!ScintillaTextStyle categoriesFor: #backcolor!accessing!public! !
!ScintillaTextStyle categoriesFor: #backcolor:!accessing!public! !
!ScintillaTextStyle categoriesFor: #basicId!accessing!private! !
!ScintillaTextStyle categoriesFor: #case!accessing!public! !
!ScintillaTextStyle categoriesFor: #case:!accessing!public! !
!ScintillaTextStyle categoriesFor: #caseName!accessing!public! !
!ScintillaTextStyle categoriesFor: #caseName:!accessing!public! !
!ScintillaTextStyle categoriesFor: #centiPointSize!accessing!public! !
!ScintillaTextStyle categoriesFor: #centiPointSize:!accessing!public! !
!ScintillaTextStyle categoriesFor: #characterSet!accessing!public! !
!ScintillaTextStyle categoriesFor: #characterSet:!accessing!public! !
!ScintillaTextStyle categoriesFor: #clearFont!accessing!public! !
!ScintillaTextStyle categoriesFor: #description!accessing!public! !
!ScintillaTextStyle categoriesFor: #description:!accessing!public! !
!ScintillaTextStyle categoriesFor: #displayOn:!displaying!public! !
!ScintillaTextStyle categoriesFor: #flags!accessing!public! !
!ScintillaTextStyle categoriesFor: #font!accessing!public! !
!ScintillaTextStyle categoriesFor: #font:!accessing!public! !
!ScintillaTextStyle categoriesFor: #fontName!accessing!public! !
!ScintillaTextStyle categoriesFor: #fontName:!accessing!public! !
!ScintillaTextStyle categoriesFor: #forecolor!accessing!public! !
!ScintillaTextStyle categoriesFor: #forecolor:!accessing!public! !
!ScintillaTextStyle categoriesFor: #getThreeStateFlag:!helpers!private! !
!ScintillaTextStyle categoriesFor: #initialize!initializing!private! !
!ScintillaTextStyle categoriesFor: #isBackcolorExtendedToEndOfLine!public!testing! !
!ScintillaTextStyle categoriesFor: #isBackcolorExtendedToEndOfLine:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isBold!public!testing! !
!ScintillaTextStyle categoriesFor: #isBold:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isChangeable!private!testing! !
!ScintillaTextStyle categoriesFor: #isHotspot!public!testing! !
!ScintillaTextStyle categoriesFor: #isHotspot:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isInvisible!public!testing! !
!ScintillaTextStyle categoriesFor: #isInvisible:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isItalic!public!testing! !
!ScintillaTextStyle categoriesFor: #isItalic:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isPredefined!public!testing! !
!ScintillaTextStyle categoriesFor: #isReadOnly!public!testing! !
!ScintillaTextStyle categoriesFor: #isReadOnly:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isUnderlined!public!testing! !
!ScintillaTextStyle categoriesFor: #isUnderlined:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isVisible!private!testing! !
!ScintillaTextStyle categoriesFor: #mergeFont:!accessing!public! !
!ScintillaTextStyle categoriesFor: #name!accessing!public! !
!ScintillaTextStyle categoriesFor: #name:!accessing!public! !
!ScintillaTextStyle categoriesFor: #pointSize!accessing!public! !
!ScintillaTextStyle categoriesFor: #pointSize:!accessing!public! !
!ScintillaTextStyle categoriesFor: #restyleFont:!accessing!public! !
!ScintillaTextStyle categoriesFor: #setPredefinedId!accessing!private! !
!ScintillaTextStyle categoriesFor: #setThreeStateFlag:value:!helpers!private! !
!ScintillaTextStyle categoriesFor: #storeableProperties!development!printing!private! !
!ScintillaTextStyle categoriesFor: #view!accessing!private! !
!ScintillaTextStyle categoriesFor: #view:!accessing!private! !
!ScintillaTextStyle categoriesFor: #weight!accessing!public! !
!ScintillaTextStyle categoriesFor: #weight:!accessing!public! !

!ScintillaTextStyle class methodsFor!

caseNames
	^#(#mixed #upper #lower #camel)!

icon
	^Font icon!

initialize
	"
		self initialize
	"

	| predefinedStyleNames |
	self addClassConstant: 'ItalicMask' value: 2r1100.
	self addClassConstant: 'UnderlinedMask' value: 2r110000.
	self addClassConstant: 'EolFilledMask' value: 2r11000000.
	self addClassConstant: 'ReadOnlyMask' value: 2r1100000000.
	self addClassConstant: 'HotspotMask' value: 2r110000000000.
	self addClassConstant: 'InvisibleMask' value: 2r11000000000000.
	propertyMap := (IdentityDictionary new)
				at: #forecolor
					put: (ScintillaPropertyDescriptor
							getSelector: #forecolor
							defaultValue: Color black
							setMessage: SCI_STYLESETFORE);
				at: #backcolor
					put: (ScintillaPropertyDescriptor
							getSelector: #backcolor
							defaultValue: Color white
							setMessage: SCI_STYLESETBACK);
				at: #fontName
					put: (ScintillaPropertyDescriptor
							getSelector: #fontName
							defaultValue: nil
							setMessage: SCI_STYLESETFONT);
				at: #isBold
					put: (ScintillaPropertyDescriptor
							getSelector: #isBold
							defaultValue: false
							setMessage: SCI_STYLESETBOLD);
				at: #isItalic
					put: (ScintillaPropertyDescriptor
							getSelector: #isItalic
							defaultValue: false
							setMessage: SCI_STYLESETITALIC);
				at: #isUnderlined
					put: (ScintillaPropertyDescriptor
							getSelector: #isUnderlined
							defaultValue: false
							setMessage: SCI_STYLESETUNDERLINE);
				at: #case
					put: (ScintillaPropertyDescriptor
							getSelector: #case
							defaultValue: SC_CASE_MIXED
							setMessage: SCI_STYLESETCASE);
				at: #characterSet
					put: (ScintillaPropertyDescriptor
							getSelector: #characterSet
							defaultValue: SC_CHARSET_DEFAULT
							setMessage: SCI_STYLESETCHARACTERSET);
				at: #pointSize
					put: (ScintillaPropertyDescriptor
							getSelector: #centiPointSize
							defaultValue: nil
							setMessage: SCI_STYLESETSIZEFRACTIONAL);
				at: #isBackcolorExtendedToEndOfLine
					put: (ScintillaPropertyDescriptor
							getSelector: #isBackcolorExtendedToEndOfLine
							defaultValue: false
							setMessage: SCI_STYLESETEOLFILLED);
				at: #isChangeable
					put: (ScintillaPropertyDescriptor
							getSelector: #isChangeable
							defaultValue: true
							setMessage: SCI_STYLESETCHANGEABLE);
				at: #isHotspot
					put: (ScintillaPropertyDescriptor
							getSelector: #isHotspot
							defaultValue: false
							setMessage: SCI_STYLESETHOTSPOT);
				at: #isVisible
					put: (ScintillaPropertyDescriptor
							getSelector: #isVisible
							defaultValue: true
							setMessage: SCI_STYLESETVISIBLE);
				at: #weight
					put: (ScintillaPropertyDescriptor
							getSelector: #weight
							defaultValue: SC_WEIGHT_NORMAL
							setMessage: SCI_STYLESETWEIGHT);
				shrink;
				isImmutable: true;
				yourself.
	predefinedStyleNames := IdentityDictionary new: STYLE_LASTPREDEFINED + 1.
	STYLE_NORMAL + 1 to: STYLE_LASTPREDEFINED do: [:each | predefinedStyleNames at: each put: each].
	"These are not really Scintilla pre-defined styles, but some additional ones we add for convenience in the wrapping"
	predefinedStyleNames
		at: #normal put: STYLE_NORMAL;
		yourself.
	predefinedStyleNames
		removeKey: STYLE_BRACELIGHT;
		at: #braceHighlight put: STYLE_BRACELIGHT;
		removeKey: STYLE_BRACEBAD;
		at: #braceMismatch put: STYLE_BRACEBAD;
		removeKey: STYLE_CONTROLCHAR;
		at: #controlChar put: STYLE_CONTROLCHAR;
		removeKey: STYLE_LINENUMBER;
		at: #lineNumber put: STYLE_LINENUMBER;
		removeKey: STYLE_INDENTGUIDE;
		at: #indentGuide put: STYLE_INDENTGUIDE;
		removeKey: STYLE_CALLTIP;
		at: #callTip put: STYLE_CALLTIP;
		removeKey: STYLE_FOLDDISPLAYTEXT;
		at: #foldDisplayText put: STYLE_FOLDDISPLAYTEXT;
		removeKey: STYLE_DEFAULT.
	predefinedStyleNames
		isImmutable: true;
		shrink.
	self addClassConstant: 'PredefinedStyleNames' value: predefinedStyleNames!

name: aSymbol 
	^(self new)
		name: aSymbol;
		yourself!

new
	^super new initialize!

normal
	^(self name: #normal)
		description: 'Default text style';
		yourself!

stbConvertFrom: anSTBClassFormat 
	^
	[:vars | 
	| instance |
	instance := self new.
	vars keysAndValuesDo: [:eachKey :eachValue | instance instVarAt: eachKey put: eachValue].
	"Scintilla now supports fractional point size, so convert old instance pointSize stored in the same inst var"
	instance pointSize: instance centiPointSize.
	"Weight is now stored as an integer value, rather than just a bold flag (BoldMask as 2r11)."
	instance isBold: (instance getThreeStateFlag: 2r11).
	instance]!

stbVersion
	^1! !
!ScintillaTextStyle class categoriesFor: #caseNames!constants!public! !
!ScintillaTextStyle class categoriesFor: #icon!constants!public! !
!ScintillaTextStyle class categoriesFor: #initialize!initializing!public! !
!ScintillaTextStyle class categoriesFor: #name:!instance creation!public! !
!ScintillaTextStyle class categoriesFor: #new!instance creation!public! !
!ScintillaTextStyle class categoriesFor: #normal!instance creation!public! !
!ScintillaTextStyle class categoriesFor: #stbConvertFrom:!binary filing!private! !
!ScintillaTextStyle class categoriesFor: #stbVersion!binary filing!public! !

