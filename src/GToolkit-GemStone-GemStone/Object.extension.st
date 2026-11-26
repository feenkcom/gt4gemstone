Extension { #name : #Object }

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> asGtGsArgument [
	"Answer the the local object of the receiver"

	^ self
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> asGtRsrProxyObjectForConnection: aRsrConnection [
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	(GtRsrEvaluatorService isRsrImmediate: self) ifFalse: 
		[ ^ GtRsrProxyServiceServer object: self ].
	^ self
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> gtDo: gtoolkitBlock gemstoneDo: gemstoneBlock [
	"Evaluate the supplied platform specific block"

	^ gemstoneBlock value
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> instVarNamed: instVarName [
	"Pharo accepts a String or a Symbol. allInstVarNames holds Symbols, and a String isn't = to a Symbol in GemStone."
	| index |

	index := self class allInstVarNames indexOf: instVarName asSymbol.
	index = 0 ifTrue: [ self error: 'Unknown instance variable: ', instVarName printString ].
	^ self instVarAt: index
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> instVarNamed: instVarName put: anObject [
	"Pharo accepts a String or a Symbol. allInstVarNames holds Symbols, and a String isn't = to a Symbol in GemStone."
	| index |

	index := self class allInstVarNames indexOf: instVarName asSymbol.
	index = 0 ifTrue: [ self error: 'Unknown instance variable: ', instVarName printString ].
	self instVarAt: index put: anObject
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> isDictionary [
	^ false
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> isInteger [

	^ false
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> isNotNil [
	^ self ~~ nil
]

{ #category : #'*GToolkit-GemStone-GemStone' }
Object >> sameContentAs: anObject [
	"Answer whether the receiver and anObject are equal.
	CharacterCollection compares Strings and Symbols by their characters; collections compare their elements with this message"

	^ self = anObject
]
