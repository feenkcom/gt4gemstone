Class {
	#name : #GtGemStoneRemoteTranscriptExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #accessing }
GtGemStoneRemoteTranscriptExamples >> currentRemoteTranscript [
	<gtExample>
	^ self runningServer remoteTranscript
]

{ #category : #accessing }
GtGemStoneRemoteTranscriptExamples >> currentRemoteTranscript_inspection [
	<gtExample>
	
	self isTranscriptSupported ifFalse: [ ^ self ].
	
	^ self assertObjectPhlowViewsFor: self currentRemoteTranscript
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> enableTranscriptThroughToggle [
	<gtExample>
	| remoteTranscript |
	self isTranscriptSupported ifFalse: [ ^ self ].
	
	remoteTranscript := self currentRemoteTranscript.
	self assert: remoteTranscript isEnabled not.
	
	remoteTranscript toggleRemoteTranscript.
	self assert: remoteTranscript isEnabled.
]

{ #category : #testing }
GtGemStoneRemoteTranscriptExamples >> isTranscriptSupported [
	^ self runningServer currentFeatures hasGemStoneTranscriptV1 
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> transcriptIsDisabledByDefault [
	<gtExample>
	self isTranscriptSupported ifFalse: [ ^ self ].
	
	self assert: self currentRemoteTranscript isEnabled not
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> writeRemotelyToTranscriptWhenDisabled [
	<gtExample>
	| remoteTranscript result |
	self isTranscriptSupported ifFalse: [ ^ self ].
	
	remoteTranscript := self currentRemoteTranscript.
	result := self runningServer evaluateBlockAndWaitReturnPrimitive:  [
		GtGemStoneTranscript current disable.
		GtGemStoneTranscript current 
			show: 'haba2'.
		true ].
		
	self assert: result
]

{ #category : #examples }
GtGemStoneRemoteTranscriptExamples >> writeRemotelyToTranscriptWhenEnabled [
	<gtExample>
	| remoteTranscript result |
	self isTranscriptSupported ifFalse: [ ^ self ].
	
	remoteTranscript := self currentRemoteTranscript.
	result := self runningServer evaluateBlockAndWaitReturnPrimitive:  [
		GtGemStoneTranscript current enable.
		GtGemStoneTranscript current 
			crShow: 'haba2'.
		true ].
		
	self assert: result
]
