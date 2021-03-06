"Filed out from Dolphin Smalltalk 7"!

SmalltalkParser subclass: #RBPatternParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBPatternParser guid: (GUID fromString: '{efae231d-9476-470e-9bef-e65273b2f157}')!
RBPatternParser comment: 'RBPatternParser is an extended <SmalltalkParser> that supports the RB''s extended syntax for pattern matching trees. The resulting trees are used as inputs to the <ParseTreeSearcher> and <ParseTreeRewriter> for searching and transforming source code (respectively).
'!
!RBPatternParser categoriesForClass!Refactory-Parser! !
!RBPatternParser methodsFor!

evaluateStatements: anStSequenceNode 
	^nil!

messageNodeClass
	^RBPatternMessageNode!

methodNodeClass
	^RBPatternMethodNode!

parameterNodeClass
	^RBPatternVariableNode!

parseLiteralByteArrayObject
	(currentToken isIdentifier and: [currentToken isPatternVariable]) 
		ifTrue: 
			[| node |
			node := self variableNodeClass identifierToken: currentToken.
			node isLiteralNode 
				ifTrue: 
					[self step.
					^node]].
	^super parseLiteralByteArrayObject!

parsePatternBlock: aClass 
	| position node |
	position := currentToken start.
	self step.
	node := self parseBlockArgsInto: aClass new.
	node left: position.
	node body: (self parseStatementsOf: node allowTag: false).
	#rbFix.	"Use #isSpecial: and Dolphin compiler compatible error reporting"
	(currentToken isSpecial: $}) ifFalse: [self parserError: CErrBraceNotClosed].
	node right: currentToken start.
	self step.
	^node!

parsePrimitiveLiteral
	(currentToken isIdentifier and: [currentToken isPatternVariable])
		ifTrue: 
			[| node |
			node := self variableNodeClass identifierToken: currentToken.
			node isLiteralNode
				ifTrue: 
					[self step.
					^node].
			currentToken := RBLiteralToken
						start: currentToken start
						comments: nil
						value: currentToken value asSymbol
						stop: currentToken stop].
	^super parsePrimitiveLiteral!

parsePrimitiveObject
	currentToken isPatternBlock ifTrue: [^self parsePatternBlock: RBPatternBlockNode].
	^super parsePrimitiveObject!

parseUnaryMessage
	| node |
	node := self parsePrimitiveObject.
	self addCommentsTo: node.
	
	[currentToken isLiteralToken ifTrue: [self patchLiteralMessage].
	currentToken isPatternBlock 
		ifTrue: 
			[node := (self parsePatternBlock: RBPatternWrapperBlockNode)
						wrappedNode: node;
						yourself].
	currentToken isIdentifier] 
			whileTrue: [node := self parseUnaryMessageWith: node].
	self addCommentsTo: node.
	^node!

patchLiteralArrayToken
	(currentToken isIdentifier and: [currentToken isPatternVariable]) 
		ifTrue: [^self].
	super patchLiteralArrayToken!

scannerClass
	^RBPatternScanner!

tempDeclClass
	^self variableNodeClass!

variableNodeClass
	^RBPatternVariableNode! !
!RBPatternParser categoriesFor: #evaluateStatements:!parsing!private! !
!RBPatternParser categoriesFor: #messageNodeClass!constants!private! !
!RBPatternParser categoriesFor: #methodNodeClass!constants!private! !
!RBPatternParser categoriesFor: #parameterNodeClass!constants!private! !
!RBPatternParser categoriesFor: #parseLiteralByteArrayObject!parsing!public! !
!RBPatternParser categoriesFor: #parsePatternBlock:!parsing!private! !
!RBPatternParser categoriesFor: #parsePrimitiveLiteral!parsing!public! !
!RBPatternParser categoriesFor: #parsePrimitiveObject!parsing!private! !
!RBPatternParser categoriesFor: #parseUnaryMessage!parsing!private! !
!RBPatternParser categoriesFor: #patchLiteralArrayToken!helpers!public! !
!RBPatternParser categoriesFor: #scannerClass!accessing!public! !
!RBPatternParser categoriesFor: #tempDeclClass!parsing!private! !
!RBPatternParser categoriesFor: #variableNodeClass!constants!private! !

