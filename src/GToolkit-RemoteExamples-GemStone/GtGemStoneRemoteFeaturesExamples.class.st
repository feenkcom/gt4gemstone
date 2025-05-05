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
	<return: #AssertionFailure>
	| noStartedSession remoteFeatures |
	noStartedSession := GtRemoteGemstoneExamplesSessionBuilder new createSession.

	remoteFeatures := noStartedSession currentFeatures.
	self assert: noStartedSession notNil.

	self assert: remoteFeatures hasRemoteFeaturesList not
]

{ #category : #examples }
GtGemStoneRemoteFeaturesExamples >> checkRemoteFeaturesIsSupportedWorksOnClosedSession [
	<gtExample>
	<return: #AssertionFailure>
	| noStartedSession |
	noStartedSession := GtRemoteGemstoneExamplesSessionBuilder new createSession.

	self assert: noStartedSession currentFeatures hasGemStoneFeaturesV1 not
]

{ #category : #examples }
GtGemStoneRemoteFeaturesExamples >> currentSessionFeatures [
	<gtExample>
	<return: #AssertionFailure>
	^ self runningServer currentFeatures
]

{ #category : #examples }
GtGemStoneRemoteFeaturesExamples >> currentSessionFeatures_initializationOk [
	<gtExample>
	<return: #AssertionFailure>
	| sessionFeatures |
	sessionFeatures := self currentSessionFeatures.

	sessionFeatures hasGemStoneFeaturesV1 ifFalse: [ ^ self ].

	self assert: sessionFeatures hasRemoteFeaturesList
]

{ #category : #examples }
GtGemStoneRemoteFeaturesExamples >> remoteFeatureSerialization [
	<gtExample>
	<return: #AssertionFailure>
	| newSessionFeatures |
	newSessionFeatures := GtGemStoneRemoteSessionFeatures
			forGemStoneSession: self runningServer
			withFeaturesComputation: [ GtGemStoneSessionFeatures
					withAll: (Array
							with: (GtGemStoneSessionFeature withId: #exampleFeature1)
							with: (GtGemStoneSessionFeature withId: #exampleFeature2) enable) ].

	newSessionFeatures hasGemStoneFeaturesV1 ifFalse: [ ^ self ].

	self assert: newSessionFeatures remoteFeatures size equals: 2.
	self assert: (newSessionFeatures isFeatureEnabledWithId: #exampleFeature1) not.
	self assert: (newSessionFeatures isFeatureEnabledWithId: #exampleFeature2)
]
