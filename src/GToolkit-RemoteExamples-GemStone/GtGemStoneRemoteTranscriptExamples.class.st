Class {
	#name : #GtGemStoneRemoteTranscriptExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> checkRemoteTranscriptAccessorOnClosedSession [
	<gtExample>
	<return: #AssertionFailure>
	| noStartedSession remoteTranscript |
	noStartedSession := GtRemoteGemstoneExamplesSessionBuilder new createSession.

	remoteTranscript := noStartedSession remoteTranscript.
	self assert: noStartedSession notNil.

	self assert: remoteTranscript hasTranscriptProxy not
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> checkTranscriptIsSupportedWorksOnClosedSession [
	<gtExample>
	<return: #AssertionFailure>
	| noStartedSession |
	noStartedSession := GtRemoteGemstoneExamplesSessionBuilder new createSession.

	self assert: noStartedSession currentFeatures hasGemStoneTranscriptV1 not
]

{ #category : #accessing }
GtGemStoneRemoteTranscriptExamples >> currentRemoteTranscript [
	<gtExample>
	<return: #AssertionFailure>
	^ self runningServer remoteTranscript
]

{ #category : #accessing }
GtGemStoneRemoteTranscriptExamples >> currentRemoteTranscript_inspection [
	<gtExample>
	<return: #AssertionFailure>
	self isTranscriptSupported ifFalse: [ ^ self ].

	^ self assertObjectPhlowViewsFor: self currentRemoteTranscript
]

{ #category : #testing }
GtGemStoneRemoteTranscriptExamples >> isTranscriptSupported [
	^ self runningServer currentFeatures hasGemStoneTranscriptV1 
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> toggleTranscriptState [
	<gtExample>
	<return: #AssertionFailure>
	| remoteTranscript currentState |
	self isTranscriptSupported ifFalse: [ ^ self ].

	remoteTranscript := self currentRemoteTranscript.
	currentState := remoteTranscript isEnabled.

	remoteTranscript toggleRemoteTranscript.
	self assert: remoteTranscript isEnabled equals: currentState not .
	
	remoteTranscript toggleRemoteTranscript.
	self assert: remoteTranscript isEnabled equals: currentState .
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> transcriptIsDisableByDefault [
	<gtExample>
	<return: #AssertionFailure>
	self isTranscriptSupported ifFalse: [ ^ self ].

	self assert: self currentRemoteTranscript isEnabled not
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> writeRemotelyToTranscriptWhenDisabled [
	<gtExample>
	<return: #AssertionFailure>
	| remoteTranscript result |
	self isTranscriptSupported ifFalse: [ ^ self ].

	remoteTranscript := self currentRemoteTranscript.
	result := self runningServer
			evaluateBlockAndWaitReturnPrimitive: [ 
				GtGemStoneTranscript current disable.
				GtGemStoneTranscript current show: 'haba2'.
				true ].

	self assert: result
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> writeRemotelyToTranscriptWhenEnabled [
	<gtExample>
	<return: #AssertionFailure>
	| remoteTranscript result |
	self isTranscriptSupported ifFalse: [ ^ self ].

	remoteTranscript := self currentRemoteTranscript.
	result := self runningServer
			evaluateBlockAndWaitReturnPrimitive: [ 
				GtGemStoneTranscript current enable.
				GtGemStoneTranscript current crShow: 'haba2'.
				true ].

	self assert: result
]
