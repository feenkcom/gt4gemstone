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

{ #category : #'examples - remove' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> removeAllElements [
	<gtExample>
	
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	
	^ super removeAllElements
]

{ #category : #'examples - remove' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> removeConsecutiveElements [
	<gtExample>
	
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	
	^ super removeConsecutiveElements
]

{ #category : #'examples - remove' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> removeDuplicateByIndex [
	<gtExample>
	
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	
	^ super removeDuplicateByIndex
]

{ #category : #'examples - remove' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> removeNonConsecutiveElements [
	<gtExample>
	
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	
	^ super removeNonConsecutiveElements
]

{ #category : #'examples - remove' }
GtRemotePhlowViewRemoveActionGemStoneExamples >> removeSingleElement [
	<gtExample>
	
	self runningServer 
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_533 
		do: [ ^ self ].
	
	^ super removeSingleElement
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
