Extension { #name : 'Dictionary' }

{ #category : '*GToolkit-GemStone-GemStone' }
Dictionary >> , aCollection [
	^self copy addAll: aCollection; yourself
]

{ #category : '*GToolkit-GemStone-GemStone' }
Dictionary >> asGtGsArgument [
	"Answer the the local object of the receiver"
	| local |

	local := self copy.
	local associationsDo: [ :assoc |
		assoc value: assoc value asGtGsArgument ].
	^ local
]

{ #category : '*GToolkit-GemStone-GemStone' }
Dictionary >> asGtRsrProxyObjectForConnection: aRsrConnection [
	"Answer the receiver with unsupported (non-immediate) objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet.
	If not all keys are immediate, answer the entire dictionary as a proxy."

	| proxyDict |

	(self keys allSatisfy: [ :key | GtRsrEvaluatorService isRsrImmediate: key ]) ifFalse:
		[ ^ GtRsrProxyServiceServer object: self ].
	proxyDict := self class new: self size.
	self keysAndValuesDo: [ :key :value |
		proxyDict
			at: key 
			put: (value asGtRsrProxyObjectForConnection: aRsrConnection) ].
	^ proxyDict
]

{ #category : '*GToolkit-GemStone-GemStone' }
Dictionary >> associations [
	^Array new: self size streamContents: [ :stream |
		self associationsDo: [ :each | stream nextPut: each ] ]
]
