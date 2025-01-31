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
Object >> isInteger [

	^ false
]
