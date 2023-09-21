Class {
	#name : #GtRemoteGemstoneForwarderViewExamples,
	#superclass : #GtRemoteForwarderViewInspectionExamples,
	#instVars : [
		'server'
	],
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
	^ self runningServer 
		evaluateAndWait: 'GtRemotePhlowDeclarativeTestInspectable new'
]

{ #category : #'examples - server' }
GtRemoteGemstoneForwarderViewExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'tear down' }
GtRemoteGemstoneForwarderViewExamples >> stopServer [ 

	server ifNotNil: [ 
		server stop.
		server := nil ]
]

{ #category : #accessing }
GtRemoteGemstoneForwarderViewExamples >> targetProxyClass [
	^ GspoGtRemotePhlowDeclarativeTestInspectable
]
