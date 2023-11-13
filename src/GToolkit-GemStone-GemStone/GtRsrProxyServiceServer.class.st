Class {
	#name : 'GtRsrProxyServiceServer',
	#superclass : 'GtRsrProxyService',
	#instVars : [
		'object'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'other' }
GtRsrProxyServiceServer class >> object: anObject [

	^ self new object: anObject
]

{ #category : 'private' }
GtRsrProxyServiceServer >> basicPerform: aSymbol withArguments: anArray [
	"Perform the requested operation, catching errors and returning exception information"
	| convertedArguments semaphore evaluationProcess result |

	convertedArguments := anArray collect: [ :anObject |
		(anObject isKindOf: self class) 
			ifTrue: [ anObject object ]
			ifFalse: [ anObject ] ].

	^ GtGemStoneEvaluationContext new
		evaluateBlock: [ object perform: aSymbol withArguments: convertedArguments ]
		from: self.
]

{ #category : 'accessing' }
GtRsrProxyServiceServer >> object [
	"Answer the object being proxied"

	^ object
]

{ #category : 'accessing' }
GtRsrProxyServiceServer >> object: anObject [
	"Set the object being proxied"

	object := anObject.
	remoteClass := anObject class name.
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerform: aSymbol [

	^ (self basicPerform: aSymbol withArguments: #()) asGtRsrProxyObjectForConnection: _connection
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerform: aSymbol serializationStrategy: serializationSymbol [

	^ (Globals at: serializationSymbol) new serialize: (self basicPerform: aSymbol withArguments: #())
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerform: aSymbol withArguments: anArray [

	^ (self basicPerform: aSymbol withArguments: anArray) asGtRsrProxyObjectForConnection: _connection
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerform: aSymbol withArguments: anArray serializationStrategy: serializationSymbol [

	^ (Globals at: serializationSymbol) new serialize:
		(self basicPerform: aSymbol withArguments: anArray)
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerformReturnProxy: aSymbol [
	| result |

	result := self basicPerform: aSymbol withArguments: #().
	result class == self class ifTrue: [ ^ result ].
	^ self class object: result.
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerformReturnProxy: aSymbol withArguments: anArray [
	| result |

	result := self basicPerform: aSymbol withArguments: anArray.
	result class = self class ifTrue: [ ^ result ].
	^ self class object: result.
]
