Class {
	#name : #GtRsrProxyServiceServer,
	#superclass : #GtRsrProxyService,
	#instVars : [
		'object'
	],
	#category : #'GToolkit-GemStone-GemStone'
}

{ #category : #'instance creation' }
GtRsrProxyServiceServer class >> object: anObject [

	^ self registeredObjects
		at: anObject
		ifPresent: [ :sid | (SessionTemps current at: #GtRsrServer) _connection serviceAt: sid ifAbsent: [ self new object: anObject ] ]
		ifAbsent: [ self new object: anObject ]
]

{ #category : #accessing }
GtRsrProxyServiceServer class >> registeredObjects [

	^ SessionTemps current
		at: #GtRsrRegisteredObjects
		ifAbsentPut: [ GtThreadSafeIdentityDictionary new ]
]

{ #category : #private }
GtRsrProxyServiceServer >> _id: anRsrId connection: aConnection [

	super _id: anRsrId connection: aConnection.
	(GtRsrEvaluatorService isRsrImmediate: object) ifFalse:
		[ GtRsrProxyServiceServer registeredObjects at: object put: anRsrId ].
]

{ #category : #accessing }
GtRsrProxyServiceServer >> asGtGsArgument [
	"Answer the the local object of the receiver"

	^ object
]

{ #category : #private }
GtRsrProxyServiceServer >> basicPerform: aSymbol withArguments: anArray  serializationStrategy: aSerialisationStrategySymbol [
	"Perform the requested operation, catching errors and returning exception information"

	SessionTemps current at: #GtRsrServer put: self.

	^ (GtGemStoneEvaluationContext new
		serializationStrategy: aSerialisationStrategySymbol)
			evaluateAndWaitBlock: [ 
				object perform: aSymbol withArguments: anArray asGtGsArgument ]
			from: self.
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
	^ self proxyPerform: aSymbol withArguments: #()
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerform: aSymbol serializationStrategy: serializationSymbol [
	^ self 
		proxyPerform: aSymbol 
		withArguments: #() 
		serializationStrategy: serializationSymbol
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerform: aSymbol withArguments: anArray [
	^ self 
		proxyPerform: aSymbol 
		withArguments: anArray
		serializationStrategy: #GtRsrLegacySerializationStrategy
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerform: aSymbol withArguments: anArray serializationStrategy: aSerializationStrategySymbol [
	| evaluationResult |

	evaluationResult := self 
		basicPerform: aSymbol 
		withArguments: anArray 
		serializationStrategy: aSerializationStrategySymbol.

	^ evaluationResult ifNotNil: [ :anEvaluationResult |  
		anEvaluationResult asDictionaryForExport ]
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerformReturnProxy: aSymbol [
	^ self proxyPerformReturnProxy: aSymbol withArguments: #()
]

{ #category : #performing }
GtRsrProxyServiceServer >> proxyPerformReturnProxy: aSymbol withArguments: anArray [
	^ self 
		proxyPerform: aSymbol 
		withArguments: anArray
		serializationStrategy: #GtRsrProxyOnlySerializationStrategy
]
