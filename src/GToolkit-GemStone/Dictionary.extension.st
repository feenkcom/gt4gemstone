Extension { #name : 'Dictionary' }

{ #category : '*GToolkit-GemStone' }
Dictionary >> asGtRsrProxyObjectForConnection: aRsrConnection [
	"Answer the receiver with unsupported (non-immediate) objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet.
	For Dictionaries, for now all keys must be immediate."
	| proxyDict |

	self assert: (self keys allSatisfy: [ :key | 
		GtRsrEvaluatorService isRsrImmediate: key ]).
	proxyDict := self class new: self size.
	self keysAndValuesDo: [ :key :value |
		proxyDict
			at: key 
			put: (value asGtRsrProxyObjectForConnection: aRsrConnection) ].
	^ proxyDict
]
