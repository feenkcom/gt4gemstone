Extension { #name : #Dictionary }

{ #category : #'*GToolkit-GemStone-GemStone' }
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
