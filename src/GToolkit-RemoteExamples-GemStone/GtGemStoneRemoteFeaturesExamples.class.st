Class {
	#name : #GtGemStoneRemoteFeaturesExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtGemStoneRemoteFeaturesExamples >> checkRemoteFeaturesAccessorOnClosedSession [
	<gtExample>
	| noStartedSession remoteFeatures |
	
	noStartedSession := GtRemoteGemstoneExamplesSessionBuilder new 
		createSession.
		
	remoteFeatures := noStartedSession currentFeatures.
	self assert: noStartedSession notNil.
	
	self assert: remoteFeatures hasRemoteFeaturesList not.
]

{ #category : #examples }
GtGemStoneRemoteFeaturesExamples >> checkRemoteFeaturesIsSupportedWorksOnClosedSession [
	<gtExample>
	| noStartedSession |
	
	noStartedSession := GtRemoteGemstoneExamplesSessionBuilder new 
		createSession.
		
	self assert: noStartedSession currentFeatures hasGemStoneFeaturesV1 not
]

{ #category : #examples }
GtGemStoneRemoteFeaturesExamples >> currentRemoteFeatures [
	<gtExample>
	^ self runningServer currentFeatures
]
