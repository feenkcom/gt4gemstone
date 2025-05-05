Class {
	#name : #GtRemoteGemstoneForwarderViewExamples,
	#superclass : #GtRemotePhlowForwarderViewInspectionExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #accessing }
GtRemoteGemstoneForwarderViewExamples >> assertTransformedValueInListFor: aTransformedValue [ 
	self assert: aTransformedValue size equals: 2.
	self assert: (aTransformedValue 
		allSatisfy: [ :each | each class == GtGsBareProxy ]).
	self 
		assert: (aTransformedValue collect: [ :aProxy |
			aProxy asGtProxyObject 
				proxyPerform: #yourself 
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy. ])
		equals: { 42 . 42 }
]

{ #category : #accessing }
GtRemoteGemstoneForwarderViewExamples >> computeObject [
	<gtExample>
	<return: #AssertionFailure>
	^ self runningServer
		evaluateAndWait: 'GtRemotePhlowDeclarativeTestInspectable new'
]

{ #category : #accessing }
GtRemoteGemstoneForwarderViewExamples >> targetProxyClass [
	^ GspoGtRemotePhlowDeclarativeTestInspectable
]
