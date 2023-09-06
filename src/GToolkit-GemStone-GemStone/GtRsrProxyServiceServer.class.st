Class {
	#name : #GtRsrProxyServiceServer,
	#superclass : #GtRsrProxyService,
	#instVars : [
		'object'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #other }
GtRsrProxyServiceServer class >> object: anObject [

	^ self new object: anObject
]

{ #category : #private }
GtRsrProxyServiceServer >> basicPerform: aSymbol withArguments: anArray [
	"Perform the requested operation, catching errors and returning exception information"
	| convertedArguments semaphore evaluationProcess result |

	convertedArguments := anArray collect: [ :anObject |
		(anObject isKindOf: self class) 
			ifTrue: [ anObject object ]
			ifFalse: [ anObject ] ].

	semaphore := Semaphore new.
	evaluationProcess := [ [ result := object perform: aSymbol withArguments: convertedArguments.
									semaphore signal ]
		on: Exception
		do: [ :ex |
			result := (GtRsrEvaluationExceptionInformation new
				exception: ex;
				process: evaluationProcess)
					asGtRsrProxyObjectForConnection: _connection.
			semaphore signal.
			evaluationProcess suspend ]
				] newProcess.
	evaluationProcess debugActionBlock: [ :ex |
		result := (GtRsrEvaluationExceptionInformation new
			exception: ex;
			process: evaluationProcess)
				asGtRsrProxyObjectForConnection: _connection.
		semaphore signal.
		evaluationProcess suspend ].
	evaluationProcess
		name: 'GT proxyPerform';
		priority: 15;
		breakpointLevel: 1.
	evaluationProcess resume.
	semaphore wait.

	^ result
]

{ #category : #accessing }
GtRsrProxyServiceServer >> object [
	"Answer the object being proxied"

	^ object
]

{ #category : #accessing }
GtRsrProxyServiceServer >> object: anObject [
	"Set the object being proxied"

	object := anObject.
	remoteClass := anObject class name.
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerform: aSymbol [

	^ (self basicPerform: aSymbol withArguments: #()) asGtRsrProxyObjectForConnection: _connection
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerform: aSymbol serializationStrategy: serializationSymbol [

	^ (Globals at: serializationSymbol) new serialize: (self basicPerform: aSymbol withArguments: #())
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerform: aSymbol withArguments: anArray [

	^ (self basicPerform: aSymbol withArguments: anArray) asGtRsrProxyObjectForConnection: _connection
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerform: aSymbol withArguments: anArray serializationStrategy: serializationSymbol [

	^ (Globals at: serializationSymbol) new serialize:
		(self basicPerform: aSymbol withArguments: anArray)
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerformReturnProxy: aSymbol [
	| result |

	result := self basicPerform: aSymbol withArguments: #().
	result class == self class ifTrue: [ ^ result ].
	^ self class object: result.
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerformReturnProxy: aSymbol withArguments: anArray [
	| result |

	result := self basicPerform: aSymbol withArguments: anArray.
	result class = self class ifTrue: [ ^ result ].
	^ self class object: result.
]
