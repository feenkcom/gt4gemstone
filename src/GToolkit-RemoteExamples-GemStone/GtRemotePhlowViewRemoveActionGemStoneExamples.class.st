Class {
	#name : #GtRemotePhlowViewRemoveActionGemStoneExamples,
	#superclass : #GtRemotePhlowViewRemoveActionExamples,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #testing }
GtRemotePhlowViewRemoveActionGemStoneExamples class >> isAbstract [
	^ self name = #GtRemotePhlowViewRemoveActionGemStoneExamples
]

{ #category : #private }
GtRemotePhlowViewRemoveActionGemStoneExamples >> createProxyObjectFor: aBlock [
	^ self convertToTargetProxy:
		(self runningServer evaluateBlockAndWaitReturnProxy: aBlock)
]

{ #category : #'examples - setup' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> createTestCollection [
	<gtExample>
	<after: #stopServer>
	^ self createProxyObjectFor: [ OrderedCollection withAll: #(10 20 30 20 40 50 20 60) ]
]

{ #category : #private }
GtRemotePhlowViewRemoveActionGemStoneExamples >> orderedCollectionDisplayName [
	^ 'anOrderedCollection'
]

{ #category : #'examples - setup' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> runningServer [
	<gtExample>
	<after: #stopServer>
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'examples - setup' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> stopServer [
	server ifNotNil: [ 
		server stop.
		server := nil ]
]

{ #category : #private }
GtRemotePhlowViewRemoveActionGemStoneExamples >> wrapTestObject: anObject [
	^ self createProxyObjectFor: [ anObject ]
]
