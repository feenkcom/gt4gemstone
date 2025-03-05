Extension { #name : 'Object' }

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> asGtGsArgument [
	"Answer the the local object of the receiver"

	^ self
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> asGtRsrProxyObjectForConnection: aRsrConnection [
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	(GtRsrEvaluatorService isRsrImmediate: self) ifFalse: 
		[ ^ GtRsrProxyServiceServer object: self ].
	^ self
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> gtDo: gtoolkitBlock gemstoneDo: gemstoneBlock [
	"Evaluate the supplied platform specific block"

	^ gemstoneBlock value
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> instVarNamed: instVarName [
	| index |

	index := self class allInstVarNames indexOf: instVarName.
	index = 0 ifTrue: [ self error: 'Unknown instance variable: ', instVarName printString ].
	^ self instVarAt: index
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> instVarNamed: instVarName put: anObject [
	| index |

	index := self class allInstVarNames indexOf: instVarName.
	index = 0 ifTrue: [ self error: 'Unknown instance variable: ', instVarName printString ].
	self instVarAt: index put: anObject
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> isDictionary [
	^ false
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> isInteger [

	^ false
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> isNotNil [
	^ self ~~ nil
]
